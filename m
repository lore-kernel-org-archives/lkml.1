Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZA1XcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZA1XcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZA1X2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:28:18 -0500
Received: from kroah.org ([198.145.64.141]:56997 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756956AbZA1X2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:28:17 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/10] staging: agnx: drivers/staging/agnx/agnx.h needs <linux/io.h>
Date: Wed, 28 Jan 2009 15:26:48 -0800
Message-Id: <1233185210-23098-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090128232319.GA23009@kroah.com>
References: <20090128232319.GA23009@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

On m68k:
drivers/staging/agnx/agnx.h: In function 'agnx_read32':
drivers/staging/agnx/agnx.h:10: error: implicit declaration of function 'ioread32'
drivers/staging/agnx/agnx.h: In function 'agnx_write32':
drivers/staging/agnx/agnx.h:15: error: implicit declaration of function 'iowrite32'
drivers/staging/agnx/sta.c: In function 'get_sta_power':
drivers/staging/agnx/sta.c:94: error: implicit declaration of function 'memcpy_fromio'
drivers/staging/agnx/sta.c: In function 'set_sta_power':
drivers/staging/agnx/sta.c:103: error: implicit declaration of function 'memcpy_toio'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/agnx/agnx.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/agnx/agnx.h b/drivers/staging/agnx/agnx.h
index a75b0db..20f36da 100644
--- a/drivers/staging/agnx/agnx.h
+++ b/drivers/staging/agnx/agnx.h
@@ -1,6 +1,8 @@
 #ifndef AGNX_H_
 #define AGNX_H_
 
+#include <linux/io.h>
+
 #include "xmit.h"
 
 #define PFX				KBUILD_MODNAME ": "
-- 
1.6.0.2

