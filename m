Return-Path: <linux-kernel-owner+w=401wt.eu-S1751187AbXCZNw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbXCZNw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 09:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbXCZNw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 09:52:27 -0400
Received: from www.osadl.org ([213.239.205.134]:42781 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751187AbXCZNw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 09:52:26 -0400
Subject: Re: [PATCH] i386: add command line option "local_apic_timer_c2_ok"
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
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
In-Reply-To: <20070326123141.GA11288@ucw.cz>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070318184908.GU752@stusta.de>
	 <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org>
	 <46020385.50301@yahoo.com.au>
	 <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org>
	 <1174612132.16068.114.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org>
	 <20070323114223.GA23483@elte.hu>
	 <1174650969.10840.274.camel@localhost.localdomain>
	 <1174662481.10840.292.camel@localhost.localdomain>
	 <20070326123141.GA11288@ucw.cz>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 15:52:22 +0200
Message-Id: <1174917142.4182.39.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 12:31 +0000, Pavel Machek wrote:
> > +	lapic_timer_c2_ok	[IA-32,APIC] trust the local apic timer in
> > +			C2 power state.
> > +
> 
> Could you add comment saying that this is always ok on non-broken
> systems? That way perhaps it can be added to linux-firmware-test-cd,
> etc.

Yep, post .21. 

I still twist my brain how to autodetect that in a safe way, which would
make it really useful for the firmware tester.

	tglx


