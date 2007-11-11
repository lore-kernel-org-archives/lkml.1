Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbXKKTld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbXKKTld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 14:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbXKKTlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 14:41:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35029 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361AbXKKTlW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 14:41:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc2: Reported regressions from 2.6.23 (updated)
Date: Sun, 11 Nov 2007 20:58:27 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711112058.28043.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Note: Due to git.kernel.org not responding I'm unable to check which fixes
have already been merged since the last report.]

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
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13441&action=view


Subject		: Commit "Hibernation: Enter platform hibernation state in a consistent way)" makes my system to resume instantly from S4
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
References	: http://lkml.org/lkml/2007/10/27/66
		  http://bugzilla.kernel.org/show_bug.cgi?id=9258
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>
Patch		: 
Note		: $subject commit apparently exposes a problem that existed previously


Subject		: leds: ledtrig-timer calls sleeping function from invalid context
Submitter	: Márton Németh <nm127@freemail.hu>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9264
Handled-By	: 
Patch		: 


Subject		: Device mapper regression 2.6.23 vs. v2.6.23-6597-gcfa76f0
Submitter	: Thomas Meyer <thomas@m3y3r.de>
References	: http://lkml.org/lkml/2007/10/21/153
		  http://bugzilla.kernel.org/show_bug.cgi?id=9280
Handled-By	: 
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


Subject		: 2.6.24-rc1 eat my photo SD card :-(
Submitter	: Romano Giannetti <romanol@upcomillas.es>
References	: http://lkml.org/lkml/2007/11/1/99
		  http://bugzilla.kernel.org/show_bug.cgi?id=9286
Handled-By	: Nick Piggin <nickpiggin@yahoo.com.au>
		  Pierre Ossman <drzeus-mmc@drzeus.cx>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13450&action=view


Subject		: 100% iowait on one of cpus in current -git
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
		  Thomas Schwarzgruber <possebaer@gmx.at>
References	: http://lkml.org/lkml/2007/10/22/20
		  http://lkml.org/lkml/2007/10/31/212
		  http://bugzilla.kernel.org/show_bug.cgi?id=9289
Handled-By	: Fengguang Wu <wfg@mail.ustc.edu.cn>
Patch		: 


Subject		: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
Submitter	: Florin Iucha <florin@iucha.net>
References	: http://lkml.org/lkml/2007/10/28/65
		  http://bugzilla.kernel.org/show_bug.cgi?id=9291
Handled-By	: Trond Myklebust <trond.myklebust@fys.uio.no>
		  Fengguang Wu <wfg@mail.ustc.edu.cn>
Patch		: 


Subject		: [regression] v2.6.24-rc1-497-gb1d08ac: kde battery icon gone
Submitter	: Thomas Meyer <thomas@m3y3r.de>
References	: http://lkml.org/lkml/2007/11/2/165
		  http://bugzilla.kernel.org/show_bug.cgi?id=9297
Handled-By	: Andrey Borzenkov <arvidjaar@mail.ru>
		  Ingo Molnar <mingo@elte.hu>
Patch		: 
Note		: goes away if ACPI_PROCFS is set


Subject		: Regression: libata: implement ata_wait_after_reset()
Submitter	: Luca Tettamanti <kronos.it@gmail.com>
References	: http://lkml.org/lkml/2007/11/3/66
		  http://bugzilla.kernel.org/show_bug.cgi?id=9298
Handled-By	: Tejun Heo <htejun@gmail.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13429&action=view


Subject		: 2.6.24-rc1-g74521c28: oops during boot [<ffffffff881c03e4>] :power_supply:power_supply_show_property+0x94/0x150
Submitter	: Thomas Bächler <thomas@archlinux.org>
References	: http://lkml.org/lkml/2007/11/3/35
		  http://bugzilla.kernel.org/show_bug.cgi?id=9299
Handled-By	:
Patch		: 


Subject		: Audigy 2 ZS Notebook prevents snd_emu10k1 module from loading/working
Submitter	: unggnu@googlemail.com
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9304
Handled-By	: Takashi Iwai <tiwai@suse.de>
Patch		: 


Subject		: National characters are not displayed under console.
Submitter	: Konrad Rzepecki <hannibal@astral.lodz.pl>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9319
Handled-By	: 
Patch		: 


Subject		: PATA scan: ACPI Exception AE_AML_PACKAGE_LIMIT... is beyond end of object
Submitter	: Hans de Bruin <bruinjm@xs4all.nl>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9320
Handled-By	: Robert Moore <Robert.Moore@intel.com>
Patch		: 


Subject		: net: skge breakage on 2.6.24-rc1
Submitter	: Heikki Orsila <shdl@zakalwe.fi>
References	: http://lkml.org/lkml/2007/11/7/281
		  http://bugzilla.kernel.org/show_bug.cgi?id=9321
Handled-By	: 
Patch		: 


Subject		: 2.6.24-rc1: pata_amd fails to detect 80-pin wire
Submitter	: "Thomas Lindroth" <thomas.lindroth@gmail.com>
References	: http://lkml.org/lkml/2007/11/7/152
		  http://bugzilla.kernel.org/show_bug.cgi?id=9322
Handled-By	: 
Patch		: 


Subject		: 2.6.24-rc1 - Regularly getting processes stuck in D state on startup
Submitter	: David <david@unsolicited.net>
Confirmed-by	: Stephen Rothwell <sfr@canb.auug.org.au>
References	: http://lkml.org/lkml/2007/11/5/229
		  http://bugzilla.kernel.org/show_bug.cgi?id=9323
Handled-By	: Peter Zijlstra <peterz@infradead.org>
		  Fengguang Wu <wfg@mail.ustc.edu.cn>
Patch		: http://lkml.org/lkml/2007/11/6/33


Subject		: 2.6.24-rc2 breaks nVidia MCP51 High Definition Audio
Submitter	: Gerhard Mack <gmack@innerfire.net>
References	: http://lkml.org/lkml/2007/11/7/318
		  http://bugzilla.kernel.org/show_bug.cgi?id=9324
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
Patch		: 


Subject		: 2.6.24-rc2 (esthetic?) regression: auto select interrupt bouncing
Submitter	: Romano Giannetti <romanol@upcomillas.es>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9327
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: 


Subject		: libata: cdrw/dvdrom disabed after s2ram (2.6.24-rc2)
Submitter	: Roberto Oppedisano <roppedisano@infracomspa.it>
References	: http://lkml.org/lkml/2007/11/8/124
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Jeff Garzik <jeff@garzik.org>
		  Matthew Garrett <mjg59@srcf.ucam.org>
Patch		: http://lkml.org/lkml/2007/11/8/167


Subject		: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
Submitter	: Roland Dreier <rdreier@cisco.com>
References	: http://lkml.org/lkml/2007/11/8/255
		  http://bugzilla.kernel.org/show_bug.cgi?id=9332
Handled-By	: 
Patch		: 


Subject		: system hangs with blank screen after some time
Submitter	: Marcus Better <marcus@better.se>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9335
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
Patch		: 


Subject		: iozone write 50% regression in kernel 2.6.24-rc1
Submitter	: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References	: http://lkml.org/lkml/2007/11/9/28
		  http://bugzilla.kernel.org/show_bug.cgi?id=9340
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Martin Knoblauch <knobi@knobisoft.de>
Patch		: 


Subject		: 2.6.24 regression:  hibernation hangs on "Suspending console" in low-battery condition
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
References	: http://lkml.org/lkml/2007/11/11/28
		  http://bugzilla.kernel.org/show_bug.cgi?id=9344
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>
Patch		: 


Subject		: 2.6.24-rc2 STD with s2disk fails to activate suspended system after loading
Submitter	: Chris Friedhoff <chris@friedhoff.org>
References	: http://lkml.org/lkml/2007/11/10/114
		  http://bugzilla.kernel.org/show_bug.cgi?id=9345
Handled-By	: 
Patch		: 


Subject		: cd/dvd inaccessible in 2.6.24-rc2
Submitter	: Will Trives <will@trivescon.com.au>
References	: http://lkml.org/lkml/2007/11/9/290
		  http://bugzilla.kernel.org/show_bug.cgi?id=9346
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
		  Jeff Garzik <jeff@garzik.org>
Patch		: 


Subject		: [PATCH] x86: show cpuinfo only for online CPUs
Submitter	: "Andreas Herrmann" <andreas.herrmann3@amd.com>
References	: http://lkml.org/lkml/2007/11/1/207
		  http://bugzilla.kernel.org/show_bug.cgi?id=9348
Handled-By	: Glauber de Oliveira Costa <gcosta@redhat.com>
		  "H. Peter Anvin" <hpa@zytor.com>
Patch		: http://lkml.org/lkml/2007/11/1/246


Subject		: 2.6.24-rc2: Network commit causes SLUB performance regression with tbench
Submitter	: Christoph Lameter <clameter@sgi.com>
References	: http://lkml.org/lkml/2007/11/9/246
		  http://bugzilla.kernel.org/show_bug.cgi?id=9350
Handled-By	: Nick Piggin <nickpiggin@yahoo.com.au>
Patch		: 


Subject		: 2.6.24-rc1 on PPC64: machine check exception
Submitter	: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
References	: http://lkml.org/lkml/2007/11/5/92
Handled-By	: Anton Blanchard <anton@samba.org>
		  http://bugzilla.kernel.org/show_bug.cgi?id=9351
Patch		: http://patchwork.ozlabs.org/linuxppc/patch?id=14475


Subject		: 2.6.24-rc1-gb4f5550 oops
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
References	: http://lkml.org/lkml/2007/11/5/6
		  http://bugzilla.kernel.org/show_bug.cgi?id=9352
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>
Patch		: 


For details, please follow the links given in references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.23,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9243

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Greetings,
Rafael
