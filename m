Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbYD0BGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbYD0BGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 21:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYD0BGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 21:06:40 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51421 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbYD0BGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 21:06:39 -0400
Date: Sun, 27 Apr 2008 04:06:14 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080427010614.GX2252@cs181133002.pp.htv.fi>
References: <1208793533.3640.24.camel@localhost.localdomain> <20080421195148.GG8770@elte.hu> <20080421200949.GB2633@cs181133002.pp.htv.fi> <20080421201352.GM8770@elte.hu> <20080421202605.GC2633@cs181133002.pp.htv.fi> <20080421202919.GA28069@elte.hu> <20080421210232.GD2633@cs181133002.pp.htv.fi> <20080421223142.GA18140@elte.hu> <20080426074300.GA3891@ucw.cz> <4813CC6A.6030307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4813CC6A.6030307@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 05:44:26PM -0700, H. Peter Anvin wrote:
> Pavel Machek wrote:
>>
>> I guess Adrian is trying to say:
>>
>> 'That code is in tree, so it should compile and run. He can't verify
>> it runs, but he's trying to make sure it at least compiles.'
>>
>> For 'normal' users it is not a problem.
>> 							Pavel
>
> This is fine, except it is an unreasonable request when there are fewer  
> existing machines than people contributing to this tree.  For a lot of  
> people, compile bandwidth is what is limiting their ability to 
> contribute.

I'm not claiming it was the end of the world if someone accidentally 
breaks Voyager.

But Ingo wanted me to stop to sometimes compile test Voyager.

> James has offered to fix up Voyager breakage a posteori, and that is the  
> appropriate action for a niche architecture like this.

I'm still not getting the point why we should ever wait for James for 
doing things like
-       select HAVE_ARCH_KGDB
+       select HAVE_ARCH_KGDB if !X86_VOYAGER

And the other compile breakages we had recently weren't much worse.

I fully agree that it makes sense that Voyager problems should not be 
showstoppers and that James is the one capable and responsible of fixing 
non-trivial issues.

> 	-hpa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

