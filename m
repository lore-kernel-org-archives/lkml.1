Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbYCaA2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbYCaA2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 20:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYCaA2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 20:28:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36748 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbYCaA2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 20:28:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.25-rc7-git5: Reported regressions from 2.6.24
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 31 Mar 2008 02:28:10 +0200
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <200803310228.11027.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.24, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.24, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-03-31      177       34          31
  2008-03-27      171       38          30
  2008-03-22      159       35          31
  2008-03-17      148       38          30
  2008-03-16      146       42          35
  2008-03-14      145       45          39
  2008-03-12      143       51          41
  2008-03-11      141       58          43
  2008-03-10      138       66          47
  2008-03-03      115       65          49
  2008-02-25       90       51          39
  2008-02-17       61       45          37


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10369
Subject		: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Submitter	: Chr <chunkeey@web.de>
Date		: 2008-03-30 21:09 (1 days old)
References	: http://lkml.org/lkml/2008/3/30/87


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10368
Subject		: regression breaks lowmem reserved RAM
Submitter	: Andrea Arcangeli <andrea@qumranet.com>
Date		: 2008-03-28 20:49 (3 days old)
References	: http://lkml.org/lkml/2008/3/28/372


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10366
Subject		: 2.6.25-rc7: warn_on_slowpath triggered
Submitter	: Bob Tracy <rct@frus.com>
Date		: 2008-03-29 17:29 (2 days old)
References	: http://lkml.org/lkml/2008/3/29/125


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10365
Subject		: usb-storage, error reading the last 8 sectors, regression in 2.6.25-rc7
Submitter	: Sergey Dolgov <solkaa@gmail.com>
Date		: 2008-03-30 11:49 (1 days old)
References	: http://lkml.org/lkml/2008/3/30/11


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10364
Subject		: 2.6.25-rc7: V4L ioctl oops
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2008-03-29 12:38 (2 days old)
References	: http://lkml.org/lkml/2008/3/29/24


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10349
Subject		: regression: am-utils stopped working in 2.6.25-rc*
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2008-03-28 15:20 (3 days old)
References	: http://lkml.org/lkml/2008/3/28/174


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10346
Subject		: Linux 2.6.25-rc6: WARNING: at net/ipv4/tcp_input.c:2510
Submitter	: Georgi Chorbadzhiyski <gf@unixsol.org>
Date		: 2008-03-27 17:29 (4 days old)
References	: http://lkml.org/lkml/2008/3/27/246


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10345
Subject		: USB HID problems after resume
Submitter	: Mark Lord <lkml@rtr.ca>
Date		: 2008-03-27 11:29 (4 days old)
References	: http://lkml.org/lkml/2008/3/27/228
		  http://lkml.org/lkml/2008/3/28/346
Handled-By	: Greg KH <gregkh@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10344
Subject		: [2.6.25-rc6] possible regression: X server dying
Submitter	: Tilman Schmidt <tilman@imap.cc>
Date		: 2008-03-24 23:38 (7 days old)
References	: http://lkml.org/lkml/2008/3/24/260
Handled-By	: Dave Airlie <airlied@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10324
Subject		: kernel panic ip_route_input
Submitter	: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Date		: 2008-03-25 12:48 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10323
Subject		: panic using bridging on linus kernel 2.6.25-rc6
Submitter	: Andy Gospodarek <andy@greyhouse.net>
Date		: 2008-03-25 11:40 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10320
Subject		: rt2x00 does not associate or give scan results
Submitter	: Marcus Better <marcus@better.se>
Date		: 2008-03-25 06:04 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10319
Subject		: 2.6.25-rc6 regression - hang on resume
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-03-25 04:44 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10305
Subject		: 2.6.25-rc6: kernel BUG at fs/sysfs/file.c:89
Submitter	: Christian Kujau <lists@nerdbynature.de>
Date		: 2008-03-21 23:35 (10 days old)
References	: http://lkml.org/lkml/2008/3/21/408


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10302
Subject		: 2.6.25-git regression with snd-hda-intel on Dell XPS M1330, no analog sound
Submitter	: Andre Tomt <andre@tomt.net>
Date		: 2008-03-21 20:03 (10 days old)
References	: http://lkml.org/lkml/2008/3/21/295
Handled-By	: Matthew Ranostay <mranostay@embeddedalley.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10300
Subject		: volume wheel does not work in 2.6.25-rc6
Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
Date		: 2008-03-21 11:42 (10 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10291
Subject		: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini Core Duo
Submitter	: Tino Keitel <tino.keitel@gmx.de>
Date		: 2008-03-20 07:05 (11 days old)
References	: http://lkml.org/lkml/2008/3/20/23


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10290
Subject		: [BUG] Linux 2.6.25-rc6 - kernel BUG at fs/mpage.c:476! on powerpc
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-03-20 13:13 (11 days old)
References	: http://lkml.org/lkml/2008/3/20/39


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10235
Subject		: 2.6.25-rc5: Blank Screen with Intel 945
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-03-12 12:02 (19 days old)
References	: http://lkml.org/lkml/2008/3/12/290
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10172
Subject		: kvm: INFO: inconsistent lock state
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-03-05 03:26 (26 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10156
Subject		: KVM &amp; Qemu crashed with infinite recursive kernel loop in the guest
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-02-28 11:25 (32 days old)
References	: http://lkml.org/lkml/2008/2/28/106


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10133
Subject		: INFO: possible circular locking in the resume
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-02-27 (33 days old)
References	: http://lkml.org/lkml/2008/2/26/479
Handled-By	: Gautham R Shenoy <ego@in.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10117
Subject		: 2.6.25-current-git hangs on boot (pci=nommconf helps)
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-02-23 18:55 (37 days old)
References	: http://lkml.org/lkml/2008/2/23/263


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10093
Subject		: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n - Apple
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-02-23 18:55 (37 days old)
References	: http://lkml.org/lkml/2008/2/23/263
		  http://marc.info/?l=linux-acpi&amp;m=120387537018467&amp;w=4
Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10082
Subject		: 2.6.25-rc2-git4 - Kernel oops while running kernbench and tbench on powerpc
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-02-20 16:01 (40 days old)
References	: http://lkml.org/lkml/2008/2/20/218
		  http://lkml.org/lkml/2008/1/18/71


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10067
Subject		: TUNER_TDA8290=y, VIDEO_DEV=n build error
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-02-22 10:36 (38 days old)
References	: http://lkml.org/lkml/2008/2/19/262


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10027
Subject		: 2.6.25-rc[12] Video4Linux Bttv Regression
Submitter	: Bongani Hlope <bonganilinux@mweb.co.za>
Date		: 2008-02-17 09:36 (43 days old)
References	: http://lkml.org/lkml/2008/2/17/55


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10011
Subject		: The computer is blocked when X is started - unless max_cstate=2 - Acer Travelmate 4001 Lmi
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2008-02-17 06:28 (43 days old)
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9980
Subject		: 2.6.25-rc1 on Sun Ultra 40- HPET clocksource which causes it to hang
Submitter	: Jasper Bryant-Greene <jasper@unix.geek.nz>
Date		: 2008-02-13 12:25 (47 days old)
References	: http://lkml.org/lkml/2008/2/13/181


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
Subject		: 2.6.25-rc1: volanoMark regression
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-02-13 10:30 (47 days old)
References	: http://lkml.org/lkml/2008/2/13/128
Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9962
Subject		: mount: could not find filesystem
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-02-12 14:34 (48 days old)
References	: http://lkml.org/lkml/2008/2/12/91
Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>


Regressionn with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10340
Subject		: suspend order - again
Submitter	: Shaohua Li <shaohua.li@intel.com>
Date		: 2008-03-14 09:22 (17 days old)
References	: http://marc.info/?l=linux-acpi&amp;m=120549574009914&amp;w=4
Handled-By	: Shaohua Li <shaohua.li@intel.com>
Patch		: http://marc.info/?l=linux-acpi&amp;m=120649617317396&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10326
Subject		: inconsistent lock state in net_rx_action
Submitter	: Marcus Better <marcus@better.se>
Date		: 2008-03-25 13:21 (6 days old)
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=10326#c20


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10153
Subject		: (regression) kernel/timeconst.h bugs with HZ=128
Submitter	: David Brownell <david-b@pacbell.net>
Date		: 2008-02-26 19:32 (34 days old)
References	: http://lkml.org/lkml/2008/2/26/294
Handled-By	: H. Peter Anvin <hpa@zytor.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15114&amp;action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=15115&amp;action=view


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.24,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9832

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael
