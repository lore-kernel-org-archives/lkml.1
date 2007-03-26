Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbXCZOd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbXCZOd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 10:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbXCZOd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 10:33:59 -0400
Received: from www.osadl.org ([213.239.205.134]:50465 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752741AbXCZOd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 10:33:58 -0400
Subject: Re: [patch] hrtimers debug patch
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <6bffcb0e0703260720i37bbb956o3d20019fe4ac9879@mail.gmail.com>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org>
	 <46020385.50301@yahoo.com.au>
	 <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org>
	 <1174612132.16068.114.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org>
	 <20070323021115.GA11147@wotan.suse.de>
	 <6bffcb0e0703230051i5accb180r7bd0fb16de85198a@mail.gmail.com>
	 <20070323120148.GA27505@elte.hu> <4607BDD9.1010002@googlemail.com>
	 <6bffcb0e0703260720i37bbb956o3d20019fe4ac9879@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 16:33:55 +0200
Message-Id: <1174919635.4182.51.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 16:20 +0200, Michal Piotrowski wrote:
> >
> > I've got a crash dump, I'll try to figure out what is causing it ;)
> >
> 
> That might be useful
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5/

Can you please upload a disassembly of hrtimer_interrupt() ?

I stared at hrtimer_interrupt() for quite a long time and I don't see
how it can leave without reprogramming the event, when there are timers
pending. And there are enough timers pending.

	tglx


