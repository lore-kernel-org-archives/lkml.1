Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbYD0Bqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbYD0Bqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 21:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYD0Bqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 21:46:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51058 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYD0Bqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 21:46:43 -0400
Message-ID: <4813DAD5.50509@zytor.com>
Date: Sat, 26 Apr 2008 18:45:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
References: <1208793533.3640.24.camel@localhost.localdomain> <20080421195148.GG8770@elte.hu> <20080421200949.GB2633@cs181133002.pp.htv.fi> <20080421201352.GM8770@elte.hu> <20080421202605.GC2633@cs181133002.pp.htv.fi> <20080421202919.GA28069@elte.hu> <20080421210232.GD2633@cs181133002.pp.htv.fi> <20080421223142.GA18140@elte.hu> <20080426074300.GA3891@ucw.cz> <4813CC6A.6030307@zytor.com> <20080427010614.GX2252@cs181133002.pp.htv.fi>
In-Reply-To: <20080427010614.GX2252@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> 
> I'm not claiming it was the end of the world if someone accidentally 
> breaks Voyager.
> 
> But Ingo wanted me to stop to sometimes compile test Voyager.
> 

It would be good if "make randconfig" didn't go down this or other 
"secondary" paths.

>> James has offered to fix up Voyager breakage a posteori, and that is the  
>> appropriate action for a niche architecture like this.
> 
> I'm still not getting the point why we should ever wait for James for 
> doing things like
> -       select HAVE_ARCH_KGDB
> +       select HAVE_ARCH_KGDB if !X86_VOYAGER
> 
> And the other compile breakages we had recently weren't much worse.
> 
> I fully agree that it makes sense that Voyager problems should not be 
> showstoppers and that James is the one capable and responsible of fixing 
> non-trivial issues.

That's fine, IMHO, just don't require *other* people to worry about it.

	-hpa
