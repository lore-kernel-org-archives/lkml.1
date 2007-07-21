Return-Path: <linux-kernel-owner+w=401wt.eu-S940728AbXGUPMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940728AbXGUPMb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939461AbXGUPEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:04:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939453AbXGUPEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:04:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=Uc7e4vyCr5y7auC5E4PuO0WpJIvDi3QmI3nygBknrdDVWIdEAZBS179mOAr1fsBlm7+HAXlvOJOVWIwiHCG9VFrzSz8CxghjDdJzjJTiQgvsx31a+KO+kgNIDSSfCHXsL6Wai+HerSeJP8u6MgQkArvd7F+nLhemf0DCjtPrRGg=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][21/37] Clean up duplicate includes in include/media/
Date: Sat, 21 Jul 2007 17:03:26 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.26303.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	include/media/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index d62847f..76703c7 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -23,8 +23,6 @@
 #include <linux/videodev2.h>
 #endif
 
-#include <linux/fs.h>
-
 #define VIDEO_MAJOR	81
 /* Minor device allocation */
 #define MINOR_VFL_TYPE_GRABBER_MIN   0
