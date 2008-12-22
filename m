Return-Path: <linux-kernel-owner+w=401wt.eu-S1757027AbYLVWR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbYLVWR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbYLVWQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:16:51 -0500
Received: from www.tglx.de ([62.245.132.106]:34433 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbYLVWQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:16:50 -0500
Date: Mon, 22 Dec 2008 23:16:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fabio Comolli <fabio.comolli@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, toralf.foerster@gmx.de
Subject: Re: TSC not updating after resume: Bug or Feature?
In-Reply-To: <b637ec0b0812221412w396337embad90f599a02d3d9@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0812222315460.3723@localhost.localdomain>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net>  <b637ec0b0812211443u1ca9c11du5d61c41e3d82bc16@mail.gmail.com>  <alpine.LFD.2.00.0812221543550.3723@localhost.localdomain>  <20081222150021.GA13839@elte.hu>  <alpine.LFD.2.00.0812221921460.3723@localhost.localdomain>
  <alpine.LFD.2.00.0812222056190.3723@localhost.localdomain>  <b637ec0b0812221239p169967aemf14b2e591779f5cd@mail.gmail.com>  <alpine.LFD.2.00.0812222212191.3723@localhost.localdomain>  <b637ec0b0812221335w54fe11ecwf05e0302bc27b5a3@mail.gmail.com> 
 <alpine.LFD.2.00.0812222238192.3723@localhost.localdomain> <b637ec0b0812221412w396337embad90f599a02d3d9@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 22 Dec 2008, Fabio Comolli wrote:

> Won't apply:
> 
> fcomolli@hawking:~/software/GIT-TREES/linux-2.6> patch -p1 --dry-run <
> /home/fcomolli/0009c-tglx-debug.patch
> patching file kernel/sched_clock.c
> patching file kernel/time/timekeeping.c
> Hunk #1 succeeded at 49 with fuzz 2 (offset 3 lines).
> Hunk #2 succeeded at 100 with fuzz 2 (offset 5 lines).
> Hunk #3 FAILED at 309.
> 1 out of 3 hunks FAILED -- saving rejects to file kernel/time/timekeeping.c.rej
> 
> Should I revert you previous one?

Oops, yes.
 
Thanks,

	tglx
