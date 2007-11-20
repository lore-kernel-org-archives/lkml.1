Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbXKTBtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbXKTBtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbXKTBsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:48:53 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2038 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255AbXKTBsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:48:51 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH 02/59] arch/mips: Add missing "space"
Date: Mon, 19 Nov 2007 17:47:54 -0800
Message-Id: <1195523331-15303-3-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-2-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
Message-Id: <23f0badf8dab73294c2aa142fafb9301ca843e88.1195454434.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/mips/kernel/vpe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index 38bd33f..c06eb81 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -470,7 +470,7 @@ static int apply_r_mips_lo16(struct module *me, uint32_t *location,
 			 */
  			if (v != l->value) {
 				printk(KERN_DEBUG "VPE loader: "
-				       "apply_r_mips_lo16/hi16: 	"
+				       "apply_r_mips_lo16/hi16: \t"
 				       "inconsistent value information\n");
 				return -ENOEXEC;
 			}
@@ -629,7 +629,7 @@ static void simplify_symbols(Elf_Shdr * sechdrs,
 			break;
 
 		case SHN_MIPS_SCOMMON:
-			printk(KERN_DEBUG "simplify_symbols: ignoring SHN_MIPS_SCOMMON"
+			printk(KERN_DEBUG "simplify_symbols: ignoring SHN_MIPS_SCOMMON "
 			       "symbol <%s> st_shndx %d\n", strtab + sym[i].st_name,
 			       sym[i].st_shndx);
 			// .sbss section
-- 
1.5.3.5.652.gf192c

