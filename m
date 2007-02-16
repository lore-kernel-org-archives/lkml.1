Return-Path: <linux-kernel-owner+w=401wt.eu-S1422848AbXBPA0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422848AbXBPA0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422856AbXBPA0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:26:09 -0500
Received: from mta13.adelphia.net ([68.168.78.44]:59225 "EHLO
	mta13.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422848AbXBPA0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:26:07 -0500
Message-ID: <45D4FA1B.5060003@acm.org>
Date: Thu, 15 Feb 2007 18:26:03 -0600
From: Corey Minyard <minyard@acm.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Mackerras <paulus@samba.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/4] ipmi: add new IPMI nmi watchdog handling
References: <20070214201257.GD5364@localdomain>	<20070214195718.e78458cf.akpm@linux-foundation.org>	<17875.56356.396676.239952@cargo.ozlabs.ibm.com>	<20070214201632.a7f18794.akpm@linux-foundation.org>	<45D480FB.4030503@acm.org> <20070215142124.4a6733fc.akpm@linux-foundation.org>
In-Reply-To: <20070215142124.4a6733fc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 15 Feb 2007 09:49:15 -0600
> Corey Minyard <minyard@acm.org> wrote:
>
>   
>> So I see the following options besides what's already there:
>>
>> 1) add asm/kdebug.h and DIE_NMI_POST to everything that might have an 
>> IPMI implementation.
>> 2) use CONFIG_X86 to tell if NMI will work, since that's the only thing 
>> it will work on at the present.
>>
>> I don't have any way to know how different systems have implemented that 
>> feature, so I can't actually implement it for the various architectures 
>> (plus I don't have any of those boards).  So maybe #2 is the best?
>>     
>
> I tend to think that #1 is the best option - it keeps things consistent
> and it gives arch/board maintainers a framework in which to add the
> support code at their leisure.   But it's something which would be best
> worked through with the affected arch maintainers, please.
>
> Which architectures are we talking about here?  ia64 and ppc?
>   
I'm not 100% sure, to tell you there truth.  I know there are ARM, PPC,
x86, SPARC, ia64, and MIPS systems that have IPMI.  But you can stick
it on anything, really.  I'd like to be able to have basic support work
without having to add arch-specific things for one feature of the driver.

-Corey
