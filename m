Return-Path: <linux-kernel-owner+w=401wt.eu-S1161131AbXAZSL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161131AbXAZSL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161133AbXAZSL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:11:28 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37061 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161131AbXAZSLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:11:25 -0500
Date: Fri, 26 Jan 2007 19:11:32 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Uwe Bugla <uwe.bugla@gmx.de>, B.Zolnierkiewicz@elka.pw.edu.pl,
       linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Gerhard Dirschl <gd@spherenet.de>, Christoph Hellwig <hch@lst.de>,
       petero2@telia.com, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Venkat Yekkirala <vyekkirala@TrustedCS.com>,
       David Miller <davem@davemloft.net>, sds@tycho.nsa.gov,
       jmorris@namei.org, netdev@vger.kernel.org,
       Livio Soares <livio@eecg.toronto.edu>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>,
       Nick Piggin <nickpiggin@yahoo.com.au>, ttb@tentacle.dhs.org,
       rml@novell.com, Malte =?utf-8?B?U2NocsO2ZGVy?= <MalteSch@gmx.de>,
       "Vladimir V. Saveliev" <vs@namesys.com>, reiserfs-dev@namesys.com,
       Sami Farin <7atbggg02@sneakemail.com>, David Chinner <dgc@sgi.com>,
       xfs-masters@oss.sgi.com
Subject: 2.6.20-rc6: known unfixed regressions (part 2)
Message-ID: <20070126181132.GN17836@stusta.de>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in 2.6.20-rc6 compared to 2.6.19
that are not yet fixed in Linus' tree.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way possibly
involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : problems with CD burning
References : http://www.spinics.net/lists/linux-ide/msg06545.html
Submitter  : Uwe Bugla <uwe.bugla@gmx.de>
Status     : unknown


Subject    : pktcdvd fails with pata_amd
References : http://bugzilla.kernel.org/show_bug.cgi?id=7810
             http://lkml.org/lkml/2007/1/25/128
Submitter  : Gerhard Dirschl <gd@spherenet.de>
Caused-By  : Christoph Hellwig <hch@lst.de>
             commit 406c9b605cbc45151c03ac9a3f95e9acf050808c
             commit 3b00315799d78f76531b71435fbc2643cd71ae4c
Status     : problem is being debugged


Subject    : SELinux compile error with CONFIG_XFRM=n
References : http://lkml.org/lkml/2007/1/25/233
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Caused-By  : Venkat Yekkirala <vyekkirala@TrustedCS.com>
             commit 334c85569b8adeaa820c0f2fab3c8f0a9dc8b92e
Handled-By : Venkat Yekkirala <vyekkirala@TrustedCS.com>
             David Miller <davem@davemloft.net>
Status     : problem is being discussed


Subject    : powerpc64: performance monitor exception
References : http://ozlabs.org/pipermail/linuxppc-dev/2007-January/030045.html
Submitter  : Livio Soares <livio@eecg.toronto.edu>
Caused-By  : Paul Mackerras <paulus@samba.org>
             commit d04c56f73c30a5e593202ecfcf25ed43d42363a2
Status     : problem is being discussed


Subject    : BUG: at fs/inotify.c:172 set_dentry_child_flags()
References : http://bugzilla.kernel.org/show_bug.cgi?id=7785
Submitter  : Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>
Handled-By : Nick Piggin <nickpiggin@yahoo.com.au>
Status     : problem is being debugged


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
