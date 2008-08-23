Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYHWTiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYHWTiw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYHWTij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:38:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50038 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbYHWTih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:38:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.27-rc4-git1: Reported regressions from 2.6.26
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
Date: Sat, 23 Aug 2008 20:07:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.26, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.26, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-08-23      122       48          40
  2008-08-16      103       47          37
  2008-08-10       80       52          31
  2008-08-02       47       31          20


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11414
Subject		: Random crashes with 2.6.27-rc3 on PPC
Submitter	: Michael Buesch <mb@bu3sch.de>
Date		: 2008-08-23 14:10 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121950076812616&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11410
Subject		: SLUB list_lock vs obj_hash.lock...
Submitter	: Daniel J Blueman <daniel.blueman@gmail.com>
Date		: 2008-08-22 21:48 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121944176609042&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11407
Subject		: suspend: unable to handle kernel paging request
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-08-21 17:28 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121933974928881&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
		  Pekka Enberg <penberg@cs.helsinki.fi>
		  Pavel Machek <pavel@suse.cz>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11406
Subject		: patch "x86: MOVE PCI IO ECS code to x86/pci" breaks CPU hotplug
Submitter	: Jan Beulich <jbeulich@novell.com>
Date		: 2008-08-21 12:59 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121932366326572&w=4
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  Robert Richter <robert.richter@amd.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11405
Subject		: 2.6.27-rc3 segfault on cold boot; not on warm boot.
Submitter	: David Greaves <david@dgreaves.com>
Date		: 2008-08-21 9:45 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121931198904777&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11404
Subject		: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
Submitter	: rdunlap <randy.dunlap@oracle.com>
Date		: 2008-08-21 5:52 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121929819616273&w=4
		  http://marc.info/?l=linux-kernel&m=121932889105368&w=4
Handled-By	: Miller, Mike (OS Dev) <Mike.Miller@hp.com>
		  James Bottomley <James.Bottomley@hansenpartnership.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11403
Subject		: 2.6.27-rc2 USB suspend regression
Submitter	: Jeremy Fitzhardinge <jeremy@goop.org>
Date		: 2008-08-20 20:48 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121926536103630&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11402
Subject		: skbuff bug?
Submitter	: Yinghai Lu <yhlu.kernel@gmail.com>
Date		: 2008-08-21 3:56 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121929102707658&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11401
Subject		: pktcdvd: BUG, NULL pointer dereference in pkt_ioctl, bisected
Submitter	: Laurent Riffard <laurent.riffard@free.fr>
Date		: 2008-08-22 08:16 (2 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11398
Subject		: hda_intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-08-21 17:17 (3 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11388
Subject		: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Submitter	: Joshua Hoblitt <j_kernel@hoblitt.com>
Date		: 2008-08-20 17:38 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11382
Subject		: e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Submitter	: David Vrabel <david.vrabel@csr.com>
Date		: 2008-08-08 10:47 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=121819267211679&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11380
Subject		: lockdep warning: cpu_add_remove_lock at:cpu_maps_update_begin+0x14/0x16
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-08-20 6:44 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121921480931970&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11379
Subject		: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-08-18 13:40 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=121906698213329&w=4
Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11357
Subject		: Can not boot up with zd1211rw USB-Wlan Stick
Submitter	: uwe <kender@freenet.de>
Date		: 2008-08-16 14:17 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11356
Subject		: Linux 2.6.27-rc3 - build failure: undefined reference to `.lockdep_count_forward_deps'
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-08-16 19:11 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=121891396320127&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11355
Subject		: Regression in 2.6.27-rc2 when cross-building the kernel
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2008-08-16 2:38 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=121885432118368&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11354
Subject		: AMD Elan regression with 2.6.27-rc3
Submitter	: Sean Young <sean@mess.org>
Date		: 2008-08-15 18:37 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=121882578430056&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11343
Subject		: SATA Cold Boot Problems with 2.6.27-rc[23] on nVidia 680i
Submitter	: Manny Maxwell <mannymax@mannymax.net>
Date		: 2008-08-14 4:16 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121868782917600&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11342
Subject		: Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Submitter	: Alan D. Brunelle <Alan.Brunelle@hp.com>
Date		: 2008-08-13 23:03 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=121866876027629&w=4
Handled-By	: Andrew Morton <akpm@linux-foundation.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11340
Subject		: LTP overnight run resulted in unusable box
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-08-13 9:24 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=121861951902949&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11336
Subject		: 2.6.27-rc2:stall while mounting root fs
Submitter	: Torsten Kaiser <just.for.lkml@googlemail.com>
Date		: 2008-08-12 12:37 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=121854484015909&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11335
Subject		: 2.6.27-rc2-git5 BUG: unable to handle kernel paging request
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-08-12 4:18 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=121851477201960&w=4
		  http://lkml.org/lkml/2008/8/16/274
Handled-By	: Hugh Dickins <hugh@veritas.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11334
Subject		: myri10ge: use ioremap_wc: compilation failure on ARM
Submitter	: Martin Michlmayr <tbm@cyrius.com>
Date		: 2008-08-10 11:25 (14 days old)
References	: http://marc.info/?l=linux-netdev&m=121836771727632&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11308
Subject		: tbench regression on each kernel release from 2.6.22 -&gt; 2.6.28
Submitter	: Christoph Lameter <cl@linux-foundation.org>
Date		: 2008-08-11 18:36 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=121847986119495&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11282
Subject		: Please fix x86 defconfig regression
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2008-08-07 20:46 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=121814188805666&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11279
Subject		: 2.6.27-rc0 Power Bugs with HP/Compaq Laptops
Submitter	: Matt Parnell <mparnell@gmail.com>
Date		: 2008-08-07 14:57 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=121812108031685&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11272
Subject		: BUG: parport_serial in 2.6.27-rc1 for NetMos Technology PCI 9835
Submitter	: Jaswinder Singh <jaswinderlinux@gmail.com>
Date		: 2008-08-05 15:12 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=121794900319776&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11271
Subject		: BUG: fealnx in 2.6.27-rc1
Submitter	: Jaswinder Singh <jaswinderlinux@gmail.com>
Date		: 2008-08-05 14:58 (19 days old)
References	: http://marc.info/?l=linux-netdev&m=121794762016830&w=4
		  http://lkml.org/lkml/2008/8/10/98
Handled-By	: Francois Romieu <romieu@fr.zoreil.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11264
Subject		: Invalid op opcode in kernel/workqueue
Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Date		: 2008-08-07 04:18 (17 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
Subject		: corrupt PMD after resume
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-08-02 9:51 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=121767073424952&w=4
Handled-By	: Hugh Dickins <hugh@veritas.com>
		  Jeremy Fitzhardinge <jeremy@goop.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11230
Subject		: Kconfig no longer outputs a .config with freshly updated defconfigs
Submitter	: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date		: 2008-08-02 16:03 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=121769306319391&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11224
Subject		: Only three cores found on quad-core machine.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-08-01 18:15 (23 days old)
References	: http://marc.info/?l=linux-kernel&m=121761475224719&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11220
Subject		: Screen stays black after resume
Submitter	: Nico Schottelius <nico@schottelius.org>
Date		: 2008-07-31 21:05 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=121753882422899&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11219
Subject		: KVM modules break emergency reboot
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-08-01 20:25 (23 days old)
References	: http://marc.info/?l=linux-kernel&m=121762241105336&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11215
Subject		: INFO: possible recursive locking detected ps2_command
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-07-31 9:41 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=121749737011637&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11210
Subject		: libata badness
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2008-07-31 18:53 (24 days old)
References	: http://marc.info/?l=linux-ide&m=121753059307310&w=4
Handled-By	: Ben Dooks <ben-linux@fluff.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11209
Subject		: 2.6.27-rc1 process time accounting
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-07-31 10:43 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=121750102917490&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11191
Subject		: 2.6.26-git8: spinlock lockup in c1e_idle()
Submitter	: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Date		: 2008-07-24 03:22 (31 days old)
References	: http://lkml.org/lkml/2008/7/23/317
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11141
Subject		: no battery or DC status - Dell i1501
Submitter	: Gu Rui <chaos.proton@gmail.com>
Date		: 2008-07-21 19:43 (34 days old)
Handled-By	: Zhao Yakui <yakui.zhao@intel.com>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11413
Subject		: get_rtc_time() triggers NMI watchdog in hpet_rtc_interrupt()
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-08-23 9:48 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121948503224161&w=4
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://marc.info/?l=linux-kernel&m=121950734922457&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11409
Subject		: build issue #564 for v2.6.27-rc4 : undefined reference to `NS8390p_init'
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-08-22 8:33 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121939410214677&w=4
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
Patch		: http://marc.info/?l=linux-kernel&m=121943097320451&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11361
Subject		: my servers with nvidia mcp55 nic don't work with msi in second kernel by kexec
Submitter	: Yinghai Lu <yhlu.kernel@gmail.com>
Date		: 2008-08-17 6:25 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=121895439927053&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://marc.info/?l=linux-kernel&m=121917167232014&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11360
Subject		: mpc8xxx_wdt.c doesn't build modular
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-08-17 08:07 (7 days old)
References	: http://lkml.org/lkml/2008/8/12/465
Handled-By	: Anton Vorontsov <avorontsov@ru.mvista.com>
Patch		: http://lkml.org/lkml/2008/8/13/344


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11358
Subject		: net: forcedeth call restore mac addr in nv_shutdown path
Submitter	: Yinghai Lu <yhlu.kernel@gmail.com>
Date		: 2008-08-17 3:30 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=121894389018584&w=4
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=121894389018584&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11276
Subject		: build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-08-06 17:18 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=121804329014332&w=4
		  http://lkml.org/lkml/2008/7/22/353
Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch		: http://lkml.org/lkml/2008/7/22/364


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11254
Subject		: KVM: fix userspace ABI breakage
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 21 Jul 2008 17:58:26 (0 days old)
References	: http://lkml.org/lkml/2008/7/21/197
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/7/21/197


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11207
Subject		: VolanoMark regression with 2.6.27-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-07-31 3:20 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=121747464114335&w=4
Handled-By	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Dhaval Giani <dhaval@linux.vnet.ibm.com>
		  Miao Xie <miaox@cn.fujitsu.com>
Patch		: http://marc.info/?l=linux-kernel&m=121922991027344&w=4


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.26,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=11167

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

