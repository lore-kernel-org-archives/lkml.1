Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbXLHCVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbXLHCVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 21:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbXLHCVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 21:21:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38571 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbXLHCVq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 21:21:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Date: Sat, 8 Dec 2007 03:40:49 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712080340.49546.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.23 which have been
reported since 2.6.24-rc1 was released and for which there are no fixes in the
mainline that I know of.  If any of them have been fixed already, please let me
know.

If you know of any other unresolved regressions from 2.6.23, please let me know
either and I'll add them to the list.


Subject		: EHCI causes system to resume instantly from S4
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
References	: http://lkml.org/lkml/2007/10/27/66
		  http://bugzilla.kernel.org/show_bug.cgi?id=9258
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>
		  David Brownell <david-b@pacbell.net>
		  Alan Stern <stern@rowland.harvard.edu>
Patch		: 
Note:		: the problem appears to heavily depend on hardware


Subject		: leds: ledtrig-timer calls sleeping function from invalid context
Submitter	: Márton Németh <nm127@freemail.hu>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9264
Handled-By	: Richard Purdie <rpurdie@rpsys.net>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13493&action=view


Subject		: PATA scan: ACPI Exception AE_AML_PACKAGE_LIMIT... is beyond end of object
Submitter	: Hans de Bruin <bruinjm@xs4all.nl>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9320
Handled-By	: Robert Moore <Robert.Moore@intel.com>
		  Tejun Heo <htejun@gmail.com>
		  Fu Michael <michael.fu@intel.com>
Patch		: 


Subject		: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
Submitter	: Roland Dreier <rdreier@cisco.com>
References	: http://lkml.org/lkml/2007/11/8/255
		  http://bugzilla.kernel.org/show_bug.cgi?id=9332
Handled-By	: 
Patch		: 


Subject		: system hangs after a few minutes
Submitter	: Marcus Better <marcus@better.se>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9335
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Alan Stern <stern@rowland.harvard.edu>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13871&action=view


Subject		: cd/dvd inaccessible in 2.6.24-rc2
Submitter	: Will Trives <will@trivescon.com.au>
References	: http://lkml.org/lkml/2007/11/9/290
		  http://bugzilla.kernel.org/show_bug.cgi?id=9346
Handled-By	: Len Brown <lenb@kernel.org>
		  Tejun Heo <htejun@gmail.com>
Patch		: 


Subject		: The keyboard doesn't work
Submitter	: Francois Valenduc <francois.valenduc@skynet.be>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9362
Handled-By	: Dmitry Torokhov <dtor@insightbb.com>
		  Ingo Molnar <mingo@elte.hu>
		  Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13892&action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=13893&action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=13907&action=view
Note		: patches to apply in this order, top-down


Subject		: v2.6.24-rc2-409-g9418d5d: attempt to access beyond end of device
Submitter	: Thomas Meyer <thomas@m3y3r.de>
References	: http://lkml.org/lkml/2007/11/13/250
		  http://bugzilla.kernel.org/show_bug.cgi?id=9370
Handled-By	: Matthew Wilcox <matthew@wil.cx>
Patch		: 


Subject		: SError: { DevExch } occuring and causing disruption
Submitter	: Avuton Olrich <avuton@gmail.com>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9393
Handled-By	: Tejun Heo <htejun@gmail.com>
		  Mark Lord <mlord@pobox.com>
Patch		: 


Subject		: nfsd gets stuck when underlying filesystem is XFS
Submitter	: Christian Kujau <lists@nerdbynature.de>
		  Chris Wedgwood <cw@f00f.org>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9400
Handled-By	: "J. Bruce Fields" <bfields@fieldses.org>
		  Christoph Hellwig <hch@infradead.org>
Patch		: http://lkml.org/lkml/2007/11/25/39


Subject		: 2.6.24-rc3: find complains about /proc/net
Submitter	: Pavel Machek <pavel@ucw.cz>
References	: http://lkml.org/lkml/2007/11/19/253
		  http://bugzilla.kernel.org/show_bug.cgi?id=9411
Handled-By	: "Eric W. Biederman" <ebiederm@xmission.com>
Patch		:
Note		: the existing fix needs fixing


Subject		: Not work light of button-led with module b43 in chipset broadcom 4318
Submitter	: Cristian Aravena Romero <caravena@gmail.com>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9414
Handled-By	: 
Patch		: 


Subject		: unable to turn cooling device 'off' - LG LE50 Express laptop
Submitter	: Marcus Better <marcus@better.se>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9432
Handled-By	: Len Brown <lenb@kernel.org>
		  Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: 


Subject		: 2.6.24-rc3 can't see sd partitions on Alpha
Submitter	: Bob Tracy <rct@gherkin.frus.com>
References	: http://lkml.org/lkml/2007/11/18/3
		  http://bugzilla.kernel.org/show_bug.cgi?id=9457
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Kay Sievers <kay.sievers@vrfy.org>
		  Ingo Molnar <mingo@elte.hu>
Patch		: 


Subject		: 2.6.24-rc3-git2 softlockup detected
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References	: http://lkml.org/lkml/2007/11/28/16
		  http://bugzilla.kernel.org/show_bug.cgi?id=9472
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Ingo Molnar <mingo@elte.hu>
Patch		: 


Subject		: jiffies counter leaps in 2.6.24-rc3
Submitter	: Stefano Brivio <stefano.brivio@polimi.it>
References	: http://lkml.org/lkml/2007/11/24/53
		  http://bugzilla.kernel.org/show_bug.cgi?id=9475
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://lkml.org/lkml/2007/12/7/132


Subject		: kernel GPF in 2.6.24 (g09f345da)
Submitter	: Jon Nelson <jnelson-kernel-bugzilla@jamponi.net>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9482
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
Patch		: 


Subject		: 20000+ wake-ups/second in 2.6.24
Submitter	: Mark Lord <lkml@rtr.ca>
References	: http://lkml.org/lkml/2007/12/1/141
		  http://bugzilla.kernel.org/show_bug.cgi?id=9489
Handled-By	: Arjan van de Ven <arjan@infradead.org>
Patch		: 


Subject		: 2.6.24: false double-clicks from USB mouse
Submitter	: Mark Lord <lkml@rtr.ca>
References	: http://lkml.org/lkml/2007/12/2/86
		  http://bugzilla.kernel.org/show_bug.cgi?id=9492
Handled-By	: Jiri Kosina <jkosina@suse.cz>
Patch		: 


Subject		: Battery shows up twice in kpowersave
Submitter	: Rolf Eike Beer <eike-kernel@sf-tec.de>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9494
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: 


Subject		: kobject ->k_name memory leak
Submitter	: Alexey Dobriyan <adobriyan@sw.ru>
References	: http://lkml.org/lkml/2007/12/3/20
		  http://bugzilla.kernel.org/show_bug.cgi?id=9496
Handled-By	: Greg KH <gregkh@suse.de>
Patch		: 


Subject		: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
Submitter	: Ingo Molnar <mingo@elte.hu>
References	: http://lkml.org/lkml/2007/11/29/157
		  http://bugzilla.kernel.org/show_bug.cgi?id=9497
Handled-By	: Matt Mackall <mpm@selenic.com>
Patch		: http://lkml.org/lkml/2007/11/29/387


Subject		: Regression - 2.6.24-rc3 - umem nvram card driver oops
Submitter	: David Chinner <dgc@sgi.com>
References	: http://lkml.org/lkml/2007/12/3/216
		  http://bugzilla.kernel.org/show_bug.cgi?id=9498
Handled-By	: Neil Brown <neilb@suse.de>
Patch		: http://lkml.org/lkml/2007/12/3/266


Subject		: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
Submitter	: Geoff Levand <geoffrey.levand@am.sony.com>
References	: http://lkml.org/lkml/2007/12/3/137
		  http://bugzilla.kernel.org/show_bug.cgi?id=9499
Handled-By	: Milton Miller <miltonm@bga.com>
		  Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
		  Yasunori Goto <y-goto@jp.fujitsu.com>
Patch		: 


Subject		: binfmt_misc file system is empty
Submitter	: Marcus Better <marcus@better.se>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9504
Handled-By	: Denis V. Lunev <den@openvz.org>
Patch		:


Subject		: 2.6.24-rc4 hwmon it87 probe fails
Submitter	: Mike Houston <mikeserv@bmts.com>
References	: http://lkml.org/lkml/2007/12/4/466
		  http://bugzilla.kernel.org/show_bug.cgi?id=9514
Handled-By	: 
Patch		: 


Subject		: Major regression on hackbench with SLUB
Submitter	: Steven Rostedt <rostedt@goodmis.org>
References	: http://lkml.org/lkml/2007/12/7/181
		  http://bugzilla.kernel.org/show_bug.cgi?id=9521
Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>
Patch		: 


Subject		: 2.6.24-rc3-git4 NFS crossmnt regression
Submitter	: Shane <gnome42@gmail.com>
References	: http://lkml.org/lkml/2007/12/6/410
		  http://bugzilla.kernel.org/show_bug.cgi?id=9522
Handled-By	: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13908&action=view


Subject		: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Submitter	: "Parag Warudkar" <parag.warudkar@gmail.com>
References	: http://lkml.org/lkml/2007/12/7/299
		  http://bugzilla.kernel.org/show_bug.cgi?id=9525
Handled-By	: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Patch		: 


For details, please follow the links given in references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.23,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9243

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael
