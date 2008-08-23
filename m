Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbYHWF4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbYHWF4v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 01:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYHWF40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 01:56:26 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:59891 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbYHWF4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 01:56:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=ObAYcwGeOMaldcbPOHwYTYfTvGvuW1O/a5VAqKLLIN29hQInVbnnyVHy8kvgb3GIfI
         /MLCNw873xRnNicAXIm4dK5fNmuPhOh5/GN1N6vissidn1+BOam0xXUsrxhgC3uZcqu/
         WBpCO3mVPFR1U/KJV0IFvI/026ve9IwxL1LPY=
Date: Sat, 23 Aug 2008 13:56:23 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: sameo@openedhand.com
Subject: mfd: remove unused #include <version.h>
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080823132603.1283.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver(s) below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
  drivers/mfd/asic3.c

This patch removes the said #include <version.h>.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index c6408a6..bc2a807 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -16,7 +16,6 @@
  *
  */

-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>

