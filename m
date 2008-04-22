Return-Path: <linux-kernel-owner+w=401wt.eu-S1762959AbYDVUZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762959AbYDVUZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762782AbYDVUZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:25:27 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:17185 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762747AbYDVUZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:25:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fRcyMEPy64L7Yo6csrfMsolMRamoKMwhjxsFxql4AtX2WgR280oYtU/TrnrTPPwqFbingueOi0O/iwgMax9kwJBF5Wsw0RJTilfvzD7aAwfD04/PG4d/v4zx2UQ4eoShd4jsLdsOpormGzwbPiRQrhQjdT5a5IQp0QUUzRNVqqA=
Subject: [PATCH] mfd: kconfig exposing unbuildable driver
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 13:25:50 -0700
Message-Id: <1208895950.24124.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit this driver to ARCH_PXA, noticed by breakage on allyesconfig
builds on 32-bit x86.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Linus, please apply and Russell can fix it up however he likes later
in the week.  Many people are hitting this.

 drivers/mfd/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 2566479..bd29c61 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -32,6 +32,7 @@ config HTC_EGPIO
 
 config HTC_PASIC3
 	tristate "HTC PASIC3 LED/DS1WM chip support"
+	depends on ARCH_PXA
 	help
 	  This core driver provides register access for the LED/DS1WM
 	  chips labeled "AIC2" and "AIC3", found on HTC Blueangel and
-- 
1.5.5.144.g3e42



