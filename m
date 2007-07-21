Return-Path: <linux-kernel-owner+w=401wt.eu-S939428AbXGUPTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939428AbXGUPTA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939087AbXGUPFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:05:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:40095 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761000AbXGUPFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=k9Goz2pIBAMhUkY4UIRNM2nFg3z3Zl3annFcnafqoBj3CQ7IimPjLuTKr34fMuwprEC29oLyTb9wYabANTH1yOrmZkPVR8QbalKNkyFWpkrw74mXNwOlX4VSXRYvOfJyjSY0xXR8DByyvp+Hn0Bsd4xaYgGkRCxQg2SWGnf+Pek=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][36/37] Clean up duplicate includes in sound/ppc/
Date: Sat, 21 Jul 2007 17:04:07 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, Geoff Levand <geoffrey.levand@am.sony.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211704.07263.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	XXXX/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/sound/ppc/snd_ps3.c b/sound/ppc/snd_ps3.c
index 1aa0b46..27b6189 100644
--- a/sound/ppc/snd_ps3.c
+++ b/sound/ppc/snd_ps3.c
@@ -33,7 +33,6 @@
 #include <linux/dmapool.h>
 #include <linux/dma-mapping.h>
 #include <asm/firmware.h>
-#include <linux/io.h>
 #include <asm/dma.h>
 #include <asm/lv1call.h>
 #include <asm/ps3.h>
