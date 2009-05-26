Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbZEZRkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbZEZRkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757084AbZEZRkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:40:15 -0400
Received: from mga06.intel.com ([134.134.136.21]:63367 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756481AbZEZRkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:40:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,253,1241420400"; 
   d="scan'208";a="518993531"
Message-Id: <20090526174225.463013971@linux.intel.com>
References: <20090526174012.423883376@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 26 May 2009 19:40:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 6/6] firmware: FIRMWARE_NAME_MAX removal
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
