Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZJaICc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZJaICc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 04:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbZJaICb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 04:02:31 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:61720 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbZJaICa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 04:02:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=maEwiIicxyQCGW1SOOwX2kCyGfILw4u3gCBpev9yOuk+UUaoc2MjFlCWVZzvs8AITO
         qVMze4DPtefccZ1Y88+qt2pDmHvnfAcr7osu3wT7xEBVymhh+6BokFCq8OgrvRhTIph5
         byzfEZy7es34vOgca3TKRGDFa3CY/vgeYtSOU=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 06:02:15 -0200
Message-ID: <b8bf37780910310102x6ee7bb36ic149e17f81406a1@mail.gmail.com>
Subject: [PATCH] blackfin: fix typo on using CONFIG_BFIN_EXTMEM_WRITETHROUGH 
	kconfig definition
To: vapier@gentoo.org, cooloney@kernel.org, graf.yang@analog.com,
       bernds_cb1@t-online.de, robin.getz@analog.com,
       uclinux-dist-devel@blackfin.uclinux.org,
       linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 32a763924b8735243f8a0accd1d003d5a7dd4bad Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Fri, 30 Oct 2009 05:57:22 -0200
Subject: [PATCH] blackfin: fix typo on using
CONFIG_BFIN_EXTMEM_WRITETHROUGH kconfig definition
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
index f7b9cdc..b52c1f8 100644
--- a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
+++ b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
@@ -38,7 +38,7 @@ void __init generate_cplb_tables_cpu(unsigned int cpu)

 #ifdef CONFIG_BFIN_EXTMEM_DCACHEABLE
 	d_cache = CPLB_L1_CHBL;
-#ifdef CONFIG_BFIN_EXTMEM_WRITETROUGH
+#ifdef CONFIG_BFIN_EXTMEM_WRITETHROUGH
 	d_cache |= CPLB_L1_AOW | CPLB_WT;
 #endif
 #endif
-- 
1.6.5.2.101.gcd0f8
