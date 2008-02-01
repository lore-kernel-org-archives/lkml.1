Return-Path: <linux-kernel-owner+w=401wt.eu-S934851AbYBAAyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934851AbYBAAyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 19:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbYBAAyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 19:54:17 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54484 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751324AbYBAAyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:54:16 -0500
Date: Fri, 1 Feb 2008 01:54:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: kill misleading comments in trampoline_*.S
Message-ID: <20080201005429.GA5085@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Both trampolines actually *do* set up stack. (Is the "we jump into
compressed/head.S" comment still true?)

Signed-off-by: Pavel Machek <pavel@suse.cz>
 
diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/kernel/trampoline_32.S
index 9bcc1c6..5398547 100644
--- a/arch/x86/kernel/trampoline_32.S
+++ b/arch/x86/kernel/trampoline_32.S
@@ -11,9 +11,6 @@
  *	trampoline page to make our stack and everything else
  *	is a mystery.
  *
- *	In fact we don't actually need a stack so we don't
- *	set one up.
- *
  *	We jump into the boot/compressed/head.S code. So you'd
  *	better be running a compressed kernel image or you
  *	won't get very far.
diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
index e30b67c..4aedd0b 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/kernel/trampoline_64.S
@@ -10,9 +10,6 @@
  *	trampoline page to make our stack and everything else
  *	is a mystery.
  *
- *	In fact we don't actually need a stack so we don't
- *	set one up.
- *
  *	On entry to trampoline_data, the processor is in real mode
  *	with 16-bit addressing and 16-bit data.  CS has some value
  *	and IP is zero.  Thus, data addresses need to be absolute

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
