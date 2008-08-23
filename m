Return-Path: <linux-kernel-owner+w=401wt.eu-S1752273AbYHWF4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbYHWF4g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 01:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYHWF4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 01:56:12 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:59891 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbYHWF4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 01:56:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=lrqu4U+7eu6EIiDq4FUtx8ojjsgcJRx82rKghpLmQozUiAursN3y3jnRLM+cCedN0I
         nm+GpdDysa8szKYg4alUYMP77K+TtxLxan2fW8qF+YIgEtrmbMzuHv7HvSsu+KrOaIWB
         44jqc1zk7fUVWUhf8/3DI7hlJ4UGv8blJ/TGo=
Date: Sat, 23 Aug 2008 13:56:09 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: florian.fainelli@telecomint.eu
Subject: rdc321x: remove unused #include <version.h>
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080823130903.126E.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file(s) below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
  arch/x86/mach-rdc321x/platform.c

This patch removes the said #include <version.h>.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/arch/x86/mach-rdc321x/platform.c b/arch/x86/mach-rdc321x/platform.c
index a037041..4f4e50c 100644
--- a/arch/x86/mach-rdc321x/platform.c
+++ b/arch/x86/mach-rdc321x/platform.c
@@ -25,7 +25,6 @@
 #include <linux/list.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
-#include <linux/version.h>
 #include <linux/leds.h>

 #include <asm/gpio.h>

