Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbXKBR1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbXKBR1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759005AbXKBR0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:26:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54080 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758630AbXKBR0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:26:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc1-git11: Reported regressions from 2.6.23
Date: Fri, 2 Nov 2007 18:43:25 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711021843.25543.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.23 which have been
reported since 2.6.24-rc1 was released and for which there are no fixes in the
mainline that I know of.  If any of them have been fixed already, please let me
know.

If you know of any other unresolved regressions from 2.6.23, please let me know
either and I'll add them to the list.


Subject		: On 2.6.24-rc1-gc9927c2b BUG: unable to handle kernel paging request at virtual address 3d15b925
Submitter	: Giacomo Catenazzi <cate@cateee.net>
References	: http://lkml.org/lkml/2007/10/24/487
		  http://bugzilla.kernel.org/show_bug.cgi?id=9246
Handled-By	: 
Patch		: 


Subject		: Potential regression in -git15: can't resume stopped root shell?
Submitter	: Theodore Tso <tytso@mit.edu>
References	: http://lkml.org/lkml/2007/10/20/114
		  http://bugzilla.kernel.org/show_bug.cgi?id=9247
Handled-By	: Serge Hallyn <serue@us.ibm.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13361&action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=13375&action=view


Subject		: irq 21: nobody cared 2.6.24-rc1
Submitter	: Bongani Hlope <bonganilinux@mweb.co.za>
References	: http://lkml.org/lkml/2007/10/25/90
		  http://bugzilla.kernel.org/show_bug.cgi?id=9249
Handled-By	: 
Patch		: 


Subject		: [BUG] panic after umount (biscted)
Submitter	: Sebastian Siewior <lkml@ml.breakpoint.cc>
References	: http://marc.info/?l=linux-kernel&m=119338387030335&w=2
		  http://bugzilla.kernel.org/show_bug.cgi?id=9250
Handled-By	: Jens Axboe <jens.axboe@oracle.com>
Patch		: http://marc.info/?l=linux-kernel&m=119348520210349&w=2


Subject		: 2.6.24-rc1 sysctl table check failed on PowerMac
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
References	: http://marc.info/?l=linux-kernel&m=119350802331857&w=2
		  http://bugzilla.kernel.org/show_bug.cgi?id=9251
Handled-By	: Alexey Dobriyan <adobriyan@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=119351015801660&w=2


Subject		: 2.6.24-rc1: pata_acpi fails to activate DMA for DVD-ROM on ALi M5229 secondary channel
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
References	: http://marc.info/?l=linux-kernel&m=119342005216716&w=2
		  http://bugzilla.kernel.org/show_bug.cgi?id=9252
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
Patch		: 
Note		: pata_acpi was not present in 2.6.23


Subject		: 2.6.24-rc1-gec3b67c1 broken reg. libata-sata_nv in non NCQ mode
Submitter	: Prakash Punnoor <prakash@punnoor.de>
References	: http://lkml.org/lkml/2007/10/27/34
		  http://bugzilla.kernel.org/show_bug.cgi?id=9253
Handled-By	: Jeff Garzik <jeff@garzik.org>
Patch		: 
Note		: seems closable


Subject		: 2.6.24-rc1 freezes on powerbook at first boot stage
Submitter	: Elimar Riesebieter <riesebie@lxtec.de>
References	: http://lkml.org/lkml/2007/10/24/205
		  http://bugzilla.kernel.org/show_bug.cgi?id=9254
Handled-By	: 
Patch		: 


Subject		: build #286 failed for 2.6.24-rc1-gea45d15 in linux/arch/x86/kernel/setup_32.c
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
References	: http://lkml.org/lkml/2007/10/28/110
		  http://bugzilla.kernel.org/show_bug.cgi?id=9256
Handled-By	: "H. Peter Anvin" <hpa@zytor.com>
Patch		: http://marc.info/?i=1193419828.3293.35.camel@localhost.localdomain


Subject		: 2.6.24-rc1 kills onboard r8169 (rtl8111b) NIC
Submitter	: "Sergey S. Kostyliov" <rathamahata@gmail.com>
References	: http://lkml.org/lkml/2007/10/28/144
		  http://bugzilla.kernel.org/show_bug.cgi?id=9257
Handled-By	: Francois Romieu <romieu@fr.zoreil.com>
Patch		: 


Subject		: Commit "Hibernation: Enter platform hibernation state in a consistent way)" makes my system to resume instantly from S4
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
References	: http://lkml.org/lkml/2007/10/27/66
		  http://bugzilla.kernel.org/show_bug.cgi?id=9258
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>
Patch		: 
Note		: $subject commit apparently exposes a problem that existed previously


Subject		: [SUPERH / PATA / SCSI] Unable to do start userland after kernel boot
Submitter	: Kristoffer Ericson <kristoffer.ericson@gmail.com>
References	: http://lkml.org/lkml/2007/10/25/337
		  http://bugzilla.kernel.org/show_bug.cgi?id=9279
Handled-By	: Paul Mundt <lethal@linux-sh.org>
Patch		: 


Subject		: Device mapper regression 2.6.23 vs. v2.6.23-6597-gcfa76f0
Submitter	: Thomas Meyer <thomas@m3y3r.de>
References	: http://lkml.org/lkml/2007/10/21/153
		  http://bugzilla.kernel.org/show_bug.cgi?id=9280
Handled-By	: 
Patch		: 


Subject		: leds: ledtrig-timer calls sleeping function from invalid context
Submitter	: Márton Németh <nm127@freemail.hu>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9264
Handled-By	: 
Patch		: 


Subject		: [REGRESSION] 2.6.24-rc1 fails to boot on a 486
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
References	: http://lkml.org/lkml/2007/10/28/195
		  http://bugzilla.kernel.org/show_bug.cgi?id=9281
Handled-By	: "H. Peter Anvin" <hpa@zytor.com>
		  Ingo Molnar <mingo@elte.hu>
		  Thomas Gleixner <tglx@linutronix.de>
Patch		: 


Subject		: 2.6.24-rc1: hangs when logging in to X session
Submitter	: Marcus Better <marcus@better.se>
References	: http://lkml.org/lkml/2007/10/29/168
		  http://bugzilla.kernel.org/show_bug.cgi?id=9282
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
Patch		: 


Subject		: [2.6.24-rc1][BUG] Oops on battery removal
Submitter	: Rolf Eike Beer <eike-kernel@sf-tec.de>
References	: http://lkml.org/lkml/2007/11/2/23
		  http://bugzilla.kernel.org/show_bug.cgi?id=9283
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://lkml.org/lkml/2007/11/2/71


Subject		: [2.6.24-rc1 regression] AC adapter state does not change after resume
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
References	: http://lkml.org/lkml/2007/10/30/427
		  http://bugzilla.kernel.org/show_bug.cgi?id=9284
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://lkml.org/lkml/2007/10/31/44


Subject		: oops in enqueue_entity with 2.6.24-rc1-g54866f03
Submitter	: Eric Sesterhenn <snakebyte@gmx.de>
References	: http://lkml.org/lkml/2007/11/2/58
		  http://bugzilla.kernel.org/show_bug.cgi?id=9285
Handled-By	: 
Patch		: 


Subject		: 2.6.24-rc1 eat my photo SD card :-(
Submitter	: Romano Giannetti <romanol@upcomillas.es>
References	: http://lkml.org/lkml/2007/11/1/99
		  http://bugzilla.kernel.org/show_bug.cgi?id=9286
Handled-By	: Nick Piggin <nickpiggin@yahoo.com.au>
Patch		: 


Subject		: Suspend to ram regression (2.6.24-rc1-git)
Submitter	: Jens Axboe <jens.axboe@oracle.com>
References	: http://lkml.org/lkml/2007/10/31/328
		  http://bugzilla.kernel.org/show_bug.cgi?id=9287
Handled-By	: Jens Axboe <jens.axboe@oracle.com>
		  Jeff Garzik <jeff@garzik.org>
		  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Patch		: http://lkml.org/lkml/2007/11/1/60


Subject		: 2.4.24-rc1-git: crash on shutdown/unmount?
Submitter	: Alistair John Strachan <alistair@devzero.co.uk>
References	: http://lkml.org/lkml/2007/10/31/310
		  http://bugzilla.kernel.org/show_bug.cgi?id=9288
Handled-By	: Jens Axboe <jens.axboe@oracle.com>
Patch		: http://lkml.org/lkml/2007/11/1/86


Subject		: 100% iowait on one of cpus in current -git
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
		  "Torsten Kaiser" <just.for.lkml@googlemail.com>
References	: http://lkml.org/lkml/2007/10/22/20
		  http://lkml.org/lkml/2007/10/31/212
		  http://bugzilla.kernel.org/show_bug.cgi?id=9289
Handled-By	: Fengguang Wu <wfg@mail.ustc.edu.cn>
Patch		: 


Subject		: "Fix ATAPI transfer lengths" causes CD writing regression
Submitter	: Daniel Drake <dsd@gentoo.org>
References	: http://lkml.org/lkml/2007/10/30/242
		  http://bugzilla.kernel.org/show_bug.cgi?id=9290
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
		  Jens Axboe <jens.axboe@oracle.com>
		  Jeff Garzik <jeff@garzik.org>
		  Tejun Heo <htejun@gmail.com>
Patch		: 


Subject		: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
Submitter	: Florin Iucha <florin@iucha.net>
References	: http://lkml.org/lkml/2007/10/28/65
		  http://bugzilla.kernel.org/show_bug.cgi?id=9291
Handled-By	: Trond Myklebust <trond.myklebust@fys.uio.no>
		  Fengguang Wu <wfg@mail.ustc.edu.cn>
Patch		: 


Subject		: 2.6.24-rc1-82798a1 compile failure (x86_64)
Submitter	: Thomas Bächler <thomas@archlinux.org>
References	: http://lkml.org/lkml/2007/10/29/421
		  http://bugzilla.kernel.org/show_bug.cgi?id=9292
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
Patch		:


Subject		: aim7 -30% regression in 2.6.24-rc1
Submitter	: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References	: http://lkml.org/lkml/2007/10/26/128
		  http://bugzilla.kernel.org/show_bug.cgi?id=9293
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
Patch		: http://lkml.org/lkml/2007/10/31/131


For details, please follow the links given in references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.23,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9243

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Greetings,
Rafael
