Return-Path: <linux-kernel-owner+w=401wt.eu-S1762388AbXJXQez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762388AbXJXQez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759530AbXJXQYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:24:10 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33395 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759510AbXJXQYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:24:09 -0400
Date: Wed, 24 Oct 2007 18:24:37 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] feature-removal-schedule: remove SA_* flags entry
Message-ID: <20071024162437.GM30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No reason to keep the feature-removal-schedule.txt entry after the code
was removed.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/feature-removal-schedule.txt |    9 ---------
 1 file changed, 9 deletions(-)

ecf4ac4330ec61cecb1665c8c39702e600633b80 
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 6b0f963..b9b8269 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -191,15 +191,6 @@ Who:	Nick Piggin <npiggin@suse.de>
 
 ---------------------------
 
-What:	Interrupt only SA_* flags
-When:	September 2007
-Why:	The interrupt related SA_* flags are replaced by IRQF_* to move them
-	out of the signal namespace.
-
-Who:	Thomas Gleixner <tglx@linutronix.de>
-
----------------------------
-
 What:	PHYSDEVPATH, PHYSDEVBUS, PHYSDEVDRIVER in the uevent environment
 When:	October 2008
 Why:	The stacking of class devices makes these values misleading and

