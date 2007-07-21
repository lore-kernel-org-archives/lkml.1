Return-Path: <linux-kernel-owner+w=401wt.eu-S939845AbXGUPIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939845AbXGUPIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935195AbXGUPDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:03:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937809AbXGUPD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:03:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=dPAZI+TlnkCLMFEQ0Uyo9U7O5IdZLvWnsKm3j8fwa0ZhqWkFLdx7FOYaenUufbZue25PYhFenmD4v9jpc6CRhS4U9FIDQ4+LkksR/Ct+ixjiVwwRPW7RsYgPLRi4O5nnVZZvripJRMCTpRQhUgcZ7BGtEUk/Zm0a8xYKuepGSt0=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][10/37] Clean up duplicate includes in drivers/media/
Date: Sat, 21 Jul 2007 17:02:32 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Takeo Takahashi <takahashi.takeo@renesas.com>,
       Jelle Foks <jelle@foks.8m.com>, Chris Pascoe <c.pascoe@itee.uq.edu.au>,
       Gerd Knorr <kraxel@bytesex.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211702.32498.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	drivers/media/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/media/video/arv.c b/drivers/media/video/arv.c
index 649f52f..2666d3b 100644
--- a/drivers/media/video/arv.c
+++ b/drivers/media/video/arv.c
@@ -23,7 +23,6 @@
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index 317a2a3..49a1b9c 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -28,7 +28,6 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
-#include <linux/dma-mapping.h>
 #include <asm/delay.h>
 
 #include "cx88.h"
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 06b233a..41b5cb6 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -36,7 +36,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
-#include <linux/dma-mapping.h>
 #include <asm/div64.h>
 
 #include "cx88.h"
