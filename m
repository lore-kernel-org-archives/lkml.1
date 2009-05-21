Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZEUNGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZEUNGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZEUNGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:06:45 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53837 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbZEUNGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ApeFOsRQvo/OFyT0rKugVOhSSbAhi1UkUcNhnh9VHgTPnxL5veAnUPdx5N1OIwOkl9
         HqLLwhJSRyDaNp5PS/sp56lrx/TuWZ9x5Gtn7mgOFfR5L4/r33nCwUk9kS3JLPGS6Exi
         8ik8eKQ4PGMt/Adw3SsXUt2nm5RDR2w00hooc=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] Staging: comedi: comedidev should include delay.h
Date: Thu, 21 May 2009 17:06:33 +0400
Message-Id: <1242911193-30469-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix many build errors like this:
comedi/drivers/adq12b.c:328: error: implicit declaration of function 'udelay'

The same for aio_aio12_8.c, dmm32at.c and others.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/comedi/comedidev.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 7a1ccde..3d0e80c 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -38,6 +38,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/delay.h>
 
 #include "comedi.h"
 
-- 
1.6.3.1

