Return-Path: <linux-kernel-owner+w=401wt.eu-S1761463AbXJYUFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463AbXJYUFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757161AbXJYUEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:04:53 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45923 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769AbXJYUEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:04:52 -0400
Date: Thu, 25 Oct 2007 22:06:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [PATCH 6/6] x86: kill the old i386 and x86_64 directories
Message-ID: <20071025200627.GG14501@uranus.ravnborg.org>
References: <20071025195644.GA14501@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025195644.GA14501@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From c54efdb8c66e1850be60e2320a24c96957c87372 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 25 Oct 2007 21:06:56 +0200
Subject: [PATCH] x86: kill the old i386 and x86_64 directories

The last remaining bits were two .gitignore files.
Deleting them and we have no more use of the directories.

git will most likely not delete the directories for
you, so this is a thing to do manually (or create a fresh clone).

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/i386/.gitignore   |    1 -
 arch/x86_64/.gitignore |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)
 delete mode 100644 arch/i386/.gitignore
 delete mode 100644 arch/x86_64/.gitignore

diff --git a/arch/i386/.gitignore b/arch/i386/.gitignore
deleted file mode 100644
index 36ef4c3..0000000
--- a/arch/i386/.gitignore
+++ /dev/null
@@ -1 +0,0 @@
-boot
diff --git a/arch/x86_64/.gitignore b/arch/x86_64/.gitignore
deleted file mode 100644
index 36ef4c3..0000000
--- a/arch/x86_64/.gitignore
+++ /dev/null
@@ -1 +0,0 @@
-boot
-- 
1.5.3.4.1157.g0e74-dirty

