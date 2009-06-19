Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbZFSNsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbZFSNsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbZFSNsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:48:32 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:65116 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbZFSNsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:to:cc
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=xXlbbPzS8Vux9YY5k+ul9HCS4XuIyonbKMuTP6TA/Y7DdrvdiDXtdQXn1GNDtakHFA
         NMZtQhZoARKLJupMZbgCoeS8IVCpSlTlx89ooZTYJ3XvwG3+ftvNFMYeJu2ieXu4WXUt
         j41tLmZ5mwzGZvC6VwLL5HWbKLObjhTQhFVng=
From: Florian Fainelli <florian@openwrt.org>
Date: Fri, 19 Jun 2009 15:48:24 +0200
Subject: [PATCH] [x86] rdc321x: select EMBEDDED
MIME-Version: 1.0
X-Length: 1262
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906191548.27101.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RDC321X SoC is used in embedded systems, select
the EMBEDDED configuration symbol to set options
accordingly.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 09f94e4..f9d1a48 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -382,6 +382,7 @@ config X86_RDC321X
 	depends on X86_EXTENDED_PLATFORM
 	select M486
 	select X86_REBOOTFIXUPS
+	select EMBEDDED
 	---help---
 	  This option is needed for RDC R-321x system-on-chip, also known
 	  as R-8610-(G).
