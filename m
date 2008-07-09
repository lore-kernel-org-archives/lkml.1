Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbYGIKt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbYGIKt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 06:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYGIKth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 06:49:37 -0400
Received: from hull.simtec.co.uk ([78.105.113.97]:42484 "EHLO
	ivanova.local.simtec.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752078AbYGIKtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 06:49:36 -0400
Message-Id: <20080709104932.905074060@fluff.org>
References: <20080709104916.200210922@fluff.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 11:49:19 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Cc: sameo@openedhand.com, dbaryshkov@gmail.com,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 3/4] MFD: Remove unnecessary fields if mfd_cell structure.
Content-Disposition: inline; filename=mfd-remove-silly-entries.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The enable,disable,suspend and resume entry in the struct mfd_cell
do not seem to be necessary as they should be handled by the
platform driver that the device created has bound to.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h
===================================================================
--- linux-2.6.26-rc9-next20080709.orig/include/linux/mfd/core.h	2008-07-09 10:44:45.000000000 +0100
+++ linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h	2008-07-09 10:45:06.000000000 +0100
@@ -23,12 +26,6 @@
  */
 struct mfd_cell {
 	const char		*name;
-
-	int			(*enable)(struct platform_device *dev);
-	int			(*disable)(struct platform_device *dev);
-	int			(*suspend)(struct platform_device *dev);
-	int			(*resume)(struct platform_device *dev);
-
 	void			*driver_data; /* driver-specific data */
 
 	/*

-- 
