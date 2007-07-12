Return-Path: <linux-kernel-owner+w=401wt.eu-S1764191AbXGLKUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764191AbXGLKUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 06:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759180AbXGLKUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 06:20:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:3584 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbXGLKUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 06:20:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,532,1175497200"; 
   d="scan'208";a="105484649"
Subject: [PATCH] ACPI: update ACPI_PROCFS removal schedule
From: rzhang1 <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org
Content-Type: text/plain
Date: Thu, 12 Jul 2007 18:20:34 +0800
Message-Id: <1184235634.6286.2.camel@rzhang1-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jul 2007 10:20:41.0738 (UTC) FILETIME=[4CCE3EA0:01C7C46E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

ACPI sysfs conversion is not finished yet and
some user space tools still depend on the ACPI procfs I/F.

The ACPI_PROCFS removal schedule is changed to Jan 08.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 Documentation/feature-removal-schedule.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/Documentation/feature-removal-schedule.txt
===================================================================
--- linux-2.6.22.orig/Documentation/feature-removal-schedule.txt	2007-07-12 17:50:46.000000000 +0800
+++ linux-2.6.22/Documentation/feature-removal-schedule.txt	2007-07-12 18:03:31.000000000 +0800
@@ -243,7 +243,7 @@
 ---------------------------
 
 What:	ACPI procfs interface
-When:	July 2007
+When:	January 2008
 Why:	After ACPI sysfs conversion, ACPI attributes will be duplicated
 	in sysfs and the ACPI procfs interface should be removed.
 Who:	Zhang Rui <rui.zhang@intel.com>
