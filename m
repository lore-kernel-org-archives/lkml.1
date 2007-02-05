Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbXBENot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbXBENot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 08:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932518AbXBENot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 08:44:49 -0500
Received: from ns2.gothnet.se ([82.193.160.251]:2198 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932432AbXBENos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 08:44:48 -0500
From: thomas@tungstengraphics.com
To: davej@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Thomas Hellstrom <thomas@tungstengraphics.com>
Subject: [PATCH] [AGPGART] Add agp-type-to-mask-type method missing from some drivers.
Reply-To: thomas@tungstengraphics.com
Date: Mon, 05 Feb 2007 14:44:23 +0100
Message-Id: <1170683063550-git-send-email-thomas@tungstengraphics.com>
X-Mailer: git-send-email 1.4.1
In-Reply-To: <20070205133410.GA4121@redhat.com>
References: <20070205133410.GA4121@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Hellstrom <thomas@tungstengraphics.com>

diff --git a/drivers/char/agp/parisc-agp.c b/drivers/char/agp/parisc-agp.c
index 17c50b0..b7b4590 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -228,6 +228,7 @@ struct agp_bridge_driver parisc_agp_driv
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.cant_use_aperture	= 1,
 };
 
diff --git a/drivers/char/agp/sis-agp.c b/drivers/char/agp/sis-agp.c
index a00fd48..60342b7 100644
--- a/drivers/char/agp/sis-agp.c
+++ b/drivers/char/agp/sis-agp.c
@@ -140,6 +140,7 @@ static struct agp_bridge_driver sis_driv
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
 static struct agp_device_ids sis_agp_device_ids[] __devinitdata =
-- 
1.4.1


