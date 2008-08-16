Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbYHPXv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbYHPXv2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 19:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYHPXvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 19:51:20 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:14173 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYHPXvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 19:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=edKeQndmSaOSpBesqSLhORggiB/Rr0+bu4IWAeciPlxXScpptfnBEaOuJn9bBtkQ2s
         O7mL8Q+M/R7BO/aMrf8a29y1wj33EFlzC2WYEAk+JZMmT/5DziET70pj2aWialtGHdBZ
         IgULiRMHv3zavBMliRuwwn37zaj+DhBg06UEs=
Date: Sun, 17 Aug 2008 07:51:08 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: rubini@vision.unipv.it
Subject: [DRIVERS/MISC] removed unused #include <version.h>
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080817070816.1625.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
  drivers/misc/eeprom_93cx6.c

This patch removes the said #include <version.h>.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/misc/eeprom_93cx6.c b/drivers/misc/eeprom_93cx6.c
index ea55654..15b1780 100644
--- a/drivers/misc/eeprom_93cx6.c
+++ b/drivers/misc/eeprom_93cx6.c
@@ -26,7 +26,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/delay.h>
 #include <linux/eeprom_93cx6.h>


