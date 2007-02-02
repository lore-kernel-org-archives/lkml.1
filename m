Return-Path: <linux-kernel-owner+w=401wt.eu-S1423061AbXBBBck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423061AbXBBBck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 20:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423063AbXBBBck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 20:32:40 -0500
Received: from mga05.intel.com ([192.55.52.89]:43219 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423061AbXBBBcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 20:32:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,269,1167638400"; 
   d="scan'208"; a="194828187:sNHT275615109"
Message-ID: <45C294AA.9000400@linux.intel.com>
Date: Fri, 02 Feb 2007 09:32:26 +0800
From: "bibo,mao" <bibo_mao@linux.intel.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: Frederic Riss <frederic.riss@gmail.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       artiom.myaskouvskey@intel.com, akpm@osdl.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] EFI x86: pass firmware call parameters on the stack
References: <1170183678.21603.73.camel@funkylaptop>	 <200701301217.47520.bjorn.helgaas@hp.com>	 <1170189677.21603.102.camel@funkylaptop>	 <45C1513F.1000706@linux.intel.com> <87d3b2040702010010h7534cc9cte1605e5cecd56025@mail.gmail.com>
In-Reply-To: <87d3b2040702010010h7534cc9cte1605e5cecd56025@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Riss wrote:
> 2007/2/1, bibo,mao <bibo_mao@linux.intel.com>:
>> currently x86_64 kernel does not support efi, efi convention comply to
>> MS convention. On ia32 parameter is passed on stack, on x86_64 parameter
>> is passed by registers but that is different from x86_64 linux 
>> convention.
> 
> Is an x86_64 EFI firmware required to have 2 entry points, one x86_64
> and one in ia32 mode ? If that's not the case, it means that an i386
> kernel won't be able to work correctly on an EFI powered x86_64 box...
> 
AFAIK x86_64 EFI firmware now has only one entry point, i386 kernel
can not boot up with EFI powered x86_64 box.

>> How about adding EFIAPI prefix before efi runtime service function, this
>> prefix has different definition in different architecture.
> 
> Have you any objection to the second patch I posted? It's not only a
> matter of passing arguments, ia64 does quite a lot of things in its
> wrapper functions. I can easily imagine that such additional work
> could be added in the i386 wrappers if EFI becomes more widely used.
> 
I do not object your second patch if there will be more wrapper functions
 to be added in i386 efi code. I have to give up my patch:)

thanks
bibo,mao
