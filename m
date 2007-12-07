Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbXLGNgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbXLGNgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 08:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXLGNgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 08:36:31 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:56799 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbXLGNga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 08:36:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=w7GeKonzDjzelXk3e+lDOIlcnXLfLa8jX4jw5eoYRR7hrxjoymnM87u0Ols/O7ygJWwDTnjHK2Gbu4GeNFiBd8vQAc3jvpVE5LnqRJNIKDroOJD4ulyaoS2lbmraXVwEf9HRP6HkWhpQEveXK0HygOVzsikXc0JztBuIx3eDfYE=
Message-ID: <47594C57.4070006@gmail.com>
Date: Fri, 07 Dec 2007 22:36:23 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] SCSI: make pcmcia directory use obj-y|m instead of subdir-y|m
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

subdir-y|m isn't supposed to contain modules or built-in components.
Change subdir-$(CONFIG_PCMCIA) to obj-$(CONFIG_PCMCIA).

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 2e6129f..72c8d2e 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -18,7 +18,7 @@ CFLAGS_aha152x.o =   -DAHA152X_STAT -DAUTOCONF
 CFLAGS_gdth.o    = # -DDEBUG_GDTH=2 -D__SERIAL__ -D__COM2__ -DGDTH_STATISTICS
 CFLAGS_seagate.o =   -DARBITRATE -DPARITY -DSEAGATE_USE_ASM
 
-subdir-$(CONFIG_PCMCIA)		+= pcmcia
+obj-$(CONFIG_PCMCIA)		+= pcmcia/
 
 obj-$(CONFIG_SCSI)		+= scsi_mod.o
 obj-$(CONFIG_SCSI_TGT)		+= scsi_tgt.o
