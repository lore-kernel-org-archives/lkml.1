Return-Path: <linux-kernel-owner+w=401wt.eu-S937808AbXHHSL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937808AbXHHSL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937461AbXHHSLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:11:17 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:54936 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765018AbXHHSLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:11:16 -0400
Date: Wed, 8 Aug 2007 20:11:28 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] remove consolemap.h from header exports
Message-ID: <20070808181128.GA3954@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove linux/consolemap.h from make headers_install

It contains no userinterfaces.
The defines in this file are used only for kernel internal state.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 include/linux/Kbuild |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -45,7 +45,6 @@ header-y += chio.h
 header-y += coda_psdev.h
 header-y += coff.h
 header-y += comstats.h
-header-y += consolemap.h
 header-y += const.h
 header-y += cycx_cfm.h
 header-y += dlm_device.h
