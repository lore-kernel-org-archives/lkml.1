Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbYE0Kpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbYE0Kpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 06:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756338AbYE0Kp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 06:45:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43482 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268AbYE0Kp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 06:45:26 -0400
Date: Tue, 27 May 2008 12:46:13 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Trivial patch monkey <trivial@kernel.org>
Subject: [patch] hint users about no_console_suspend option
Message-ID: <20080527104613.GA13026@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hint user about no_console_suspend option, so that we don't have to
tell each bug reporter personally.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 017834f8541b8ded8ef831e5fe2b5f9cead4f6b0
tree 80c244e45acfbd1c1e8883f12021683f15356c4e
parent cc8201de538dda6c17e03fe495146e7fc755f64d
author Pavel <pavel@amd.ucw.cz> Tue, 27 May 2008 12:45:26 +0200
committer Pavel <pavel@amd.ucw.cz> Tue, 27 May 2008 12:45:26 +0200

 kernel/printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 8fb01c3..6e04669 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -950,7 +950,7 @@ void suspend_console(void)
 {
 	if (!console_suspend_enabled)
 		return;
-	printk("Suspending console(s)\n");
+	printk("Suspending console(s) (no_console_suspend to debug?)\n");
 	acquire_console_sem();
 	console_suspended = 1;
 }

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
