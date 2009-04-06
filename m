Return-Path: <linux-kernel-owner+w=401wt.eu-S1759041AbZDFPoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbZDFPoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758755AbZDFPkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:40:06 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:39635 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758888AbZDFPkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:40:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=r0Hjb+mnX8cZyFrONPNZvLsD+JDAQPC//czpMbDEsEsyeTBlgPzUgl3Ts6YTmuAQsw
         aSw83wR2eNwrc0hZDTZRW/7iwksR0lmm0QupCo83jRUMXThG+nHW4CWCDI8C2PTbAGx1
         B1ACbKlDDHPx2Y3AIjmFshZdJ5/OKmUDBNQ7I=
MIME-Version: 1.0
Date: Mon, 6 Apr 2009 19:40:01 +0400
Message-ID: <a4423d670904060840u5a144502t2b5dcf2773c00d11@mail.gmail.com>
Subject: [PATCH next] dmar: fix build
From: Alexander Beregalov <a.beregalov@gmail.com>
To: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error:
drivers/pci/dmar.c:47: error: expected '=', ',', ';', 'asm' or
'__attribute__' before 'dmar_tbl_size'

Should include acpi.h

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/pci/dmar.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 25a00ce..b725a5f 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -33,6 +33,7 @@
 #include <linux/timer.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <acpi/acpi.h>

 #undef PREFIX
 #define PREFIX "DMAR:"
