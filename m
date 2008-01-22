Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYAVWMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYAVWMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbYAVWMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:12:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60231 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbYAVWMU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:12:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc8-git5: Reported regressions from 2.6.23
Date: Tue, 22 Jan 2008 23:09:55 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801222309.55876.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.23 reported since
2.6.24-rc1 was released, for which there are no fixes in the mainline I know
of.  If any of them have been fixed already, please let me know.

If you know of any other unresolved regressions from 2.6.23, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  Today           165       27          15
  2008-01-18      157       25          12
  2008-01-12      150       28          14
  2008-01-05      139       28          15
  2008-01-01      139       38          23
  2007-12-21      118       21          13
  2007-12-18      115       29          15
  2007-12-12      106       31          17
  2007-12-08       98       29          19
  2007-12-01       85       29          18
  2007-11-24       75       25          21
  2007-11-19       68       26          21
  2007-11-17       65       25          20


Unresolved regressions
----------------------

Subject		: EHCI causes system to resume instantly from S4
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
Date		: 2007-10-28 14:56
References	: http://lkml.org/lkml/2007/10/27/66
		  http://bugzilla.kernel.org/show_bug.cgi?id=9258
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>
		  David Brownell <david-b@pacbell.net>
		  Alan Stern <stern@rowland.harvard.edu>
Workaround	: http://bugzilla.kernel.org/show_bug.cgi?id=9258#c30


Subject		: SError: { DevExch } occuring and causing disruption
Submitter	: Avuton Olrich <avuton@gmail.com>
Date		: 2007-11-15 22:39
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9393
Handled-By	: Tejun Heo <htejun@gmail.com>
		  Mark Lord <mlord@pobox.com>


Subject		: BUG: bad unlock balance detected!
Submitter	: Krzysztof Oledzki <olel@ans.pl>
Date		: 2007-12-11 03:17
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9542
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Herbert Xu <herbert@gondor.apana.org.au>


Subject		: swapping in 2.6.24-rc5-git3
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2007-12-17 14:04
References	: http://lkml.org/lkml/2007/12/17/98
		  http://bugzilla.kernel.org/show_bug.cgi?id=9592
Handled-By	: Jan Kara <jack@suse.cz>


Subject		: Problems on booting
Submitter	: "werner" <werner@copaya.yi.org>
Date		: 2007-12-22 14:29
References	: http://lkml.org/lkml/2007/12/22/110
		  http://bugzilla.kernel.org/show_bug.cgi?id=9621


Subject		: ACPI or radeon: spontaneous reboot regression
Submitter	: Matt Mackall <mpm@selenic.com>
Date		: 2007-12-22 16:09
References	: http://lkml.org/lkml/2007/12/22/139
		  http://bugzilla.kernel.org/show_bug.cgi?id=9624
Handled-By	: Len Brown <lenb@kernel.org>


Subject		: lockdep warning with LTP dio test (v2.6.24-rc6-125-g5356f66)
Submitter	: Erez Zadok <ezk@cs.sunysb.edu>
Date		: 2007-12-24 18:02
References	: http://lkml.org/lkml/2007/12/24/107
		  http://bugzilla.kernel.org/show_bug.cgi?id=9670


Subject		: kexec buffer error
Submitter	: Randy Dunlap <rdunlap@xenotime.net>
Date		: 2008-01-04 22:54
References	: http://lkml.org/lkml/2008/1/4/255
		  http://bugzilla.kernel.org/show_bug.cgi?id=9693


Subject		: 2.6.24-rc7 -- WARNING: at kernel/lockdep.c:2662 check_flags()
Submitter	: "Miles Lane" <miles.lane@gmail.com>
Date		: 2008-01-07 04:34
References	: http://lkml.org/lkml/2008/1/6/313
		  http://bugzilla.kernel.org/show_bug.cgi?id=9737
Handled-By	: Ingo Molnar <mingo@elte.hu>


Subject		: [BUG] 2.6.24-rc5: 'sysctl table check failed' when turning on printer
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2007-12-16 21:19
References	: http://lkml.org/lkml/2007/12/16/121
		  http://lkml.org/lkml/2008/1/6/228
		  http://bugzilla.kernel.org/show_bug.cgi?id=9749
Handled-By	: "Eric W. Biederman" <ebiederm@xmission.com>


Subject		: Clock is running too fast using acpi_pm clocksource
Submitter	: tosn00j02@sneakemail.com
Date		: 2008-01-21 12:38
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9791
Handled-By	: John Stultz <johnstul@us.ibm.com>


Subject		: Cannot allocate resource region 7 of bridge 0000:00:05.0
Submitter	: Artem Goncharov <artem.goncharov@gmail.com>
Date		: 2008-01-22 10:28
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9796


Subject		: Fan resume not working on nx6325 without userland assistance
Submitter	: "Rafael J. Wysocki" <rjw@sisk.pl>
Date		: 2008-01-22 02:41
References	: http://marc.info/?t=120096647100001&r=1&w=4
		  http://bugzilla.kernel.org/show_bug.cgi?id=9798
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>


Subject		: 2.6.24-rc8 oops ext3_clear_inode+0x25/0xa0
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-01-18 19:39
References	: http://lkml.org/lkml/2008/1/18/408
		  http://bugzilla.kernel.org/show_bug.cgi?id=9799


Subject		: 2.6.24-rc8: possible circular locking dependency detected
Submitter	: Christian Kujau <lists@nerdbynature.de>
Date		: 2008-01-18 22:45
References	: http://lkml.org/lkml/2008/1/18/522
		  http://bugzilla.kernel.org/show_bug.cgi?id=9800


Regressionn with patches
------------------------

Subject		: [2.6.24-rc6] pdflush still stuck in D state regression
Submitter	: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Date		: 2007-11-02 09:54
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9291
Handled-By	: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14219&action=view


Subject		: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
Submitter	: Roland Dreier <rdreier@cisco.com>
Date		: 2007-11-08 14:55
References	: http://lkml.org/lkml/2007/11/8/255
		  http://bugzilla.kernel.org/show_bug.cgi?id=9332
Handled-By	: Takashi Iwai <tiwai@suse.de>
		  Ingo Molnar <mingo@elte.hu>
Patch		: http://lkml.org/lkml/2007/11/16/66


Subject		: jiffies counter leaps in 2.6.24-rc3
Submitter	: Stefano Brivio <stefano.brivio@polimi.it>
Date		: 2007-11-29 08:36
References	: http://lkml.org/lkml/2007/11/24/53
		  http://bugzilla.kernel.org/show_bug.cgi?id=9475
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://lkml.org/lkml/2007/12/7/132


Subject		: 2.6.24-rc4 hwmon it87 probe fails
Submitter	: Mike Houston <mikeserv@bmts.com>
Date		: 2007-12-06 17:10
References	: http://lkml.org/lkml/2007/12/4/466
		  http://bugzilla.kernel.org/show_bug.cgi?id=9514
Handled-By	: Mark M. Hoffman <mhoffman@lightlink.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14267&action=view


Subject		: RTNL: assertion failed at net/ipv6/addrconf.c (2164)/RTNL: assertion failed at net/ipv4/devinet.c (1055)
Submitter	: Krzysztof Oledzki <olel@ans.pl>
Date		: 2007-12-11 03:20
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9543
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Herbert Xu <herbert@gondor.apana.org.au>
		  Jay Vosburgh <fubar@us.ibm.com>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=9543#c6


Subject		: PATA_HPT37X embezzles two ports
Submitter	: "Bjoern Olausson" <lkmlist@gmail.com>
Date		: 2007-12-12 11:05
References	: http://lkml.org/lkml/2007/12/12/161
		  http://bugzilla.kernel.org/show_bug.cgi?id=9551
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
Patch		: http://lkml.org/lkml/2007/1/4/161


Subject		: wake on lan fails with sky2 module
Submitter	: cpo <supersud501@yahoo.de>
Date		: 2008-01-09 13:05
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9721
		  http://marc.info/?t=119992349300001&r=1&w=4
Handled-By	: Stephen Hemminger <shemminger@linux-foundation.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14455&action=view


Subject		: psmouse.c: GlidePoint at isa0060/serio1/input0 lost sync at byte 1
Submitter	: "Vegard Nossum" <vegard.nossum@gmail.com>
Date		: 2007-11-14 21:26
References	: http://lkml.org/lkml/2007/11/14/363
		  http://bugzilla.kernel.org/show_bug.cgi?id=9727
Handled-By	: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Patch		: http://lkml.org/lkml/2008/1/16/151


Subject		: regression: sysctl_check changes in 2.6.24 are O(n) resulting in slow creation of 10000 network interfaces
Submitter	: Benjamin LaHaise <bcrl@kvack.org>
Date		: 2008-01-06 23:03
References	: http://lkml.org/lkml/2008/1/6/248
		  http://bugzilla.kernel.org/show_bug.cgi?id=9736
Handled-By	: "Eric W. Biederman" <ebiederm@xmission.com>
Patch		: http://lkml.org/lkml/2008/1/7/60


Subject		: Oops on boot from laptop mode writing to /proc/acpi/processor/CPU0/throttling
Submitter	: Simon Huggins <huggie@earth.li>
Date		: 2008-01-14 11:19
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9747
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14456&action=view


Subject		: crash in kmem_cache_init
Submitter	: Olaf Hering <olaf@aepfle.de>
Date		: 2008-01-15 16:09
References	: http://lkml.org/lkml/2008/1/15/180
		  http://bugzilla.kernel.org/show_bug.cgi?id=9755
Handled-By	: Mel Gorman <mel@csn.ul.ie>
Patch		: http://lkml.org/lkml/2008/1/22/247


Subject		: possible recursive locking detected, in pty code?
Submitter	: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Date		: 2008-01-21 08:22
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9786
		  http://lkml.org/lkml/2008/1/21/179
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
Patch		: http://lkml.org/lkml/2008/1/13/84


For details, please follow the links given in references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.23,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9243

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael
