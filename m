Return-Path: <linux-kernel-owner+w=401wt.eu-S1762124AbXJDV4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762124AbXJDV4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760061AbXJDV4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:56:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45707 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbXJDV4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:56:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.23-rc9-git2: Known regressions from 2.6.22
Date: Fri, 5 Oct 2007 00:11:11 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710050011.12433.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This message contains a list of some known regressions from 2.6.22 for which
there are no fixes in the mainline that I know of.  If any of them have been fixed
already, please let me know.

If you know of any other unresolved regressions from 2.6.22, please let me know
either and I'll add them to the list.


Subject:	zd1211 device is no longer configured
Submitter:	Oliver Neukum <oliver@neukum.org>
References:	http://marc.info/?l=linux-usb-devel&m=118854967709322&w=2
		http://bugzilla.kernel.org/show_bug.cgi?id=8972
Caused-By:	Daniel Drake <dsd@gentoo.org>
		commit 74553aedd46b3a2cae986f909cf2a3f99369decc


Subject:	Oops while modprobing phy fixed module
Submitter:	Gabriel C <nix.or.die@googlemail.com>
References:	http://lkml.org/lkml/2007/7/14/63
		http://bugzilla.kernel.org/show_bug.cgi?id=9060
Handled-By:	Satyam Sharma <satyam.sharma@gmail.com>
		Vitaly Bordug <vitb@kernel.crashing.org>
		Tejun Heo <htejun@gmail.com>
Patch:		http://lkml.org/lkml/2007/7/18/506


Subject:	ACPI problems: 2.6.22-git17 working, 2.6.23-rc1* is not
Submitter:	Danny ter Haar <dth@dth.net>
References:	http://lkml.org/lkml/2007/7/27/298
		http://lkml.org/lkml/2007/7/29/371
		http://bugzilla.kernel.org/show_bug.cgi?id=9061
Handled-By:	Len Brown <lenb@kernel.org>


Subject:	empty suspend stopped working around 2.6.23-rc4
Submitter:	Pavel Machek <pavel@ucw.cz>
References:	http://lkml.org/lkml/2007/9/11/326
		http://bugzilla.kernel.org/show_bug.cgi?id=9075


Subject:	umount triggers a warning in jfs and takes almost a minute
Submitter:	Oliver Neukum <oliver@neukum.org>
References:	http://lkml.org/lkml/2007/9/4/73
		http://bugzilla.kernel.org/show_bug.cgi?id=9076
Handled-By:	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Patch:		http://bugzilla.kernel.org/attachment.cgi?id=13023&action=view


Subject:	build #301 failed for 2.6.23-rc6-g0d4cbb5 in linux/drivers/net/wireless/libertas/
Submitter:	Toralf Förster <toralf.foerster@gmx.de>
References:	http://lkml.org/lkml/2007/9/11/150
		http://bugzilla.kernel.org/show_bug.cgi?id=9077
Handled-By:	Randy Dunlap <randy.dunlap@oracle.com>
Patch:		http://bugzilla.kernel.org/attachment.cgi?id=12963&action=view


Subject:	NETDEV WATCHDOG: eth0: transmit timed out
Submitter:	Karl Meyer <adhocrocker@gmail.com>
References:	http://lkml.org/lkml/2007/8/13/737
		http://bugzilla.kernel.org/show_bug.cgi?id=9079
Handled-By:	Francois Romieu <romieu@fr.zoreil.com>


Subject:	Weird network problems with 2.6.23-rc2
Submitter:	Shish <shish@shishnet.org>
References:	http://lkml.org/lkml/2007/8/11/40
		http://bugzilla.kernel.org/show_bug.cgi?id=9080


Subject:	powersaving degradation, (time spend in C0 goes up after a while)
Submitter:	Christian Leber <christian@leber.de>
References:	http://lkml.org/lkml/2007/9/2/142
		http://lkml.org/lkml/2007/9/2/207
		http://bugzilla.kernel.org/show_bug.cgi?id=9081


Subject:	vga text console not working on 2.6.23-rc8
Submitter:	Santiago Garcia Mantinan <manty@manty.net>
References:	http://lkml.org/lkml/2007/9/28/342
		http://bugzilla.kernel.org/show_bug.cgi?id=9099
Handled-By:	H. Peter Anvin <hpa@zytor.com>
		Antonino A. Daplas <adaplas@gmail.com>


Subject:	kernel oops when unplugging usb mouse, sometimes hardlock when moving mouse
Submitter:	o. meijer <meijer.o@gmail.com>
References:	http://bugzilla.kernel.org/show_bug.cgi?id=9111
Handled-By:	Dmitry Torokhov <dtor@insightbb.com>


Subject:	2.6.23-rc9 boot failure (megaraid?)
Submitter:	Burton Windle <bwindle@fint.org>
References:	http://lkml.org/lkml/2007/10/2/243
		http://bugzilla.kernel.org/show_bug.cgi?id=9113
Handled-By:	Adrian Bunk <bunk@kernel.org>
		FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Caused-By:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
		commit 3f6270ef76f2ce5c134615a470685d6c2a66c07e
		[SCSI] megaraid_old: convert to use the data buffer accessors
Patch:		http://lkml.org/lkml/2007/10/4/294


Subject:	kernel BUG at arch/i386/mm/highmem.c:15!  on 2.6.23-rc8/rc9
Submitter:	gurudas pai <gurudas.pai@oracle.com>
References:	http://lkml.org/lkml/2007/10/4/61
		http://bugzilla.kernel.org/show_bug.cgi?id=9122
Handled-By:	Nick Piggin <nickpiggin@yahoo.com.au>
		Hugh Dickins <hugh@veritas.com>
Patch:		http://lkml.org/lkml/2007/10/4/256


Subject:	2.6.23-rcX SG_GET_SCSI_ID regression?
Submitter:	Joerg Platte <lists@naasa.net>
References:	http://lkml.org/lkml/2007/10/3/101
		http://bugzilla.kernel.org/show_bug.cgi?id=9123


For details, please follow the links given in references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
I'm the owner of some of these entries, so if you want me to reassign them to
someone else, please let me know.

There also is a Bugzilla entry used for tracking the regressions from 2.6.22,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9056

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Greetings,
Rafael
