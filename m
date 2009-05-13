Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbZEMNBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbZEMNBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbZEMNBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:01:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:4781 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850AbZEMNBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bJSl4P9imRObMpeZJ+P4pyyIFaaR6/jGqp+usZNLmpwKWGTJT1w9H69DtW+mLxaiDR
         lV6iBD05wfr0/4NVv0YKCgkdlbxh+Qxsaoo07iQxlWqlWpaZoyWCNS94ezoSSFVJNY75
         kIEaAcqQeY3f139+oc8dpvUxk5egO3vg9R1As=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: data.c should include delay.h
Date: Wed, 13 May 2009 17:00:48 +0400
Message-Id: <1242219648-16165-2-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1242219648-16165-1-git-send-email-a.beregalov@gmail.com>
References: <1242219648-16165-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error:
.../data.c:86: error: implicit declaration of function 'udelay'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/comedi/kcomedilib/data.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/kcomedilib/data.c b/drivers/staging/comedi/kcomedilib/data.c
index 3e5fe2c..c26df4e 100644
--- a/drivers/staging/comedi/kcomedilib/data.c
+++ b/drivers/staging/comedi/kcomedilib/data.c
@@ -26,6 +26,7 @@
 #include "../comedidev.h"
 
 #include <linux/string.h>
+#include <asm/delay.h>
 
 int comedi_data_write(void *dev, unsigned int subdev, unsigned int chan,
 	unsigned int range, unsigned int aref, unsigned int data)
-- 
1.6.3

