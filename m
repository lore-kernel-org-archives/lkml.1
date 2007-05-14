Return-Path: <linux-kernel-owner+w=401wt.eu-S965153AbXENKl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965153AbXENKl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 06:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbXENKlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 06:41:22 -0400
Received: from mailgw4.ericsson.se ([193.180.251.62]:37513 "EHLO
	mailgw4.ericsson.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540AbXENKlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 06:41:21 -0400
X-Greylist: delayed 1257 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2007 06:41:21 EDT
X-AuditID: c1b4fb3e-af9eebb0000061ca-88-464837e7d0fe 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] ppc: MCC2 missing in MPC8260 device_list
Date: Mon, 14 May 2007 12:20:21 +0200
Message-ID: <3220661B84B5454898BC4296D6BEADCB42AC35@esealmw104.eemea.ericsson.se>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ppc: MCC2 missing in MPC8260 device_list
Thread-Index: AceWEXpnqGNkfITpSOO1Tjm47rZL+A==
From: "Morten Banzon \(HA/ETO\)" <morten.banzon@ericsson.com>
To: <galak@kernel.crashing.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 May 2007 10:20:22.0918 (UTC) FILETIME=[7B374A60:01C79611]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

from: Morten Banzon <morten.banzon@ericsson.com>

Adds the MCC2 device to the 8260 device_list.

signed-off-by: Morten Banzon <morten.banzon@ericsson.com>

---

diff -uprN linux-2.6.21.1.orig/arch/ppc/syslib/pq2_sys.c
linux-2.6.21.1/arch/ppc/syslib/pq2_sys.c
--- linux-2.6.21.1.orig/arch/ppc/syslib/pq2_sys.c	2007-04-27
23:49:26.000000000 +0200
+++ linux-2.6.21.1/arch/ppc/syslib/pq2_sys.c	2007-05-14
10:49:20.000000000 +0200
@@ -52,8 +52,9 @@ struct ppc_sys_spec ppc_sys_specs[] = {
 		{
 			MPC82xx_CPM_FCC1, MPC82xx_CPM_FCC2,
MPC82xx_CPM_FCC3,
 			MPC82xx_CPM_SCC1, MPC82xx_CPM_SCC2,
MPC82xx_CPM_SCC3,
-			MPC82xx_CPM_SCC4, MPC82xx_CPM_MCC1,
MPC82xx_CPM_SMC1,
-			MPC82xx_CPM_SMC2, MPC82xx_CPM_SPI,
MPC82xx_CPM_I2C,
+			MPC82xx_CPM_SCC4, MPC82xx_CPM_MCC1,
MPC82xx_CPM_MCC2,
+			MPC82xx_CPM_SMC1, MPC82xx_CPM_SMC2,
MPC82xx_CPM_SPI,
+			MPC82xx_CPM_I2C,
 		}
 	},
 	{
