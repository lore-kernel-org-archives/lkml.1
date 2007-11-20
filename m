Return-Path: <linux-kernel-owner+w=401wt.eu-S1761484AbXKTCIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484AbXKTCIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758603AbXKTBx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:53:56 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2201 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758293AbXKTBxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:53:51 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 48/59] fs/proc: Add missing "space"
Date: Mon, 19 Nov 2007 17:53:35 -0800
Message-Id: <1195523627-15389-6-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523627-15389-5-git-send-email-joe@perches.com>
References: 1234567
 <1195523627-15389-1-git-send-email-joe@perches.com>
 <1195523627-15389-2-git-send-email-joe@perches.com>
 <1195523627-15389-3-git-send-email-joe@perches.com>
 <1195523627-15389-4-git-send-email-joe@perches.com>
 <1195523627-15389-5-git-send-email-joe@perches.com>
Message-Id: <9668a3b988be3ea263473a390e297005695807ba.1195454436.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/proc/vmcore.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 523e109..7c7b3ed 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -521,7 +521,7 @@ static int __init parse_crash_elf64_headers(void)
 		ehdr.e_ehsize != sizeof(Elf64_Ehdr) ||
 		ehdr.e_phentsize != sizeof(Elf64_Phdr) ||
 		ehdr.e_phnum == 0) {
-		printk(KERN_WARNING "Warning: Core image elf header is not"
+		printk(KERN_WARNING "Warning: Core image elf header is not "
 					"sane\n");
 		return -EINVAL;
 	}
@@ -577,7 +577,7 @@ static int __init parse_crash_elf32_headers(void)
 		ehdr.e_ehsize != sizeof(Elf32_Ehdr) ||
 		ehdr.e_phentsize != sizeof(Elf32_Phdr) ||
 		ehdr.e_phnum == 0) {
-		printk(KERN_WARNING "Warning: Core image elf header is not"
+		printk(KERN_WARNING "Warning: Core image elf header is not "
 					"sane\n");
 		return -EINVAL;
 	}
@@ -621,8 +621,8 @@ static int __init parse_crash_elf_headers(void)
 	if (rc < 0)
 		return rc;
 	if (memcmp(e_ident, ELFMAG, SELFMAG) != 0) {
-		printk(KERN_WARNING "Warning: Core image elf header"
-					" not found\n");
+		printk(KERN_WARNING "Warning: Core image elf header "
+					"not found\n");
 		return -EINVAL;
 	}
 
@@ -641,8 +641,8 @@ static int __init parse_crash_elf_headers(void)
 		/* Determine vmcore size. */
 		vmcore_size = get_vmcore_size_elf32(elfcorebuf);
 	} else {
-		printk(KERN_WARNING "Warning: Core image elf header is not"
-					" sane\n");
+		printk(KERN_WARNING "Warning: Core image elf header is not "
+					"sane\n");
 		return -EINVAL;
 	}
 	return 0;
-- 
1.5.3.5.652.gf192c

