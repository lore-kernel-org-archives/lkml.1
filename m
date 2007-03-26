Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbXCZMb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbXCZMb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 08:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXCZMb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 08:31:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3119 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752440AbXCZMb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 08:31:58 -0400
Date: Mon, 26 Mar 2007 12:31:42 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Thomas Renninger <trenn@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] i386: add command line option "local_apic_timer_c2_ok"
Message-ID: <20070326123141.GA11288@ucw.cz>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070318184908.GU752@stusta.de> <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org> <46020385.50301@yahoo.com.au> <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org> <1174612132.16068.114.camel@localhost.localdomain> <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org> <20070323114223.GA23483@elte.hu> <1174650969.10840.274.camel@localhost.localdomain> <1174662481.10840.292.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174662481.10840.292.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> It turned out that it is almost impossible to trust ACPI, BIOS & Co.
> regarding the C states. This was the reason to switch the local apic
> timer off in C2 state already. OTOH there are sane and well behaving
> systems, which get punished by that decision.
> 
> Allow the user to confirm that the local apic timer is trustworthy in C2
> state. This keeps the default behaviour on the safe side.
...
> @@ -780,6 +780,9 @@ and is between 256 and 4096 characters. It is defined in the file
>  	lapic		[IA-32,APIC] Enable the local APIC even if BIOS
>  			disabled it.
>  
> +	lapic_timer_c2_ok	[IA-32,APIC] trust the local apic timer in
> +			C2 power state.
> +

Could you add comment saying that this is always ok on non-broken
systems? That way perhaps it can be added to linux-firmware-test-cd,
etc.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
