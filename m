Return-Path: <linux-kernel-owner+w=401wt.eu-S964807AbXCSUjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807AbXCSUjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964806AbXCSUjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:39:42 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35629 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964796AbXCSUjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:39:41 -0400
Date: Mon, 19 Mar 2007 21:39:43 +0100
From: Adrian Bunk <bunk@stusta.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Colchao <colchaodemola@gmail.com>, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org, Ray Lee <ray-lk@madrabbit.org>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       Tomas Janousek <tomi@nomi.cz>, Thomas Meyer <thomas@m3y3r.de>,
       Milan Broz <mbroz@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Randy Cushman <rcushman_linux@earthlink.net>,
       Takashi Iwai <tiwai@suse.de>, perex@suse.cz,
       alsa-devel@alsa-project.org, Mark Lord <lkml@rtr.ca>,
       Jim Radford <radford@blackbean.org>, Oliver Neukum <oneukum@suse.de>,
       greg@kroah.com, linux-usb-devel@lists.sourceforge.net
Subject: 2.6.21-rc4: known regressions with patches available
Message-ID: <20070319203943.GZ752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Let's not bore people running -rc kernels with regressions that have 
patches available - let's get this patches into the tree for giving 
them the pure exciting experience of the many unfixed regressions.


This email lists some known regressions in Linus' tree compared to 2.6.20
with patches available.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : acpi_serialize locks system during boot
References : http://bugzilla.kernel.org/show_bug.cgi?id=8171
Submitter  : Colchao <colchaodemola@gmail.com>
Handled-By : Len Brown <len.brown@intel.com>
Patch      : http://bugzilla.kernel.org/show_bug.cgi?id=8171
Status     : patch available


Subject    : laptop immediately resumes after suspend
References : http://lkml.org/lkml/2007/3/8/469
Submitter  : Ray Lee <ray-lk@madrabbit.org>
Caused-By  : Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
             commit ed41dab90eb40ac4911e60406bc653661f0e4ce1
Handled-By : Len Brown <lenb@kernel.org>
Patch      : http://lkml.org/lkml/2007/3/12/228
Status     : patch available


Subject    : suspend/resume hangs (until keypress)  (CONFIG_NO_HZ)
References : http://bugzilla.kernel.org/show_bug.cgi?id=8181
             http://lkml.org/lkml/2007/3/11/112
Submitter  : Tomas Janousek <tomi@nomi.cz>
             Thomas Meyer <thomas@m3y3r.de>
             Milan Broz <mbroz@redhat.com>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Patch      : http://lkml.org/lkml/2007/3/16/406
Status     : patch available


Subject    : snd-intel8x0: no 3d surround sound
References : http://lkml.org/lkml/2007/3/5/164
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Caused-By  : Randy Cushman <rcushman_linux@earthlink.net>
             commit 831466f4ad2b5fe23dff77edbe6a7c244435e973
Handled-By : Takashi Iwai <tiwai@suse.de>
Status     : patch available


Subject    : USB: Oops when connecting USB 1.1 docks
References : http://lkml.org/lkml/2007/3/4/266
Submitter  : Mark Lord <lkml@rtr.ca>
Caused-By  : Jim Radford <radford@blackbean.org>
             commit d9a7ecacac5f8274d2afce09aadcf37bdb42b93a
Handled-By : Oliver Neukum <oneukum@suse.de>
             Jim Radford <radford@blackbean.org>
Patch      : http://lkml.org/lkml/2007/3/13/217
Status     : patch available

