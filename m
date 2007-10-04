Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbXJDJn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbXJDJn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbXJDJnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:43:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35992 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752509AbXJDJnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:43:49 -0400
Date: Thu, 4 Oct 2007 11:42:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: linux-kernel@vger.kernel.org, bwalle@suse.de,
       Andrew Morton <akpm@osdl.org>
Subject: kdump: documentation cleanups
Message-ID: <20071004094206.GA564@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up kdump documentation a bit. Plus I do not think we want
to mention Linux trademark in _every_ file in documentation....

Signed-off-by: Pavel Machek <pavel@suse.cz>

index 2fedc08..faf0e27 100644
--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -13,7 +13,7 @@ dump of the system kernel's memory needs
 the system panics). The system kernel's memory image is preserved across
 the reboot and is accessible to the dump-capture kernel.
 
-You can use common Linux commands, such as cp and scp, to copy the
+You can use common commands, such as cp and scp, to copy the
 memory image to a dump file on the local disk, or across the network to
 a remote system.
 
@@ -69,7 +69,7 @@ http://www.kernel.org/pub/linux/kernel/p
 
 This is a symlink to the latest version, which at the time of writing is
 20061214, the only release of kexec-tools-testing so far. As other versions
-are made released, the older onese will remain available at
+are released, the older ones will remain available at
 http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
 
 Note: Latest kexec-tools-testing git tree is available at
@@ -360,7 +360,7 @@ If die() is called, and it happens to be
 is called inside interrupt context or die() is called and panic_on_oops is set,
 the system will boot into the dump-capture kernel.
 
-On powererpc systems when a soft-reset is generated, die() is called by all cpus
+On powerpc systems when a soft-reset is generated, die() is called by all cpus
 and the system will boot into the dump-capture kernel.
 
 For testing purposes, you can trigger a crash by using "ALT-SysRq-c",
@@ -426,9 +426,3 @@ Contact
 Vivek Goyal (vgoyal@in.ibm.com)
 Maneesh Soni (maneesh@in.ibm.com)
 
-
-Trademark
-=========
-
-Linux is a trademark of Linus Torvalds in the United States, other
-countries, or both.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
