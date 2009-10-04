Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbZJDXFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbZJDXFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 19:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758123AbZJDXFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 19:05:03 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:62169 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027AbZJDXFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 19:05:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19145.10741.402938.867088@pilspetsen.it.uu.se>
Date: Mon, 5 Oct 2009 01:04:21 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14256] kernel BUG at fs/ext3/super.c:435
In-Reply-To: <200910042249.54639.rjw@sisk.pl>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	<COE24pZSBH.A.ot.9MTxKB@chimera>
	<19144.56721.786457.979953@pilspetsen.it.uu.se>
	<200910042249.54639.rjw@sisk.pl>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki writes:
 > On Sunday 04 October 2009, Mikael Pettersson wrote:
 > > Rafael J. Wysocki wrote:
 > > > The following bug entry is on the current list of known regressions
 > > > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
 > > > be listed and let me know (either way).
 > > > 
 > > > 
 > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14256
 > > > Subject		: kernel BUG at fs/ext3/super.c:435
 > > > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
 > > > Date		: 2009-09-21 7:29 (11 days old)
 > > > References	: http://marc.info/?l=3Dlinux-kernel&m=3D125351816109264&w=3D4
 > > 
 > > The exact same bug (same cause, same symptom) just hit me again in 2.6.32-rc1.
 > 
 > Thanks for the update.
 > 
 > Could you check the current Linus' tree, please?  There are some known
 > regression fixes in there.

I tried simplified versions of the bug trigger on two machines
running 2.6.32-rc1-git6, and neither triggered the kernel bug.

The original recipe involved doing a glibc rebuild, run its test
suite, install it, and reboot. Today however machine 1 was already
doing a rebuild so after the rebuild it did a reboot into the new
kernel before the install. The second machine booted the new kernel
directly to install the binary packages from the first machine.

I'll re-run the full bug trigger recipe on a third machine later next
week (it must rebuild glibc itself anyway due to arch differences).
