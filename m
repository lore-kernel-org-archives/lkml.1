Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbYBYBnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbYBYBnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 20:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYBYBnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 20:43:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55426 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbYBYBnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 20:43:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.25-rc3: Reported regressions from 2.6.24
Date: Mon, 25 Feb 2008 02:41:40 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802250241.40832.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.24 reported since
2.6.25-rc1 was released, for which there are no fixes in the mainline I know
of.  If any of them have been fixed already, please let me know.

If you know of any other unresolved regressions from 2.6.24, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-02-25       90       51          39
  2008-02-17       61       45          37


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9938
Subject		: building fails on lguest
Submitter	: Cedric OLLIVIER <ollivier.cedric@gmail.com>
Date		: 2008-02-11 15:34


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9954
Subject		: ipw3945: not only it periodically dies, it also BUG()s
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9966
Subject		: kernel BUG at kernel/power/snapshot.c:464!
Submitter	: Jeff Mahoney <jeffm@suse.com>
Date		: 2008-02-08 20:03
References	: http://lkml.org/lkml/2008/2/8/331
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10003
Subject		: hda_intel: balance control does not work correctly
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-02-16 09:58


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10011
Subject		: The computer is blocked when X is started
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2008-02-17 06:28
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10012
Subject		: 2.6.24-git4+ regression
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-01-30 14:56
References	: http://lkml.org/lkml/2008/1/30/254
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10015
Subject		: [BUG] Linux 2.6.25-rc2 - Kernel Ooops while running dbench
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-02-16 06:44
References	: http://lkml.org/lkml/2008/2/16/4


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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10020
Subject		: mips SMBUS_PSC_BASE compile errors
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-02-17 12:21
References	: http://lkml.org/lkml/2008/2/17/299


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10021
Subject		: Linux 2.6.25-rc2 regression: LVM cannot find volume group
Submitter	: Tilman Schmidt <tilman@imap.cc>
Date		: 2008-02-16 20:14
References	: http://lkml.org/lkml/2008/2/16/208
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
		  Jiri Slaby <jirislaby@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10022
Subject		: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-02-13 09:41
References	: http://lkml.org/lkml/2008/2/13/82
		  http://lkml.org/lkml/2008/2/16/17
Handled-By	: Jiri Kosina <jkosina@suse.cz>
		  Mike Galbraith <efault@gmx.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10024
Subject		: 2.6.25-rc2 regression in rt61pci wireless driver
Submitter	: Chris Clayton <chris2553@googlemail.com>
Date		: 2008-02-16 13:06
References	: http://lkml.org/lkml/2008/2/16/82
Handled-By	: Ivo van Doorn <ivdoorn@gmail.com>


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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10074
Subject		: Recent driver in linux kernel 2.6.25-rc2
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-02-19 16:39
References	: http://lkml.org/lkml/2008/2/19/248
Handled-By	: Chatre, Reinette <reinette.chatre@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10075
Subject		: regression: CD burning (k3b) went broke
Submitter	: Mike Galbraith <efault@gmx.de>
Date		: 2008-02-21 09:42
References	: http://lkml.org/lkml/2008/2/21/41
Handled-By	: Jens Axboe <jens.axboe@oracle.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10076
Subject		: 100% C0 with 2.6.25-rc
Submitter	: Jan Willies <jan@willies.info>
Date		: 2008-02-21 12:27
References	: http://marc.info/?t=120359547400004&amp;r=1&amp;w=4
Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>


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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10083
Subject		: BUG?: &quot;Cannot map mmconfig aperture&quot;
Submitter	: Diego Calleja <diegocg@gmail.com>
Date		: 2008-02-20 22:31
References	: http://lkml.org/lkml/2008/2/20/551
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


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


Regressionn with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9874
Subject		: Undocking Lenovo ThinkPad T61 causes oops
Submitter	: Lukas Hejtmanek <xhejtman@fi.muni.cz>
Date		: 2008-02-02 02:07
Handled-By	: Len Brown <lenb@kernel.org>
Patch		: http://marc.info/?l=linux-acpi&amp;m=120389632114090&amp;w=2


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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10030
Subject		: Suspend doesn't work when SD card is inserted
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-02-17 12:00
References	: http://lkml.org/lkml/2008/2/17/81
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://marc.info/?l=linux-acpi&amp;m=120389632114090&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10031
Subject		: [2.6.25-rc2] e100: Trying to free already-free IRQ 11 during suspend ...
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-02-16 13:36
References	: http://lkml.org/lkml/2008/2/17/125
Handled-By	: Kok, Auke <auke-jan.h.kok@intel.com>
Patch		: http://lkml.org/lkml/2008/2/21/259


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10048
Subject		: ipv4/fib_hash.c: fix NULL dereference
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-02-19 15:14
References	: http://lkml.org/lkml/2008/2/19/485
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/2/19/485


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10049
Subject		: net/9p/trans_virtio.c: kmalloc() enough memory
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-02-19 16:19
References	: http://lkml.org/lkml/2008/2/19/542
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/2/19/542


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10050
Subject		: message/fusion/mptbase.c: fix use-after-free's
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-02-19 16:44
References	: http://lkml.org/lkml/2008/2/19/562
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/2/19/562


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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10092
Subject		: [BUG] 2.6.25-rc2-git8 fails to boot on 486 due to TSC breakage
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-02-24
References	: http://lkml.org/lkml/2008/2/24/50
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  Mikael Pettersson <mikpe@it.uu.se>
		  H. Peter Anvin <hpa@zytor.com>
Patch		: http://lkml.org/lkml/2008/2/24/153


For details, please follow the links given in references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.24,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9832

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael
