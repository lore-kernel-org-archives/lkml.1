Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0BOCds (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 21:33:48 -0500
Received: from sh.osrg.net ([192.16.179.4]:43337 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab0BOCdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 21:33:47 -0500
Date: Mon, 15 Feb 2010 11:33:04 +0900
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] x86/Gart: unexport gart_iommu_aperture
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100215113241P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 15 Feb 2010 11:33:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrongly exported gart_iommu_aperture in the commit
42590a75019a50012f25a962246498dead428433. It's not necessary so
let's unexport it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/aperture_64.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index f147a95..3704997 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -31,7 +31,6 @@
 #include <asm/x86_init.h>
 
 int gart_iommu_aperture;
-EXPORT_SYMBOL_GPL(gart_iommu_aperture);
 int gart_iommu_aperture_disabled __initdata;
 int gart_iommu_aperture_allowed __initdata;
 
-- 
1.5.6.5

