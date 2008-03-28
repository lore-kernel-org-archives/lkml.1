Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbYC1QWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbYC1QWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYC1QWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:22:23 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:27882 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755371AbYC1QWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:22:22 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: linuxppc-dev@xilinx.com, benh@kernel.crashing.org,
       jwboyer@linux.vnet.ibm.com, sfr@canb.auug.org.au,
       grant.likely@secretlab.ca, git-dev@xilinx.com,
       linux-kernel@vger.kernel.org
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: [PATCH 2/5] [POWERPC] Xilinx: Virtex: Enable dcr for MMIO and NATIVE
Date: Fri, 28 Mar 2008 09:20:34 -0700
X-Mailer: git-send-email 1.5.3.4-dirty
In-Reply-To: <1206721237-17982-1-git-send-email-stephen.neuendorffer@xilinx.com>
References: <1206401313-1625-1-git-send-email-stephen.neuendorffer@xilinx.com>
 <1206721237-17982-1-git-send-email-stephen.neuendorffer@xilinx.com>
Message-Id: <20080328162218.4E64CD60003@mail123-dub.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FPGA designs may have need of both MMIO-based and NATIVE-based dcr
interfaces.

Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
---
 arch/powerpc/platforms/40x/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
index a9260e2..b8e06df 100644
--- a/arch/powerpc/platforms/40x/Kconfig
+++ b/arch/powerpc/platforms/40x/Kconfig
@@ -123,6 +123,8 @@ config 405GPR
 
 config XILINX_VIRTEX
 	bool
+	select PPC_DCR_MMIO
+	select PPC_DCR_NATIVE
 
 config XILINX_VIRTEX_II_PRO
 	bool
-- 
1.5.3.4-dirty


