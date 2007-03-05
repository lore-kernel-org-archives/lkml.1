Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbXCEBvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbXCEBvG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXCEBuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:50:35 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49975 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbXCEBua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:50:30 -0500
Date: Mon, 5 Mar 2007 02:50:31 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Pavel Machek <pavel@ucw.cz>,
       Marcel Holtmann <marcel@holtmann.org>, linux-pm@lists.osdl.org,
       maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Matt Mackall <mpm@selenic.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Albert Hopkins <kernel@marduk.letterboxes.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org
Subject: [1/6] 2.6.21-rc2: known regressions
Message-ID: <20070305015031.GF3441@stusta.de>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in 2.6.21-rc2 compared to 2.6.20
that are not yet fixed in Linus' tree.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way 
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : kwin dies silently
References : http://lkml.org/lkml/2007/2/28/112
Submitter  : Sid Boyce <g3vbv@blueyonder.co.uk>
Status     : unknown


Subject    : resume: slab error in verify_redzone_free(): cache `size-512':
                     memory outside object was overwritten
References : http://lkml.org/lkml/2007/2/24/41
Submitter  : Pavel Machek <pavel@ucw.cz>
Handled-By : Marcel Holtmann <marcel@holtmann.org>
Status     : unknown


Subject    : bluetooth hardlocks
References : http://lkml.org/lkml/2007/3/2/85
Submitter  : Pavel Machek <pavel@ucw.cz>
Status     : unknown


Subject    : Bluetooth RFComm locks up the machine  (device_move() related)
References : http://lkml.org/lkml/2007/3/4/64
Submitter  : Mark Lord <lkml@rtr.ca>
Caused-By  : Marcel Holtmann <marcel@holtmann.org>
             commit c1a3313698895d8ad4760f98642007bf236af2e8
Status     : unknown


Subject    : kref refcounting breakage
References : http://lkml.org/lkml/2007/3/2/67
Submitter  : Andrew Morton <akpm@linux-foundation.org>
Handled-By : Greg KH <greg@kroah.com>
Status     : unknown


Subject    : wireless breakage (ipw2200, iwconfig, NetworkManager)
References : http://lkml.org/lkml/2007/3/4/135
Submitter  : Matt Mackall <mpm@selenic.com>
Caused-By  : Greg Kroah-Hartman <gregkh@suse.de> (?)
             commit 43cb76d91ee85f579a69d42bc8efc08bac560278 (?)
Handled-By : Johannes Berg <johannes@sipsolutions.net>
Status     : unknown


Subject    : forcedeth: skb_over_panic
References : http://bugzilla.kernel.org/show_bug.cgi?id=8058
Submitter  : Albert Hopkins <kernel@marduk.letterboxes.org>
Status     : unknown

