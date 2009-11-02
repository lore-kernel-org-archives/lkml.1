Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbZKBVFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbZKBVFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:05:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbZKBVFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:05:03 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:37878 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbZKBVFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:05:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qu1BkcU19/QhUAwKZuk/8DGhwTIQPt1W76ISW7v87XQRHyCOEU4z3tx0GLgkGlnFzH
         litB0FL600Nie4NGNJ9vOnQZwzEOl40bdqrAAAzEMDCjzmafvRKOW9PScsWad1Z31PE8
         dCKq1aOJNuie9IIJOS31yCQpn3UP61KifRKyo=
From: Thiago Farina <tfransosi@gmail.com>
To: trivial@kernel.org
Cc: vapier@gentoo.org, cooloney@kernel.org, michael.hennerich@analog.com,
       barry.song@analog.com, yi.li@analog.com,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH] blackfin/trivial: remove duplicated MAX macro from stamp.
Date: Mon,  2 Nov 2009 16:04:48 -0500
Message-Id: <1257195888-6122-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.5.1.61.ge79999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the kernel api already has the macro "max",
just use it instead of declaring another one.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 arch/blackfin/mach-bf537/boards/stamp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index c46baa5..c76da37 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -385,10 +385,9 @@ static struct platform_nand_data bfin_plat_nand_data = {
 	},
 };
 
-#define MAX(x, y) (x > y ? x : y)
 static struct resource bfin_plat_nand_resources = {
 	.start = 0x20212000,
-	.end   = 0x20212000 + (1 << MAX(BFIN_NAND_PLAT_CLE, BFIN_NAND_PLAT_ALE)),
+	.end   = 0x20212000 + (1 << max(BFIN_NAND_PLAT_CLE, BFIN_NAND_PLAT_ALE)),
 	.flags = IORESOURCE_IO,
 };
 
-- 
1.6.5.1.61.ge79999

