Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbXCNSLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbXCNSLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbXCNSLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:11:03 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59455 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752767AbXCNSLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:11:00 -0400
Date: Wed, 14 Mar 2007 19:11:02 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Lord <lkml@rtr.ca>, Jim Radford <radford@blackbean.org>,
       Oliver Neukum <oneukum@suse.de>, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Randy Cushman <rcushman_linux@earthlink.net>,
       Takashi Iwai <tiwai@suse.de>, perex@suse.cz,
       alsa-devel@alsa-project.org, Vladimir Brik <no.hope@gmail.com>,
       Andi Kleen <ak@muc.de>, Ray Lee <ray-lk@madrabbit.org>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: 2.6.21-rc3: known regressions with patches
Message-ID: <20070314181102.GE18731@stusta.de>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists known regressions in Linus' tree compared to 2.6.20
with patches available.

If possible, the patches should be included in 2.6.21-rc4 for reducing 
the number of known regressiond in -rc4 a little bit.


If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : USB: Oops when connecting USB 1.1 docks
References : http://lkml.org/lkml/2007/3/4/266
Submitter  : Mark Lord <lkml@rtr.ca>
Caused-By  : Jim Radford <radford@blackbean.org>
             commit d9a7ecacac5f8274d2afce09aadcf37bdb42b93a
Handled-By : Oliver Neukum <oneukum@suse.de>
             Jim Radford <radford@blackbean.org>
Patch      : http://lkml.org/lkml/2007/3/13/217
Status     : patch available


Subject    : snd-intel8x0: no 3d surround sound
References : http://lkml.org/lkml/2007/3/5/164
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Caused-By  : Randy Cushman <rcushman_linux@earthlink.net>
             commit 831466f4ad2b5fe23dff77edbe6a7c244435e973
Handled-By : Takashi Iwai <tiwai@suse.de>
Status     : patch available


Subject    : AMD Elan: Crash after "Allocating PCI resources"
References : http://bugzilla.kernel.org/show_bug.cgi?id=8161
Submitter  : Vladimir Brik <no.hope@gmail.com>
Handled-By : Andi Kleen <ak@muc.de>
Status     : patch available


Subject    : laptop immediately resumes after suspend
References : http://lkml.org/lkml/2007/3/8/469
Submitter  : Ray Lee <ray-lk@madrabbit.org>
Caused-By  : Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
             commit ed41dab90eb40ac4911e60406bc653661f0e4ce1
Handled-By : Len Brown <lenb@kernel.org>
Patch      : http://lkml.org/lkml/2007/3/12/228
Status     : patch available



