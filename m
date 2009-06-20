Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbZFTU4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbZFTU4w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 16:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZFTU4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 16:56:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59606 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbZFTU4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 16:56:43 -0400
Message-Id: <200906202056.n5KKuc9o013960@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 20 Jun 2009 13:52:35 -0700
Subject: [PATCH] gitignore: add *.bz2 and *.cpio to top-level; clean up usr/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add *.bz2 and *.cpio to the top-level gitignore file, for consistency
with *.gz and *.lzma which are already there.  Remove specific rules
in usr/gitignore, since they are now covered by the global rules.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 .gitignore     |    2 ++
 usr/.gitignore |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/.gitignore b/.gitignore
index cecb3b0..a909275 100644
--- a/.gitignore
+++ b/.gitignore
@@ -24,6 +24,8 @@
 *.order
 *.elf
 *.bin
+*.cpio
+*.bz2
 *.gz
 *.lzma
 *.patch
diff --git a/usr/.gitignore b/usr/.gitignore
index 69b2e89..4d7d9f4 100644
--- a/usr/.gitignore
+++ b/usr/.gitignore
@@ -2,7 +2,5 @@
 # Generated files
 #
 gen_init_cpio
-initramfs_data.cpio
-initramfs_data.cpio.gz
 initramfs_list
 include
-- 
1.6.0.6

