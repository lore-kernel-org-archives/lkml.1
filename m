Return-Path: <linux-kernel-owner+w=401wt.eu-S1760932AbYFMMbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760932AbYFMMbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 08:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbYFMMbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 08:31:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40953 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759257AbYFMMbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 08:31:10 -0400
Date: Fri, 13 Jun 2008 13:07:26 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       "Dunlap, Randy" <rdunlap@xenotime.net>
Subject: fix stale references in Doc*/kernel-parameters.txt
Message-ID: <20080613110726.GA5267@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix stale references to source files in kernel-parameters.txt.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 9d0651da52b63d692a2dc461d9225464a89e090d
tree d4b5f4a63b96692d55b5d723435e5283b3ac12d9
parent 1ae7f5d9d8c869ca647936cc8b07316aa1438314
author Pavel <pavel@amd.ucw.cz> Fri, 13 Jun 2008 13:06:32 +0200
committer Pavel <pavel@amd.ucw.cz> Fri, 13 Jun 2008 13:06:32 +0200

 Documentation/kernel-parameters.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e07c432..85c6f57 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -295,7 +295,7 @@ and is between 256 and 4096 characters. 
 			when initialising the APIC and IO-APIC components.
 
 	apm=		[APM] Advanced Power Management
-			See header of arch/i386/kernel/apm.c.
+			See header of arch/x86/kernel/apm_32.c.
 
 	arcrimi=	[HW,NET] ARCnet - "RIM I" (entirely mem-mapped) cards
 			Format: <io>,<irq>,<nodeID>
@@ -638,7 +638,7 @@ and is between 256 and 4096 characters. 
 
 	elanfreq=	[X86-32]
 			See comment before function elanfreq_setup() in
-			arch/i386/kernel/cpu/cpufreq/elanfreq.c.
+			arch/x86/kernel/cpu/cpufreq/elanfreq.c.
 
 	elevator=	[IOSCHED]
 			Format: {"anticipatory" | "cfq" | "deadline" | "noop"}

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
