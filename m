Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbYHNPRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbYHNPRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYHNPRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:17:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47252 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYHNPRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:17:16 -0400
Date: Thu, 14 Aug 2008 17:18:33 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Trivial patch monkey <trivial@kernel.org>
Subject: PM_TRACE is no longer experimental
Message-ID: <20080814151833.GA23300@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PM_TRACE is stable for quite long. I don't think it needs to depend on
experimental.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 710f4e9070c453e743fcfa1a6017075026c4967b
tree 7f3fe656004f2d21b6a9cbe1264f9f2236572456
parent ea977ecb4f994b0dc2e09cab3dbba87aad030d99
author Pavel <pavel@amd.ucw.cz> Thu, 14 Aug 2008 17:18:07 +0200
committer Pavel <pavel@amd.ucw.cz> Thu, 14 Aug 2008 17:18:07 +0200

 kernel/power/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index dcd165f..1800674 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -36,7 +36,7 @@ config PM_VERBOSE
 
 config CAN_PM_TRACE
 	def_bool y
-	depends on PM_DEBUG && PM_SLEEP && EXPERIMENTAL
+	depends on PM_DEBUG && PM_SLEEP
 
 config PM_TRACE
 	bool

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
