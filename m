Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbXLFSZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbXLFSZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 13:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbXLFSZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 13:25:11 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40376 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751913AbXLFSZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 13:25:10 -0500
Date: Thu, 6 Dec 2007 09:50:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [patch] old debugging hacks sneaked back
Message-ID: <20071206085040.GA1642@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Old debugging hack sneaked back during x86 merge, this removes it.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
index a97313b..1e931aa 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -35,10 +35,6 @@ wakeup_code:
 	wakeup_code_start = .
 	.code16
 
- 	movw	$0xb800, %ax
-	movw	%ax,%fs
-	movw	$0x0e00 + 'L', %fs:(0x10)
-
 	cli
 	cld
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
