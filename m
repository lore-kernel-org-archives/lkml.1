Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357Ab0ARVTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0ARVTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320Ab0ARVS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:18:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:19462 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab0ARVS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:18:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,298,1262592000"; 
   d="scan'208";a="484964372"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH] Add reference to memrar.h file
Date: Mon, 18 Jan 2010 13:22:39 -0800
Message-Id: <1263849759-23125-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to add raference to memrar.h

This is the third of seven patches for the rar_register driver
for Sunday, January 17, 2009

The rar stands for restricted access region. The restricted access
region is an area of memory that can be locked from access by the
x86 processor.

The purpose of the restricted access region is to safeguard confidential
information from any unauthorized software running on the x86 processor.

The purpose of this driver is to enable other drivers to obtain
the address ranges of the restricted regions as well as lock them.

This patch is referenced off the linux-next repository as pulled
on Sunday, January 17th, 2010

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>

Date: January 17, 2010
---
 drivers/staging/rar/rar_register.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rar/rar_register.c b/drivers/staging/rar/rar_register.c
index 836d383..4b9a3a3 100644
--- a/drivers/staging/rar/rar_register.c
+++ b/drivers/staging/rar/rar_register.c
@@ -16,6 +16,7 @@
 #include <linux/firmware.h>
 #include <linux/sched.h>
 #include <linux/rar/rar_register.h>
+#include <linux/rar/memrar.h>
 
 /* The following defines are for the IPC process to retrieve RAR in */
 
-- 
1.6.0.6

