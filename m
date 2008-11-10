Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbYKJWbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbYKJWbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYKJWam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:30:42 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:48785 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbYKJWal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:30:41 -0500
From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 1/7] PCI, ACPI: include missing acpi.h file in pci-acpi.h.
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: andrew.patterson@hp.com, matthew@wil.cx, kaneshige.kenji@jp.fujitsu.com,
       bjorn.helgaas@hp.com
Date: Mon, 10 Nov 2008 15:30:40 -0700
Message-ID: <20081110223040.30539.93209.stgit@bob.kio>
In-Reply-To: <20081110223035.30539.88942.stgit@bob.kio>
References: <20081110223035.30539.88942.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI, ACPI: include missing acpi.h file in pci-acpi.h.

The pci-acpi.h file will not compile without including linux/acpi.h.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---

diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
index 8837928..a9e4c34 100644
--- a/include/linux/pci-acpi.h
+++ b/include/linux/pci-acpi.h
@@ -8,6 +8,8 @@
 #ifndef _PCI_ACPI_H_
 #define _PCI_ACPI_H_
 
+#include <linux/acpi.h>
+
 #define OSC_QUERY_TYPE			0
 #define OSC_SUPPORT_TYPE 		1
 #define OSC_CONTROL_TYPE		2

