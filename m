Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbYIYAl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbYIYAl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 20:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYIYAlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 20:41:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbYIYAlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 20:41:16 -0400
Date: Wed, 24 Sep 2008 20:40:34 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] pci: document the pcie_aspm kernel parameter
Message-ID: <20080924204034.6eee51ae@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <cebbert@redhat.com>

pci: document the pcie_aspm kernel parameter

Index: linux-2.6.26.noarch/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.26.noarch.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.26.noarch/Documentation/kernel-parameters.txt
@@ -1636,6 +1636,12 @@ and is between 256 and 4096 characters. 
 				reserved for the CardBus bridge's memory
 				window. The default value is 64 megabytes.
 
+	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
+			Management.
+		off	Disable ASPM.
+		force	Enable ASPM even on devices that claim not to support it.
+			WARNING: Forcing ASPM on may cause system lockups.
+
 	pcmv=		[HW,PCMCIA] BadgePAD 4
 
 	pd.		[PARIDE]
