Return-Path: <linux-kernel-owner+w=401wt.eu-S1764114AbXHAMWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764114AbXHAMWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759724AbXHAMW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:22:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:65205 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbXHAMW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:22:28 -0400
Message-ID: <46B07AF8.9080406@windriver.com>
Date: Wed, 01 Aug 2007 07:22:16 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm2
References: <20070731230932.a9459617.akpm@linux-foundation.org> <20070801062501.GB7581@linux-sh.org>
In-Reply-To: <20070801062501.GB7581@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Aug 2007 12:22:15.0626 (UTC) FILETIME=[98903AA0:01C7D436]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On Tue, Jul 31, 2007 at 11:09:32PM -0700, Andrew Morton wrote:
>   
>> - Is anyone testing the kgdb code in here?
>>
>>     
> Testing, yes. Succeeding, no. It's utterly hosed on SH in its present
> condition at least. Presumably it's been tested on at least one platform
> with some measure of success, but it's certainly not mine ;-)
>
> I'll get you some patches that fix it up the rest of the way for SH
> platforms in the next couple days. There's nothing too rough, though,
> mostly serial driver fallout and changes in the current stub that aren't
> reflected in the 'new' one.
>   
Sh "not working" is a side effect of the fact that there is no one 
maintaining the sh kgdb work.  As an example, the sh-lite.patch which is 
part of the kgdb git tree explicitly says that the sh-sci.c needs to be 
"re-ported".  There were many changes since the 2.6.17 code base that 
KGDB was upreved from and the fact of the matter is that I have no sh 
hardware, tool chain, or means to support it.   I will happily merge in 
the pieces to fix up the sh kgdb arch specifics.  The same was true of 
IA64 at first (meaning it did not work), but Bob Pico submitted some 
further patches and IA64 is should compile build and work with kgdb.

In the development branch, the kgdb core is compiled and test and should 
work for the archs i386, x86_64, ppc, powerpc (32 & 64), mips (32 & 64) 
and arm.

Jason.
