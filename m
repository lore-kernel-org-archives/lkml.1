Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYASVFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYASVFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 16:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYASVE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 16:04:58 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:56353 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYASVE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 16:04:57 -0500
Date: Sat, 19 Jan 2008 16:04:42 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: [PATCH 1/1] arch: Ignore arch/i386 and arch/x86_64
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Message-id: <1200776682-23740-1-git-send-email-jeffpc@josefsipek.net>
X-Mailer: git-send-email 1.5.4.rc2.85.g9de45-dirty
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i386 and x86_64 arch directories contain nothing but a generated symlink
to arch/x86/boot/bzImage when a tree a built.

Cc: tglx@linutronix.de
Cc: mingo@redhat.com
Cc: hpa@zytor.com
Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
---
 arch/.gitignore |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
 create mode 100644 arch/.gitignore

diff --git a/arch/.gitignore b/arch/.gitignore
new file mode 100644
index 0000000..7414689
--- /dev/null
+++ b/arch/.gitignore
@@ -0,0 +1,2 @@
+i386
+x86_64
-- 
1.5.4.rc2.85.g9de45-dirty

