Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbXA0RmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbXA0RmX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 12:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbXA0RmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 12:42:23 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39694 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752286AbXA0RmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 12:42:22 -0500
Date: Sat, 27 Jan 2007 18:42:30 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Uwe Bugla <uwe.bugla@gmx.de>, B.Zolnierkiewicz@elka.pw.edu.pl,
       linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Gerhard Dirschl <gd@spherenet.de>, Christoph Hellwig <hch@lst.de>,
       petero2@telia.com, Livio Soares <livio@eecg.toronto.edu>,
       Paul Mackerras <paulus@samba.org>, anton@samba.org,
       linuxppc-dev@ozlabs.org, Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>,
       Nick Piggin <nickpiggin@yahoo.com.au>, ttb@tentacle.dhs.org,
       rml@novell.com
Subject: 2.6.20-rc6: known unfixed regressions (v2) (part 2)
Message-ID: <20070127174230.GN6017@stusta.de>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
             commit 3b00315799d78f76531b71435fbc2643cd71ae4c
             commit 406c9b605cbc45151c03ac9a3f95e9acf050808c
Status     : problem is being debugged


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


