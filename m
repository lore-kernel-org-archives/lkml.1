Return-Path: <linux-kernel-owner+w=401wt.eu-S937450AbXG2VuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937450AbXG2VuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935697AbXG2Vt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:49:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:6369 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934800AbXG2Vt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QwcUaF92DMvhAQmMKs+b1a2RVRaS3XlPlErC34WCKonP55/LvMt38O4R7y3q6siMqsZdzx+q9ZP3kjFyabr4aeCeVZmqtNLL32gAQ0jhXhCvg7Xv3EvrUyZUD7YP3DiKJanmg+ZY3mlVBUrwEsG1M15+2zY0AZHKPLDF4MuzLnM=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Blackfin: Remove duplicate inclusion of linux/irq.h
Date: Sun, 29 Jul 2007 23:48:25 +0200
User-Agent: KMail/1.9.7
Cc: Aidan Williams <aidan@nicta.com.au>, aubrey.li@analog.com,
       bernd.schmidt@analog.com, bryan.wu@analog.com, grace.pan@analog.com,
       marc.hoffman@analog.com, michael.hennerich@analog.com,
       michael.frysinger@analog.com, jerry.zeng@analog.com,
       jie.zhang@analog.com, robin.getz@analog.com, roy.huang@analog.com,
       sonic.zhang@analog.com, vivi.li@analog.com, yi.li@analog.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707292348.25880.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

arch/blackfin/mach-bf548/boards/ezkit.c includes linux/irq.h twice.
This patch removes the duplicate.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 arch/blackfin/mach-bf548/boards/ezkit.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index 96ad95f..9e00ada 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -35,7 +35,6 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #include <linux/irq.h>
-#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <asm/bfin5xx_spi.h>
 


