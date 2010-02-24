Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab0BXW3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:29:42 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:28363 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab0BXW3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:29:40 -0500
Date: Wed, 24 Feb 2010 14:27:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: David Airlie <airlied@linux.ie>
Subject: [PATCH] drm: fix char constant (sparse warning)
Message-Id: <20100224142759.ad4f53ce.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B85A849.01F3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix radeon/atombios.h sparse warning (24 times):

drivers/gpu/drm/radeon/atombios.h:4091:63: error: Bad character constant

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	David Airlie <airlied@linux.ie>
---
 drivers/gpu/drm/radeon/atombios.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.33-rc8.orig/drivers/gpu/drm/radeon/atombios.h
+++ linux-2.6.33-rc8/drivers/gpu/drm/radeon/atombios.h
@@ -4088,7 +4088,7 @@ typedef struct _SW_I2C_IO_DATA_PARAMETER
 #define SW_I2C_CNTL_WRITE1BIT 6
 
 /* ==============================VESA definition Portion=============================== */
-#define VESA_OEM_PRODUCT_REV			            '01.00'
+#define VESA_OEM_PRODUCT_REV			            "01.00"
 #define VESA_MODE_ATTRIBUTE_MODE_SUPPORT	     0xBB	/* refer to VBE spec p.32, no TTY support */
 #define VESA_MODE_WIN_ATTRIBUTE						     7
 #define VESA_WIN_SIZE											     64
