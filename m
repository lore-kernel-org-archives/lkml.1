Return-Path: <linux-kernel-owner+w=401wt.eu-S1760672AbZEZWvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672AbZEZWvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760300AbZEZWtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:49:52 -0400
Received: from mga07.intel.com ([143.182.124.22]:59754 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760293AbZEZWtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:49:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,254,1241420400"; 
   d="scan'208";a="147191969"
Message-Id: <20090526225202.824460684@linux.intel.com>
References: <20090526224930.145059254@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 00:49:37 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: inux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 7/7 v2] firmware: FIRMWARE_NAME_MAX removal
Content-Disposition: inline; filename=firmware-no_max.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

As we're allocating the firmware name dynamically, we no longer need this
definition.
This patch must be applied only after the 5 previous patches from this pacth
set have been applied.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

---
 include/linux/firmware.h |    1 -
 1 file changed, 1 deletion(-)

Index: iwm-2.6/include/linux/firmware.h
===================================================================
--- iwm-2.6.orig/include/linux/firmware.h	2009-05-26 17:44:30.000000000 +0200
+++ iwm-2.6/include/linux/firmware.h	2009-05-26 17:44:34.000000000 +0200
@@ -5,7 +5,6 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 
-#define FIRMWARE_NAME_MAX 30 
 #define FW_ACTION_NOHOTPLUG 0
 #define FW_ACTION_HOTPLUG 1
 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
