Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbYGGWDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbYGGWDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbYGGWBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:01:11 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:9235 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758689AbYGGWAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=eeOjdeNf2wEgORdKlCK4qnXimRdJhX/vZvlDkTO1dkTpjA/cbV7GSKRc3DTyyiitcT
         w0KpINVRraWclWnmaI2ttCgawwAbnCRXUjHXAo8o4KW6NHM0PToDuZQsYYLFgOCGq7Xv
         g0iGiP9obVe+rBD+bkC+9dXOHWPuRzHS9EkPU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 8/10] ide-generic: is no longer needed on ppc32
Date: Mon, 7 Jul 2008 23:56:25 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072356.25250.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
this patch depends on arch/ppc/ removal (already in linux-next)

 drivers/ide/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -314,7 +314,7 @@ comment "IDE chipset support/bugfixes"
 
 config IDE_GENERIC
 	tristate "generic/default IDE chipset support"
-	depends on ALPHA || X86 || IA64 || M32R || MIPS || PPC32
+	depends on ALPHA || X86 || IA64 || M32R || MIPS
 	help
 	  If unsure, say N.
 
