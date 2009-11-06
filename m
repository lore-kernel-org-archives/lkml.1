Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZKFDOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZKFDOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 22:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZKFDOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 22:14:16 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:41476 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbZKFDOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 22:14:15 -0500
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Cc: <vapier@gentoo.org>, "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       <linux-kernel@vger.kernel.org>, "Song, Barry" <Barry.Song@analog.com>,
       <uclinux-dist-devel@blackfin.uclinux.org>
X-IronPort-AV: E=Sophos;i="4.44,689,1249272000"; 
   d="scan'208";a="6964752"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Uclinux-dist-devel] [PATCH] blackfin/trivial: remove duplicatedMAX macro from stamp.
Date: Fri, 6 Nov 2009 11:17:38 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA05042B1D@chinexm1.ad.analog.com>
In-Reply-To: <1257195888-6122-1-git-send-email-tfransosi@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Uclinux-dist-devel] [PATCH] blackfin/trivial: remove duplicatedMAX macro from stamp.
Thread-Index: AcpchouvFMK/Gq9NSKSz2qhH7pe31gCCF7dQ
References: <1257195888-6122-1-git-send-email-tfransosi@gmail.com>
To: "Thiago Farina" <tfransosi@gmail.com>, <trivial@kernel.org>
X-OriginalArrivalTime: 06 Nov 2009 03:14:15.0714 (UTC) FILETIME=[38A4D020:01CA5E8F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Sonic Zhang<sonic.zhang@analog.com>

-----Original Message-----
From: uclinux-dist-devel-bounces@blackfin.uclinux.org
[mailto:uclinux-dist-devel-bounces@blackfin.uclinux.org] On Behalf Of
Thiago Farina
Sent: Tuesday, November 03, 2009 5:05 AM
To: trivial@kernel.org
Cc: vapier@gentoo.org; Hennerich, Michael; linux-kernel@vger.kernel.org;
Song, Barry; uclinux-dist-devel@blackfin.uclinux.org; Thiago Farina
Subject: [Uclinux-dist-devel] [PATCH] blackfin/trivial: remove
duplicatedMAX macro from stamp.

Since the kernel api already has the macro "max", just use it instead of
declaring another one.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 arch/blackfin/mach-bf537/boards/stamp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c
b/arch/blackfin/mach-bf537/boards/stamp.c
index c46baa5..c76da37 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -385,10 +385,9 @@ static struct platform_nand_data
bfin_plat_nand_data = {
 	},
 };
 
-#define MAX(x, y) (x > y ? x : y)
 static struct resource bfin_plat_nand_resources = {
 	.start = 0x20212000,
-	.end   = 0x20212000 + (1 << MAX(BFIN_NAND_PLAT_CLE,
BFIN_NAND_PLAT_ALE)),
+	.end   = 0x20212000 + (1 << max(BFIN_NAND_PLAT_CLE,
BFIN_NAND_PLAT_ALE)),
 	.flags = IORESOURCE_IO,
 };
 
--
1.6.5.1.61.ge79999

_______________________________________________
Uclinux-dist-devel mailing list
Uclinux-dist-devel@blackfin.uclinux.org
https://blackfin.uclinux.org/mailman/listinfo/uclinux-dist-devel
