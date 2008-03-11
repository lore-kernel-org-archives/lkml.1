Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYCKJMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYCKJMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYCKJKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:10:19 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:61075 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbYCKJKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:10:16 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, akpm@linux-foundation.org,
       galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 08/17] Add RapidIO node probing into MPC86xx_HPCN board id table.
Date: Tue, 11 Mar 2008 17:07:49 +0800
Message-Id: <1205226478-7641-8-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1205226478-7641-7-git-send-email-wei.zhang@freescale.com>
References: <1205226478-7641-1-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-2-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-3-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-4-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-5-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-6-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-7-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 11 Mar 2008 09:10:01.0321 (UTC) FILETIME=[AFB33590:01C88357]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
index cfbe8c5..4a3e421 100644
--- a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
+++ b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
@@ -215,6 +215,7 @@ mpc86xx_time_init(void)
 
 static __initdata struct of_device_id of_bus_ids[] = {
 	{ .compatible = "simple-bus", },
+	{ .compatible = "fsl,rapidio-delta", },
 	{},
 };
 
-- 
1.5.4

