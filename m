Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbXJ1Wf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbXJ1Wf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXJ1Wfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:35:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60699 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXJ1Wfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:35:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc1-git4: Reported regressions from 2.6.23
Date: Sun, 28 Oct 2007 23:51:55 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710282351.56284.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.23 which have been
reported since 2.6.24-rc1 was released and for which there are no fixes in the
mainline that I know of.  If any of them have been fixed already, please let me
know.

If you know of any other unresolved regressions from 2.6.23, please let me know
either and I'll add them to the list.


Subject		: Settings to /proc/sys/net/ipv[46]/conf/all are not propagated. via sysctl too
Submitter	: Serge van den Boom <svdb+linux-kernel-bugs@stack.nl>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9224
Handled-By	: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>


Subject		: linux-2.6.23-git3: Many sysfs-related warnings in dmesg
Submitter	: "Rafael J. Wysocki" <rjw@sisk.pl>
References	: http://lkml.org/lkml/2007/10/13/204
		  http://lkml.org/lkml/2007/10/26/317
		  http://bugzilla.kernel.org/show_bug.cgi?id=9244
Handled-By	: Greg KH <gregkh@suse.de>
		  Kay Sievers <kay.sievers@vrfy.org>
Patch		: http://lkml.org/lkml/2007/10/26/359


Subject		: On 2.6.24-rc1-gc9927c2b BUG: unable to handle kernel paging request at virtual address 3d15b925
Submitter	: Giacomo Catenazzi <cate@cateee.net>
References	: http://lkml.org/lkml/2007/10/24/487
		  http://bugzilla.kernel.org/show_bug.cgi?id=9246


Subject		: Potential regression in -git15: can't resume stopped root shell?
Submitter	: Theodore Tso <tytso@mit.edu>
References	: http://lkml.org/lkml/2007/10/20/114
		  http://bugzilla.kernel.org/show_bug.cgi?id=9247


Subject		: 2.6.24-rc1 fails with lockup and BUG:
Submitter	: Romano Giannetti <romanol@upcomillas.es>
References	: http://lkml.org/lkml/2007/10/24/232
		  http://bugzilla.kernel.org/show_bug.cgi?id=9248
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Stephen Hemminger <shemminger@linux-foundation.org>
Patch		: http://lkml.org/lkml/2007/10/26/382


Subject		: irq 21: nobody cared 2.6.24-rc1
Submitter	: Bongani Hlope <bonganilinux@mweb.co.za>
References	: http://lkml.org/lkml/2007/10/25/90
		  http://bugzilla.kernel.org/show_bug.cgi?id=9249


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


Subject		: 2.6.24-rc1-gec3b67c1 broken reg. libata-sata_nv in non NCQ mode
Submitter	: Prakash Punnoor <prakash@punnoor.de>
References	: http://lkml.org/lkml/2007/10/27/34
		  http://bugzilla.kernel.org/show_bug.cgi?id=9253


Subject		: 2.6.24-rc1 freezes on powerbook at first boot stage
Submitter	: Elimar Riesebieter <riesebie@lxtec.de>
References	: http://lkml.org/lkml/2007/10/24/205
		  http://bugzilla.kernel.org/show_bug.cgi?id=9254


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


Subject		: Commit "Hibernation: Enter platform hibernation state in a consistent way)" makes my system to resume instantly from S4
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
References	: http://lkml.org/lkml/2007/10/27/66
		  http://bugzilla.kernel.org/show_bug.cgi?id=9258
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>


Subject		: [2.6.24-rc1 regression] suspend fails
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
References	: http://lkml.org/lkml/2007/10/25/297
		  http://bugzilla.kernel.org/show_bug.cgi?id=9259
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>
Patch		: http://marc.info/?l=linux-mm-commits&m=119318609013090&w=2


For details, please follow the links given in references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
I'm the owner of some of these entries, so if you want me to reassign them to
someone else, please let me know.

There also is a Bugzilla entry used for tracking the regressions from 2.6.23,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9243

Please let me know if there are any Bugzilla entries that should be added to
the list in there.


RE: Regressions from 2.6.22

Unfortunately, I'm unable to follow all of the regressions from 2.6.22 reported
since 2.6.23 was released.  Still, there is the Bugzilla entry at:

http://bugzilla.kernel.org/show_bug.cgi?id=9056

that can be used for tracking them.  If you know of any such regression which
has not been fixed in the mainline yet, please create a Bugzilla entry for it
and link it to Bug #9056 (it's sufficient to mark it as blocking Bug #9056 for
this purpose).


Greetings,
Rafael
