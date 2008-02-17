Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbYBQWF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbYBQWF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 17:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYBQWFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 17:05:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39704 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbYBQWFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 17:05:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.25-rc2: Reported regressions from 2.6.24
Date: Sun, 17 Feb 2008 23:03:59 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802172304.00322.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This is a bit late, for which I'm sorry, but I waited for things to calm down
a bit, to have something less of a moving target.

Now, following an Ingo's advice, the list has been generated directly out of
the Bugzilla entries used for tracking the bugs.  I'm going to release the
script used for generating the list, so that it can be recreated by anyone on
the fly.]

This message contains a list of some regressions from 2.6.24 reported since
2.6.25-rc1 was released, for which there are no fixes in the mainline I know
of.  If any of them have been fixed already, please let me know.

If you know of any other unresolved regressions from 2.6.24, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-02-17       61       45          37


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9833
Subject		: VIDEO_DEV=y/m, I2C=n compile error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-01-27 13:11
References	: http://lkml.org/lkml/2008/1/27/175


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9842
Subject		: key 49 and 94 send both 49 and 94 events on macbooks REGRESSION
Submitter	: Emil Karlson <jkarlson@cc.hut.fi>
Date		: 2008-01-29 08:15


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9874
Subject		: Undocking Lenovo ThinkPad T61 causes oops
Submitter	: Lukas Hejtmanek <xhejtman@fi.muni.cz>
Date		: 2008-02-02 02:07
Handled-By	: Len Brown <lenb@kernel.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9938
Subject		: building fails on lguest
Submitter	: Cedric OLLIVIER <ollivier.cedric@gmail.com>
Date		: 2008-02-11 15:34


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9948
Subject		: [BUG] 2.6.25-rc1-git1 softlockup while bootup on powerpc
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-02-12 08:09
References	: http://lkml.org/lkml/2008/2/12/44
Handled-By	: Ingo Molnar <mingo@elte.hu>


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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9966
Subject		: kernel BUG at kernel/power/snapshot.c:464!
Submitter	: Jeff Mahoney <jeffm@suse.com>
Date		: 2008-02-08 20:03
References	: http://lkml.org/lkml/2008/2/8/331
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9973
Subject		: My mm-mystery-crash has now sneaked into mainline
Submitter	: Torsten Kaiser <just.for.lkml@googlemail.com>
Date		: 2008-02-11 22:46
References	: http://lkml.org/lkml/2008/2/11/424
Handled-By	: Stefan Richter <stefanr@s5r6.in-berlin.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
Subject		: 2.6.25-rc1: volanoMark 45% regression
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-02-13 10:30
References	: http://lkml.org/lkml/2008/2/13/128
Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9980
Subject		: 2.6.25-rc1 on Sun Ultra 40
Submitter	: Jasper Bryant-Greene <jasper@unix.geek.nz>
Date		: 2008-02-13 12:25
References	: http://lkml.org/lkml/2008/2/13/181


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9982
Subject		: 2.6.25-rc1 panics on boot
Submitter	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Date		: 2008-02-13 18:03
References	: http://lkml.org/lkml/2008/2/13/363
Handled-By	: Chris Snook <csnook@redhat.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9983
Subject		: PROBLEM: 2.6.25-rc1-git2 freezes when accessing external USB hard disk (ehci-hcd)
Submitter	: Linas ®virblis <0x0007@gmail.com>
Date		: 2008-02-13 22:38
References	: http://lkml.org/lkml/2008/2/13/566


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9984
Subject		: problem with starting 2.5.25-rc1 and latest git
Submitter	: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date		: 2008-02-13 23:16
References	: http://lkml.org/lkml/2008/2/13/587


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9992
Subject		: 2.6.24-git: kmap_atomic() WARN_ON()
Submitter	: Thomas Gleixner <tglx@linutronix.de>
Date		: 2008-02-07 00:58
References	: http://lkml.org/lkml/2008/2/6/451


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9995
Subject		: 2.6.25-rc1 regression - IBM ACPI backlight controlls do not work
Submitter	: Lukas Hejtmanek <xhejtman@fi.muni.cz>
Date		: 2008-02-15 04:51


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10002
Subject		: wpa_supplicant doens't work and froze the computer
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2008-02-16 08:25


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10003
Subject		: hda_intel: balance control does not work correctly
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-02-16 09:58


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10011
Subject		: The computer is blocked when X is started
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2008-02-17 06:28


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10012
Subject		: 2.6.24-git4+ regression
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-01-30 14:56
References	: http://lkml.org/lkml/2008/1/30/254
Handled-By	: Ingo Molnar <mingo@elte.hu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10013
Subject		: tbench regression in 2.6.25-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-02-15 02:52
References	: http://lkml.org/lkml/2008/2/14/546
Handled-By	: Eric Dumazet <dada1@cosmosbay.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10014
Subject		: commit 45b503548210fe6f23e92b856421c2a3f05fd034 is broken
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-02-16 03:08
References	: http://lkml.org/lkml/2008/2/15/542


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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10019
Subject		: mips/bcm47xx/setup.c compile error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-02-17 12:19
References	: http://lkml.org/lkml/2008/2/17/297


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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10022
Subject		: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-02-13 09:41
References	: http://lkml.org/lkml/2008/2/13/82
Handled-By	: Jiri Kosina <jkosina@suse.cz>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10024
Subject		: 2.6.25-rc2 regression in rt61pci wireless driver
Submitter	: Chris Clayton <chris2553@googlemail.com>
Date		: 2008-02-16 13:06
References	: http://lkml.org/lkml/2008/2/16/82


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10025
Subject		: Current git very broken on the Dreamcast
Submitter	: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Date		: 2008-02-16 19:38
References	: http://lkml.org/lkml/2008/2/16/196
Handled-By	: Kristoffer Ericson <kristoffer.ericson@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10026
Subject		: 2.6.25-rc1/2 CD/DVD burning broken
Submitter	: Andreas Schwab <schwab@suse.de>
Date		: 2008-02-16 21:52
References	: http://lkml.org/lkml/2008/2/16/262
Handled-By	: Jeff Garzik <jeff@garzik.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10027
Subject		: 2.6.25-rc[12] Video4Linux Bttv Regression
Submitter	: Bongani Hlope <bonganilinux@mweb.co.za>
Date		: 2008-02-17 09:36
References	: http://lkml.org/lkml/2008/2/17/55


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10029
Subject		: [2.6.25-rc2] System freezes ca. 1 minute after logging into KDE
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-02-17 11:39
References	: http://lkml.org/lkml/2008/2/17/78


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10030
Subject		: Suspend doesn't work when SD card is inserted
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-02-17 12:00
References	: http://lkml.org/lkml/2008/2/17/81
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10031
Subject		: [2.6.25-rc2] e100: Trying to free already-free IRQ 11 during suspend ...
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-02-16 13:36
References	: http://lkml.org/lkml/2008/2/17/125


Regressionn with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9947
Subject		: [ata crash] Re: Linux 2.6.25-rc1
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-02-12 09:18
References	: http://lkml.org/lkml/2008/2/12/67
Handled-By	: Tejun Heo <htejun@gmail.com>
Patch		: http://lkml.org/lkml/2008/2/13/111


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9951
Subject		: [2.6.25-rc1] Strange regression with CONFIG_HZ_300=y
Submitter	: Carlos R. Mafra <crmafra@gmail.com>
Date		: 2008-02-11 14:41
References	: http://lkml.org/lkml/2008/2/11/161
Handled-By	: H. Peter Anvin <hpa@zytor.com>
Patch		: http://lkml.org/lkml/2008/2/12/351


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9960
Subject		: [2.6.25-rc0 System no longer powers off after shutdown
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-02-11 16:23
References	: http://lkml.org/lkml/2008/2/11/198
Handled-By	: Greg KH <gregkh@suse.de>
Patch		: http://lkml.org/lkml/2008/2/8/342


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9969
Subject		: 2.6.24-git15 Keyboard Issue?
Submitter	: Chris Holvenstot <cholvenstot@comcast.net>
Date		: 2008-02-06 14:02
References	: http://lkml.org/lkml/2008/2/6/100
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
Patch		: http://lkml.org/lkml/2008/2/15/343


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9976
Subject		: BUG: 2.6.25-rc1: iptables postrouting setup causes oops
Submitter	: Ben Nizette <bn@niasdigital.com>
Date		: 2008-02-12 12:46
References	: http://lkml.org/lkml/2008/2/12/148
Handled-By	: Haavard Skinnemoen <hskinnemoen@atmel.com>
Patch		: http://lkml.org/lkml/2008/2/13/177


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9979
Subject		: [build bug] sound/drivers/opl3/opl3_synth.c
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-02-01 11:17
References	: http://lkml.org/lkml/2008/2/1/140
Handled-By	: Takashi Iwai <tiwai@suse.de>
Patch		: http://lkml.org/lkml/2008/2/1/152


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10018
Subject		: CRYPTO_NULL must select CRYPTO_BLKCIPHER
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-02-17 12:17
References	: http://lkml.org/lkml/2008/2/17/296
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/2/17/296


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10023
Subject		: 2.6.25-rc2 vdso_install breaks user &quot;make install&quot;
Submitter	: Rene Herman <rene.herman@keyaccess.nl>
Date		: 2008-02-16 04:31
References	: http://lkml.org/lkml/2008/2/15/555
Handled-By	: Sam Ravnborg <sam@ravnborg.org>
Patch		: http://lkml.org/lkml/2008/2/16/73


For details, please follow the links given in references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.24,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9832

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael
