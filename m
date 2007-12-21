Return-Path: <linux-kernel-owner+w=401wt.eu-S1762066AbXLUAwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762066AbXLUAwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbXLUAwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:52:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44914 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686AbXLUAwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:52:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc5-git7: Reported regressions from 2.6.23
Date: Fri, 21 Dec 2007 02:12:02 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712210212.02666.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Note: From December 22 to December 29 inclusive I will be traveling with
(most probably) limited Internet access, so the next report will likely be
posted after December 30.  I also may be unresponsive next week. ;-)]

This message contains a list of some regressions from 2.6.23 reported since
2.6.24-rc1 was released, for which there are no fixes in the mainline I know
of.  If any of them have been fixed already, please let me know.

If you know of any other unresolved regressions from 2.6.23, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Listed regressions statistics
-----------------------------

  Date          Total  Pending  Unresolved
  ----------------------------------------
  Today           118       21          13
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
Patch		: 
Workaround	: http://bugzilla.kernel.org/show_bug.cgi?id=9258#c30


Subject		: v2.6.24-rc2-409-g9418d5d: attempt to access beyond end of device
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2007-11-13 13:11
References	: http://lkml.org/lkml/2007/11/13/250
		  http://bugzilla.kernel.org/show_bug.cgi?id=9370
Handled-By	: Matthew Wilcox <matthew@wil.cx>
Patch		: 


Subject		: SError: { DevExch } occuring and causing disruption
Submitter	: Avuton Olrich <avuton@gmail.com>
Date		: 2007-11-15 22:39
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9393
Handled-By	: Tejun Heo <htejun@gmail.com>
		  Mark Lord <mlord@pobox.com>
Patch		: 


Subject		: 20000+ wake-ups/second in 2.6.24
Submitter	: Mark Lord <lkml@rtr.ca>
Date		: 2007-12-02 04:23
References	: http://lkml.org/lkml/2007/12/1/141
		  http://bugzilla.kernel.org/show_bug.cgi?id=9489
Handled-By	: Arjan van de Ven <arjan@infradead.org>
Patch		: 


Subject		: 2.6.24: false double-clicks from USB mouse
Submitter	: Mark Lord <lkml@rtr.ca>
Date		: 2007-12-02 12:05
References	: http://lkml.org/lkml/2007/12/2/86
		  http://bugzilla.kernel.org/show_bug.cgi?id=9492
Handled-By	: Jiri Kosina <jkosina@suse.cz>
		  Dmitry Torokhov <dmitry.torokhov@gmail.com>
Patch		: 


Subject		: kobject ->k_name memory leak
Submitter	: Alexey Dobriyan <adobriyan@sw.ru>
Date		: 2007-12-03 13:42
References	: http://lkml.org/lkml/2007/12/3/20
		  http://bugzilla.kernel.org/show_bug.cgi?id=9496
Handled-By	: Greg KH <gregkh@suse.de>
Patch		: 


Subject		: 2.6.24-rc4 hwmon it87 probe fails
Submitter	: Mike Houston <mikeserv@bmts.com>
Date		: 2007-12-06 17:10
References	: http://lkml.org/lkml/2007/12/4/466
		  http://bugzilla.kernel.org/show_bug.cgi?id=9514
Handled-By	: Shaohua Li <shaohua.li@intel.com>
Patch		: 


Subject		: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Submitter	: "Parag Warudkar" <parag.warudkar@gmail.com>
Date		: 2007-12-07 18:14
References	: http://lkml.org/lkml/2007/12/7/299
		  http://bugzilla.kernel.org/show_bug.cgi?id=9525
Handled-By	: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
		  Thomas Gleixner <tglx@linutronix.de>
		  Ingo Molnar <mingo@elte.hu>
Patch		: 


Subject		: BUG: bad unlock balance detected!
Submitter	: Krzysztof Oledzki <olel@ans.pl>
Date		: 2007-12-11 03:17
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9542
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Herbert Xu <herbert@gondor.apana.org.au>
Patch		: 


Subject		: PATA_HPT37X embezzles two ports
Submitter	: "Bjoern Olausson" <lkmlist@gmail.com>
Date		: 2007-12-12 11:05
References	: http://lkml.org/lkml/2007/12/12/161
		  http://bugzilla.kernel.org/show_bug.cgi?id=9551
Handled-By	: 
Patch		: 


Subject		: Could not set non-blocking flag with 2.6.24-rc5
Submitter	: Tino Keitel <tino.keitel@gmx.de>
Date		: 2007-12-13 16:27
References	: http://lkml.org/lkml/2007/12/13/392
		  http://bugzilla.kernel.org/show_bug.cgi?id=9557
Handled-By	: 
Patch		: 


Subject		: s2ram regression
Submitter	: Jan Willies <jan@willies.info>
Date		: 2007-12-16 12:02
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9585
Handled-By	: Alexey Starikovskiy <aystarik@gmail.com>
		  Rafael J. Wysocki <rjw@sisk.pl>
Patch		: 


Subject		: swapping in 2.6.24-rc5-git3
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2007-12-17 14:04
References	: http://lkml.org/lkml/2007/12/17/98
		  http://bugzilla.kernel.org/show_bug.cgi?id=9592
Handled-By	: Jan Kara <jack@suse.cz>
Patch		: 


Regressions with patches
------------------------

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


Subject		: Battery shows up twice in kpowersave
Submitter	: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date		: 2007-12-03 12:06
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9494
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14137&action=view


Subject		: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
Submitter	: Geoff Levand <geoffrey.levand@am.sony.com>
Date		: 2007-12-03 14:12
References	: http://lkml.org/lkml/2007/12/3/137
		  http://bugzilla.kernel.org/show_bug.cgi?id=9499
Handled-By	: Milton Miller <miltonm@bga.com>
		  Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
		  Yasunori Goto <y-goto@jp.fujitsu.com>
Patch		: http://lkml.org/lkml/2007/12/5/73


Subject		: RTNL: assertion failed at net/ipv6/addrconf.c (2164)/RTNL: assertion failed at net/ipv4/devinet.c (1055)
Submitter	: Krzysztof Oledzki <olel@ans.pl>
Date		: 2007-12-11 03:20
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9543
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Herbert Xu <herbert@gondor.apana.org.au>
		  Jay Vosburgh <fubar@us.ibm.com>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=9543#c6


Subject		: Important regression with XFS update for 2.6.24-rc6
Submitter	: Damien Wyart <damien.wyart@free.fr>
Date		: 2007-12-19 15:35
References	: http://lkml.org/lkml/2007/12/18/126
		  http://bugzilla.kernel.org/show_bug.cgi?id=9607
Handled-By	: David Chinner <dgc@sgi.com>
Patch		: http://lkml.org/lkml/2007/12/19/62


Subject		: xfs mknod regression
Submitter	: "Bret Towe" <magnade@gmail.com>
Date		: 2007-12-19 15:42
References	: http://lkml.org/lkml/2007/12/17/526
		  http://bugzilla.kernel.org/show_bug.cgi?id=9608
Handled-By	: Christoph Hellwig <hch@infradead.org>
Patch		: http://lkml.org/lkml/2007/12/18/200


Subject		: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Submitter	: Trond Myklebust <trond.myklebust@fys.uio.no>
Date		: 2007-12-20 16:32
References	: http://lkml.org/lkml/2007/12/20/552
		  http://bugzilla.kernel.org/show_bug.cgi?id=9610
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Ingo Molnar <mingo@elte.hu>
Patch		: http://lkml.org/lkml/2007/12/20/596


For details, please follow the links given in references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.23,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9243

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael
