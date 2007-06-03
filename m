Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbXFCOjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbXFCOjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbXFCOjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:39:10 -0400
Received: from web50106.mail.re2.yahoo.com ([206.190.38.34]:40097 "HELO
	web50106.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752655AbXFCOjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:39:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=5MY0ENFC/P1z4bp9A9lmHK3UYYW0XAQEJYkdV/C7t5iTs5n9GtnTlJr0AKRApAEcYX48uX/PhcznKgqiW5XoxecQ76GCpC3c0dIAA9F2X55uBZ95DZ8tTCEDytOSUZI/NNK/HrtSSrm1TDieuTmqLtR4qjrEplXXv5TptqIuhfs=;
X-YMail-OSG: FPkz5YAVM1lyp4S24edKa15KbYeLJFqaPTP5GsrPj59.yTVVRCygcFZsjL35HajbhrWPVA--
Date: Sun, 3 Jun 2007 07:39:06 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 1/36] drivers edac remove depends on X86
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <123360.2742.qm@web50106.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

Remove the 'depends on x86' as EDAC runs on other ARCHs now.

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
---

 Kconfig |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6.22-rc3-mm1/drivers/edac/Kconfig
===================================================================
--- linux-2.6.22-rc3-mm1.orig/drivers/edac/Kconfig
+++ linux-2.6.22-rc3-mm1/drivers/edac/Kconfig
@@ -3,13 +3,11 @@
 #	Copyright (c) 2003 Linux Networx
 #	Licensed and distributed under the GPL
 #
-# $Id: Kconfig,v 1.4.2.7 2005/07/08 22:05:38 dsp_llnl Exp $
-#
 
 menuconfig EDAC
-	tristate "EDAC - error detection and reporting (EXPERIMENTAL)"
+	bool "EDAC - error detection and reporting (EXPERIMENTAL)"
 	depends on HAS_IOMEM
-	depends on X86 && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  EDAC is designed to report errors in the core system.
 	  These are low-level errors that are reported in the CPU or

