Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbXCMMt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbXCMMt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbXCMMt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:49:56 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57945 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753245AbXCMMtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:49:55 -0400
Date: Tue, 13 Mar 2007 13:49:57 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Pavel Machek <pavel@ucw.cz>,
       drzeus-mmc@drzeus.cx, Mark Lord <lkml@rtr.ca>,
       Jim Radford <radford@blackbean.org>, Oliver Neukum <oneukum@suse.de>,
       greg@kroah.com, linux-usb-devel@lists.sourceforge.net,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Takashi Iwai <tiwai@suse.de>, perex@suse.cz,
       alsa-devel@alsa-project.org,
       Randy Cushman <rcushman_linux@earthlink.net>
Subject: [1/6] 2.6.21-rc3: known regressions
Message-ID: <20070313124957.GR18731@stusta.de>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : crashes in KDE
References : http://bugzilla.kernel.org/show_bug.cgi?id=8157
Submitter  : Oliver Pinter <oliver.pntr@gmail.com>
Status     : unknown


Subject    : kwin dies silently
References : http://lkml.org/lkml/2007/2/28/112
Submitter  : Sid Boyce <g3vbv@blueyonder.co.uk>
Status     : unknown


Subject    : mmc card reader no longer works
References : http://lkml.org/lkml/2007/2/27/91
Submitter  : Pavel Machek <pavel@ucw.cz>
Handled-By : Oliver Neukum <oneukum@suse.de>
Status     : unknown


Subject    : USB: Oops when connecting USB 1.1 docks
References : http://lkml.org/lkml/2007/3/4/266
Submitter  : Mark Lord <lkml@rtr.ca>
Caused-By  : Jim Radford <radford@blackbean.org>
             commit d9a7ecacac5f8274d2afce09aadcf37bdb42b93a
Handled-By : Oliver Neukum <oneukum@suse.de>
             Jim Radford <radford@blackbean.org>
Status     : problem is being debugged


Subject    : snd_intel8x0: divide error: 0000
References : http://lkml.org/lkml/2007/3/5/252
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Handled-By : Takashi Iwai <tiwai@suse.de>
Status     : submitter was asked to test a patch


Subject    : snd-intel8x0: no 3d surround sound
References : http://lkml.org/lkml/2007/3/5/164
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Caused-By  : Randy Cushman <rcushman_linux@earthlink.net>
             commit 831466f4ad2b5fe23dff77edbe6a7c244435e973
Handled-By : Randy Cushman <rcushman_linux@earthlink.net>
             Takashi Iwai <tiwai@suse.de>
Status     : problem is being debugged

