Return-Path: <linux-kernel-owner+w=401wt.eu-S1751391AbXAXPrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbXAXPrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 10:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbXAXPrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 10:47:22 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:2044 "HELO
	mailout.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751391AbXAXPrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 10:47:21 -0500
Date: Wed, 24 Jan 2007 16:47:25 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gd@spherenet.de,
       petero2@telia.com, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Uwe Bugla <uwe.bugla@gmx.de>, alan@lxorguk.ukuu.org.uk,
       Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>,
       Nick Piggin <nickpiggin@yahoo.com.au>, ttb@tentacle.dhs.org,
       rml@novell.com, Livio Soares <livio@eecg.toronto.edu>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Malte =?utf-8?B?U2NocsO2ZGVy?= <MalteSch@gmx.de>,
       "Vladimir V. Saveliev" <vs@namesys.com>, reiserfs-dev@namesys.com,
       Sami Farin <7atbggg02@sneakemail.com>, David Chinner <dgc@sgi.com>,
       xfs-masters@oss.sgi.com,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       takada <takada@mbf.nifty.com>, Jordan Crouse <jordan.crouse@amd.com>,
       Andrew Clayton <andrew@digital-domain.net>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: 2.6.20-rc5: known unfixed regressions (v3) (part 2)
Message-ID: <20070124154725.GK17836@stusta.de>
References: <Pine.LNX.4.64.0701121424520.11200@woody.osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0701121424520.11200@woody.osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in 2.6.20-rc5 compared to 2.6.19
that are not yet fixed in Linus' tree.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way possibly
involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : pktcdvd fails with pata_amd
References : http://bugzilla.kernel.org/show_bug.cgi?id=7810
Submitter  : gd@spherenet.de
Status     : unknown


Subject    : problems with CD burning
References : http://www.spinics.net/lists/linux-ide/msg06545.html
Submitter  : Uwe Bugla <uwe.bugla@gmx.de>
Status     : unknown


Subject    : BUG: at fs/inotify.c:172 set_dentry_child_flags()
References : http://bugzilla.kernel.org/show_bug.cgi?id=7785
Submitter  : Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>
Handled-By : Nick Piggin <nickpiggin@yahoo.com.au>
Status     : problem is being debugged


Subject    : powerpc64: performance monitor exception
References : http://ozlabs.org/pipermail/linuxppc-dev/2007-January/030045.html
Submitter  : Livio Soares <livio@eecg.toronto.edu>
Caused-By  : Paul Mackerras <paulus@samba.org>
             commit d04c56f73c30a5e593202ecfcf25ed43d42363a2
Status     : problem is being discussed


Subject    : BUG: at mm/truncate.c:60 cancel_dirty_page()  (reiserfs)
References : http://lkml.org/lkml/2007/1/7/117
             http://lkml.org/lkml/2007/1/10/202
Submitter  : Malte Schröder <MalteSch@gmx.de>
Handled-By : Vladimir V. Saveliev <vs@namesys.com>
             Nick Piggin <nickpiggin@yahoo.com.au>
Patch      : http://lkml.org/lkml/2007/1/10/202
Status     : problem is being discussed


Subject    : BUG: at mm/truncate.c:60 cancel_dirty_page()  (XFS)
References : http://lkml.org/lkml/2007/1/5/308
             http://lkml.org/lkml/2007/1/23/190
             http://lkml.org/lkml/2007/1/23/192
Submitter  : Sami Farin <7atbggg02@sneakemail.com>
Handled-By : David Chinner <dgc@sgi.com>
Status     : patches are being discussed


Subject    : fix geode_configure()
References : http://lkml.org/lkml/2007/1/9/216
Submitter  : Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Caused-By  : takada <takada@mbf.nifty.com>
             commit e4f0ae0ea63caceff37a13f281a72652b7ea71ba
Handled-By : takada <takada@mbf.nifty.com>
             Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Status     : patches are being discussed


Subject    : NFS triggers WARN_ON() in invalidate_inode_pages2_range()
References : http://bugzilla.kernel.org/show_bug.cgi?id=7826
Submitter  : Andrew Clayton <andrew@digital-domain.net>
Caused-By  : Andrew Morton <akpm@osdl.org>
             commit 8258d4a574d3a8c01f0ef68aa26b969398a0e140
Handled-By : Trond Myklebust <trond.myklebust@fys.uio.no>
Status     : Trond: the WARN_ON() needs to be thrown out


