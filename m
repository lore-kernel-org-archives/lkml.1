Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZFYAES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZFYAES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 20:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbZFYAEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 20:04:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:53308 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbZFYAEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 20:04:05 -0400
References: <20090624122433.GA24781@elte.hu> <20090624145119.GA12664@elte.hu> <4A429EBB.5010209@kernel.org> <4A429F29.4070007@kernel.org> <20090624153748.2ba17aea@jbarnes-g45>
Message-Id: <900A47A2-1B40-4DD7-8052-EBBD493C9457@kernel.org>
From: Yinghai <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20090624153748.2ba17aea@jbarnes-g45>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7A341)
Mime-Version: 1.0 (iPhone Mail 7A341)
Subject: Re: [PATCH] x86/pci: get root CRS before scan child -v2
Date: Wed, 24 Jun 2009 17:03:14 -0700
Cc: Ingo Molnar <mingo@elte.hu>, Gary Hade <garyhade@us.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Jun 24, 2009, at 3:37 PM, Jesse Barnes <jbarnes@virtuousgeek.org>  
wrote:

> On Wed, 24 Jun 2009 14:48:25 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
>
>>
>> so we could remove adjust_transparent_bridge_resources..
>>
>> and give x86_pci_root_bus_res_quirks chance when _CRS is not used or
>> not there.
>>
>> v2: add print out if pci conf reading for res is used for root
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> Do you think this is generally safe?  I was hoping we could do
> something more complete, like making the code handle arbitrary numbers
> of resources in _CRS.  Hacking that together now.

Should be safe

YH

