Return-Path: <linux-kernel-owner+w=401wt.eu-S934370AbZHEN2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370AbZHEN2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934347AbZHEN2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:28:18 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:9263
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934340AbZHEN2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:28:18 -0400
Message-ID: <4A7988F0.2010208@panasas.com>
Date: Wed, 05 Aug 2009 16:28:16 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090722 Remi/fc10 Thunderbird/3.0b3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: Tree for August 5
References: <20090805172337.b0688db1.sfr@canb.auug.org.au>	<4A793EA8.50306@panasas.com> <20090805201336.fd2de2ad.sfr@canb.auug.org.au>
In-Reply-To: <20090805201336.fd2de2ad.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Aug 2009 13:28:18.0718 (UTC) FILETIME=[985E53E0:01CA15D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2009 01:13 PM, Stephen Rothwell wrote:
> Hi Boaz,
> 
> On Wed, 05 Aug 2009 11:11:20 +0300 Boaz Harrosh <bharrosh@panasas.com> wrote:
>>
>> On 08/05/2009 10:23 AM, Stephen Rothwell wrote:
>>>
>>> This tree fails to build for powerpc allyesconfig (final link problem).
>>
>> Above is reported for a long time. Is it related to this:
>> http://www.spinics.net/lists/kernel/msg921978.html
> 
> No, it is this:
> 
> powerpc-linux-ld: TOC section size exceeds 64k
> 
> It is powerpc specific and the only way we can think of fixing it
> involves stopping building the built-in.o files and linking the entire
> kernel in one go at the end.  We just haven't had time (or the energy) to
> try to fix it properly while it only affects the final link of the
> allyesconfig kernel. 
> 

Ha, OK allyesconfig. Last time I attempted an allyesconfig for i386 I got
me the OOM killer attack on my KDE, half way into the final link.

That's why I use allmodconfig for when I need "try to compile everything ++"
I get just as much compilation coverage if not more. And is faster.
It'll not show symbol conflicts if any exist, though.

Thanks
Boaz
