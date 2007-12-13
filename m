Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbXLMIbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbXLMIbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 03:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbXLMIbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 03:31:37 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:28926
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753525AbXLMIbg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 03:31:36 -0500
Message-Id: <4760FC2A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 08:32:26 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <len.brown@intel.com>
Cc: "linux-acpi" <linux-acpi@intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] acpi: fix modpost warnings
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 drivers/acpi/numa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.24-rc5/drivers/acpi/numa.c	2007-10-09 22:31:38.000000000 +0200
+++ 2.6.24-rc5-acpi-init-warning/drivers/acpi/numa.c	2007-12-04 16:09:33.000000000 +0100
@@ -38,9 +38,9 @@ ACPI_MODULE_NAME("numa");
 static nodemask_t nodes_found_map = NODE_MASK_NONE;
 
 /* maps to convert between proximity domain and logical node ID */
-static int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS]
+static int pxm_to_node_map[MAX_PXM_DOMAINS]
 				= { [0 ... MAX_PXM_DOMAINS - 1] = NID_INVAL };
-static int __cpuinitdata node_to_pxm_map[MAX_NUMNODES]
+static int node_to_pxm_map[MAX_NUMNODES]
 				= { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
 
 int pxm_to_node(int pxm)



