Return-Path: <linux-kernel-owner+w=401wt.eu-S932879AbXCRStp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbXCRStp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 14:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbXCRStj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 14:49:39 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34359 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932873AbXCRStV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 14:49:21 -0400
Date: Sun, 18 Mar 2007 19:49:23 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tomas Janousek <tomi@nomi.cz>, Thomas Meyer <thomas@m3y3r.de>,
       Milan Broz <mbroz@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       pavel@suse.cz, linux-pm@lists.osdl.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>,
       Soeren Sonnenburg <kernel@nn7.de>, Tejun Heo <htejun@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [4/6] 2.6.21-rc4: known regressions
Message-ID: <20070318184923.GX752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : suspend/resume hangs (until keypress)  (CONFIG_NO_HZ)
References : http://bugzilla.kernel.org/show_bug.cgi?id=8181
             http://lkml.org/lkml/2007/3/11/112
Submitter  : Tomas Janousek <tomi@nomi.cz>
             Thomas Meyer <thomas@m3y3r.de>
             Milan Broz <mbroz@redhat.com>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Patch      : http://lkml.org/lkml/2007/3/16/406
Status     : patch available


Subject    : system doesn't come out of suspend  (CONFIG_NO_HZ)
References : http://lkml.org/lkml/2007/2/22/391
Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
             Soeren Sonnenburg <kernel@nn7.de>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
             Ingo Molnar <mingo@elte.hu>
             Tejun Heo <htejun@gmail.com>
             Rafael J. Wysocki <rjw@sisk.pl>
Status     : problem is being debugged


Subject    : first disk access after resume takes several minutes
             ('date' does not advance after resume from RAM, CONFIG_NO_HZ=n)
References : http://lkml.org/lkml/2007/3/8/117
Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
             Ingo Molnar <mingo@elte.hu>
Status     : problem is being debugged


Subject    : after resume: X hangs after drawing a couple of windows
References : http://lkml.org/lkml/2007/3/8/117
Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
Status     : unknown

