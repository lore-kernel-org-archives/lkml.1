Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbYCJAeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbYCJAeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 20:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYCJAeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 20:34:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52325 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbYCJAeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 20:34:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.25-rc4-git3: Reported regressions from 2.6.24
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 10 Mar 2008 01:32:56 +0100
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <200803100132.57160.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Due to the lack of time for reviewing all of the email threads related to the
regressions marked as "unresolved" below, I might have missed some patches
fixing them.  If you are involved in debugging/fixing any of them, please let
me know if I should update the list.  Thanks!]

This message contains a list of some regressions from 2.6.24 reported since
2.6.25-rc1 was released, for which there are no fixes in the mainline I know
of.  If any of them have been fixed already, please let me know.

If you know of any other unresolved regressions from 2.6.24, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-03-10      138       66          47
  2008-03-03      115       65          49
  2008-02-25       90       51          39
  2008-02-17       61       45          37


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9954
Subject		: iwl3945: not only it periodically dies, it also BUG()s
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2008-02-05 22:44
References	: http://lkml.org/lkml/2008/2/5/453
Handled-By	: Chatre, Reinette <reinette.chatre@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9958
Subject		: parisc compile error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-02-08 01:12
References	: http://lkml.org/lkml/2008/2/7/572
Handled-By	: Kyle McMartin <kyle@mcmartin.ca>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9962
Subject		: mount: could not find filesystem
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-02-12 14:34
References	: http://lkml.org/lkml/2008/2/12/91
Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
		  Yinghai Lu <yhlu.kernel@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
Subject		: 2.6.25-rc1: volanoMark 45% regression
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-02-13 10:30
References	: http://lkml.org/lkml/2008/2/13/128
Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
		  Balbir Singh <balbir@linux.vnet.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9980
Subject		: 2.6.25-rc1 on Sun Ultra 40
Submitter	: Jasper Bryant-Greene <jasper@unix.geek.nz>
Date		: 2008-02-13 12:25
References	: http://lkml.org/lkml/2008/2/13/181
Handled-By	: Yinghai Lu <Yinghai.Lu@sun.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9983
Subject		: PROBLEM: 2.6.25-rc1-git2 freezes when accessing external USB hard disk (ehci-hcd)
Submitter	: Linas ®virblis <0x0007@gmail.com>
Date		: 2008-02-13 22:38
References	: http://lkml.org/lkml/2008/2/13/566


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9984
Subject		: problem with starting 2.6.25-rc1 and latest git
Submitter	: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date		: 2008-02-13 23:16
References	: http://lkml.org/lkml/2008/2/13/587


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9992
Subject		: 2.6.24-git: kmap_atomic() WARN_ON()
Submitter	: Thomas Gleixner <tglx@linutronix.de>
Date		: 2008-02-07 00:58
References	: http://lkml.org/lkml/2008/2/6/451
		  http://lkml.org/lkml/2007/1/14/38


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9995
Subject		: 2.6.25-rc1 regression - backlight controlls do not work - ThinkPad T61
Submitter	: Lukas Hejtmanek <xhejtman@fi.muni.cz>
Date		: 2008-02-15 04:51
Handled-By	: Zhang Rui <rui.zhang@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10011
Subject		: The computer is blocked when X is started
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2008-02-17 06:28
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10016
Subject		: cobalt_btns.c &lt;-&gt; struct platform_device compile error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-02-17 12:12
References	: http://lkml.org/lkml/2008/2/17/293


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10017
Subject		: cdev removal broke cobalt_btns.c compilation
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-02-17 12:14
References	: http://lkml.org/lkml/2008/2/17/295


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10025
Subject		: Current git very broken on the Dreamcast
Submitter	: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Date		: 2008-02-16 19:38
References	: http://lkml.org/lkml/2008/2/16/196
Handled-By	: Kristoffer Ericson <kristoffer.ericson@gmail.com>
		  Magnus Damm <magnus.damm@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10027
Subject		: 2.6.25-rc[12] Video4Linux Bttv Regression
Submitter	: Bongani Hlope <bonganilinux@mweb.co.za>
Date		: 2008-02-17 09:36
References	: http://lkml.org/lkml/2008/2/17/55
Handled-By	: Mauro Carvalho Chehab <mchehab@infradead.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10033
Subject		: mips yosemite_defconfig compile error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-02-17 16:45
References	: http://lkml.org/lkml/2008/2/17/383


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10041
Subject		: 2.6.25-rc1/2 regression: first-time login into gnome fails
Submitter	: Romano Giannetti <romanol@upcomillas.es>
Date		: 2008-02-18 11:56
References	: http://lkml.org/lkml/2008/2/18/145
Handled-By	: Ray Lee <ray-lk@madrabbit.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10051
Subject		: Spurious messages at boot, eventually hangs the usb subsustem
Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Date		: 2008-02-20 09:10


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10061
Subject		: Hang in md5_resync
Submitter	: Steinar H. Gunderson <sgunderson@bigfoot.com>
Date		: 2008-02-21 13:13


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10065
Subject		: 2.6.25-rc2 regression - hang on suspend
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-02-19 12:59
References	: http://lkml.org/lkml/2008/2/19/165
		  http://lkml.org/lkml/2008/2/17/381
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10067
Subject		: TUNER_TDA8290=y, VIDEO_DEV=n build error
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-02-22 10:36
References	: http://lkml.org/lkml/2008/2/19/262


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10078
Subject		: USB OOPS 2.6.25-rc2-git1
Submitter	: Andre Tomt <andre@tomt.net>
Date		: 2008-02-19 16:19
References	: http://lkml.org/lkml/2008/2/19/253
Handled-By	: David Brownell <david-b@pacbell.net>
		  Alan Stern <stern@rowland.harvard.edu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10080
Subject		: 2.6.25-rc2: ohci1394 problem
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2008-02-20 08:47
References	: http://lkml.org/lkml/2008/2/20/58
Handled-By	: Stefan Richter <stefanr@s5r6.in-berlin.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10082
Subject		: [BUG] 2.6.25-rc2-git4 - Regression Kernel oops while running kernbench and tbench on powerpc
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-02-20 16:01
References	: http://lkml.org/lkml/2008/2/20/218
		  http://lkml.org/lkml/2008/1/18/71


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10084
Subject		: 2.6.25-rc2-git4 BUG: sysfs_readdir
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-02-21 17:25
References	: http://lkml.org/lkml/2008/2/21/212
Handled-By	: Greg KH <greg@kroah.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10086
Subject		: 2.6.25-rc2 + smartd = hang
Submitter	: Anders Eriksson <aeriksson@fastmail.fm>
Date		: 2008-02-22 17:51
References	: http://lkml.org/lkml/2008/2/22/239
Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10093
Subject		: 2.6.25-current-git hangs on boot
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-02-23 18:55
References	: http://lkml.org/lkml/2008/2/23/263
		  http://marc.info/?l=linux-acpi&amp;m=120387537018467&amp;w=4
Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10097
Subject		: SMP BUG in __nf_conntrack_find
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-02-25 10:44


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10100
Subject		: 208c70a45624400fafd7511b96bc426bf01f8f5e breaks EC init
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2008-02-25 20:19
References	: http://lkml.org/lkml/2008/2/25/282
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10102
Subject		: 2.6.25-rc2 Regression Thinkpad acpi
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-02-25 12:47
References	: http://lkml.org/lkml/2008/2/25/73
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10104
Subject		: 2.6.25-rc3: WARNING: at arch/x86/mm/ioremap.c:137
Submitter	: Phil Oester <kernel@linuxace.com>
Date		: 2008-02-25 03:09
References	: http://lkml.org/lkml/2008/2/24/265


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10117
Subject		: 2.6.25-current-git hangs on boot (pci=nommconf helps)
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-02-23 18:55
References	: http://lkml.org/lkml/2008/2/23/263


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10123
Subject		: No power-off / reboot with 2.6.25-rcX (up to -rc3) kernels
Submitter	: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date		: 2008-02-27 08:15


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10133
Subject		: INFO: possible circular locking in the resume
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-02-27
References	: http://lkml.org/lkml/2008/2/26/479
Handled-By	: Gautham R Shenoy <ego@in.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10146
Subject		: 2.6.25-rc: complete lockup on boot/start of X (bisected)
Submitter	: Marcin Slusarz <marcin.slusarz@gmail.com>
Date		: 2008-03-02 20:00
References	: http://lkml.org/lkml/2008/3/2/91
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10147
Subject		: sh r7780mp_defconfig compile error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-03-02 13:42
References	: http://lkml.org/lkml/2008/3/2/141


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10152
Subject		: Clocksource tsc is always unstable with 2.6.25-* kernels and CONFIG_NO_HZ=y on my box
Submitter	: Gabriel C <nix.or.die@googlemail.com>
Date		: 2008-02-24 01:31
References	: http://lkml.org/lkml/2008/2/23/380
		  http://lkml.org/lkml/2008/2/24/281
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10156
Subject		: KVM &amp; Qemu crashed with infinite recursive kernel loop in the guest
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-02-28 11:25
References	: http://lkml.org/lkml/2008/2/28/106


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10164
Subject		: ntfs build failure on no-mmu
Submitter	: Mike Frysinger <vapier.adi@gmail.com>
Date		: 2008-03-03 11:05
References	: http://lkml.org/lkml/2008/3/1/179


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10172
Subject		: INFO: inconsistent lock state
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-03-05 03:26


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10188
Subject		: 2.6.25-rc4: crash on boot when SMP enabled
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2008-03-06 10:29
References	: http://marc.info/?l=linux-kernel&amp;m=120480512530063&amp;w=2
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10190
Subject		: [BUG] Linux-2.6.25-rc4 (and also in rc3) Compile Error
Submitter	: Tarkan Erimer <tarkan@netone.net.tr>
Date		: 2008-03-05 05:01
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0803.0/1867.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10191
Subject		: Treason uncloaked spams syslog with latest git
Submitter	: Thomas Gleixner <tglx@linutronix.de>
Date		: 2008-03-06 05:47
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0803.0/2444.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10203
Subject		: Unable to ifconfig up b43 wireless interface
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-03-09 00:55
Handled-By	: Michael Buesch <mb@bu3sch.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10207
Subject		: INFO: task mount:11202 blocked for more than 120 seconds
Submitter	: Christian Kujau <lists@nerdbynature.de>
Date		: 2008-03-07 21:32
References	: http://lkml.org/lkml/2008/3/7/308
		  http://lkml.org/lkml/2008/3/9/186
Handled-By	: David Chinner <dgc@sgi.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10209
Subject		: 2.6.25 sysdev API problem
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-03-08 16:56
References	: http://lkml.org/lkml/2008/3/8/59
Handled-By	: Greg KH <gregkh@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10210
Subject		: [Regression] 2.6.25-rc4-git3: Handling of audio CDs broken on pata_ali
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-03-08 22:46
References	: http://lkml.org/lkml/2008/3/8/123


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10211
Subject		: build #408 issue for v2.6.25-rc4-56-gd7fe321 in cx2341x_ctrl_get_menu
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-03-07 13:48
References	: http://lkml.org/lkml/2008/3/7/168


Regressionn with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9969
Subject		: 2.6.24-git15 Keyboard Issue?
Submitter	: Chris Holvenstot <cholvenstot@comcast.net>
Date		: 2008-02-06 14:02
References	: http://lkml.org/lkml/2008/2/6/100
		  http://lkml.org/lkml/2008/2/13/82
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
Patch		: http://lkml.org/lkml/2008/2/15/343


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9976
Subject		: BUG: 2.6.25-rc1: iptables postrouting setup causes oops
Submitter	: Ben Nizette <bn@niasdigital.com>
Date		: 2008-02-12 12:46
References	: http://lkml.org/lkml/2008/2/12/148
Handled-By	: Haavard Skinnemoen <hskinnemoen@atmel.com>
Patch		: http://lkml.org/lkml/2008/2/13/177


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10013
Subject		: tbench regression in 2.6.25-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-02-15 02:52
References	: http://lkml.org/lkml/2008/2/14/546
Handled-By	: Eric Dumazet <dada1@cosmosbay.com>
		  David Miller <davem@davemloft.net>
Patch		: http://lkml.org/lkml/2008/2/18/66
		  http://lkml.org/lkml/2008/2/18/117


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10024
Subject		: 2.6.25-rc2 regression in rt61pci wireless driver
Submitter	: Chris Clayton <chris2553@googlemail.com>
Date		: 2008-02-16 13:06
References	: http://lkml.org/lkml/2008/2/16/82
Handled-By	: Ivo van Doorn <ivdoorn@gmail.com>
		  Stefano Brivio <stefano.brivio@polimi.it>
Patch		: http://lkml.org/lkml/2008/3/2/26


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10031
Subject		: [2.6.25-rc2] e100: Trying to free already-free IRQ 11 during suspend ...
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-02-16 13:36
References	: http://lkml.org/lkml/2008/2/17/125
Handled-By	: Kok, Auke <auke-jan.h.kok@intel.com>
Patch		: http://lkml.org/lkml/2008/2/21/259


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10071
Subject		: kernel hang in inet_init
Submitter	: Yannick Dirou <yannick.dirou@axetic.com>
Date		: 2008-02-23 00:34
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Patch		: http://lkml.org/lkml/2008/2/2/11


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10079
Subject		: 2.6.25-rc[1,2]: failed to setup dm-crypt key mapping
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2008-02-20 08:43
References	: http://lkml.org/lkml/2008/2/20/131
Handled-By	: Herbert Xu <herbert@gondor.apana.org.au>
Patch		: http://lkml.org/lkml/2008/2/22/127


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10081
Subject		: build #365 issue for v2.6.25-rc2-342-g5d9c4a7 in ./arch/x86/kvm/kvm.ko
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-02-20 14:11
References	: http://lkml.org/lkml/2008/2/20/167
Handled-By	: Avi Kivity <avi@qumranet.com>
		  Randy Dunlap <randy.dunlap@oracle.com>
Patch		: http://lkml.org/lkml/2008/2/20/195
		  http://lkml.org/lkml/2008/2/20/379


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10122
Subject		: FIXED_PHY must depend on PHYLIB=y
Submitter	: Olaf Hering <olaf@aepfle.de>
Date		: 2008-02-27 07:14
References	: http://lkml.org/lkml/2008/2/27/90
Handled-By	: Adrian Bunk <adrian.bunk@movial.fi>
Patch		: http://lkml.org/lkml/2008/2/27/157


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10132
Subject		: 2.6.25 git regression, oops on boot
Submitter	: Jonathan McDowell <noodles@earth.li>
Date		: 2008-02-29 11:09
References	: http://marc.info/?l=linux-kernel&amp;m=120423268404812&amp;w=2
		  http://lkml.org/lkml/2008/2/28/369
Handled-By	: Zhang Rui <rui.zhang@intel.com>
		  Lin Ming <ming.m.lin@intel.com>
Patch		: http://lkml.org/lkml/2008/2/29/49


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10145
Subject		: apanel: fix kconfig dependencies
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-02-06 16:27
References	: http://lkml.org/lkml/2008/2/6/492
Handled-By	: Randy Dunlap <randy.dunlap@oracle.com>
Patch		: http://lkml.org/lkml/2008/2/7/333


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10153
Subject		: (regression) kernel/timeconst.h bugs with HZ=128
Submitter	: David Brownell <david-b@pacbell.net>
Date		: 2008-02-26 19:32
References	: http://lkml.org/lkml/2008/2/26/294
Handled-By	: H. Peter Anvin <hpa@zytor.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15114&amp;action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=15115&amp;action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10157
Subject		: Some processes are dealocked when one cpu is set to offline
Submitter	: Yi Yang <yi.y.yang@intel.com>
Date		: 2008-03-02 22:31
References	: http://lkml.org/lkml/2008/3/3/11
Handled-By	: Gautham R Shenoy <ego@in.ibm.com>
		  Gregory Haskins <ghaskins@novell.com>
Patch		: http://lkml.org/lkml/2008/3/8/4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10168
Subject		: WARNING: at drivers/usb/host/ehci-hcd.c:287
Submitter	: Christian Kujau <lists@nerdbynature.de>
Date		: 2008-03-03 01:05
References	: http://lkml.org/lkml/2008/3/2/171
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
		  David Brownell <david-b@pacbell.net>
Patch		: http://lkml.org/lkml/2008/3/4/420


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10176
Subject		: 2.6.25-rc4 rcupreempt.h WARNINGs while suspend/resume
Submitter	: Dave Young <hidave.darkstar@gmail.com>
Date		: 2008-03-05
References	: http://lkml.org/lkml/2008/3/5/49
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Patch		: http://lkml.org/lkml/2008/2/26/386


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10186
Subject		: SCSI_AIC94XX must depend on SCSI
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-03-06 19:09
References	: http://marc.info/?l=linux-kernel&amp;m=120483073617232&amp;w=2
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://marc.info/?l=linux-kernel&amp;m=120483499725928&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10187
Subject		: 2.6.25-rc4 OOMs itself dead on bootup
Submitter	: Frank Sorenson <frank@tuxrocks.com>
Date		: 2008-03-06 17:26
References	: http://marc.info/?l=linux-kernel&amp;m=120482709209046&amp;w=2
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://lkml.org/lkml/2008/3/8/15


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10189
Subject		: libata: allow LLDs w/o any reset method
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-03-06 10:25
References	: http://marc.info/?l=linux-kernel&amp;m=120479928020617&amp;w=2
Handled-By	: Tejun Heo <htejun@gmail.com>
Patch		: http://marc.info/?l=linux-ide&amp;m=120477660124629&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10200
Subject		: crypto/ section fixes
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-03-08 14:00
References	: http://lkml.org/lkml/2008/3/8/125
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/3/8/125


For details, please follow the links given in references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.24,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9832

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael
