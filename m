Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbXIQR7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbXIQR7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 13:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbXIQR7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 13:59:14 -0400
Received: from smtp113.plus.mail.re1.yahoo.com ([69.147.102.76]:46024 "HELO
	smtp113.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754499AbXIQR7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 13:59:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=rNiQhG/ckwg3vV+LoX5NvDVDW2kOIb+AA9FjnNyOKrChZZBHEo1IO5OtTmZtrJFkKNqEuPMEXIDSIvnyLeyISIeOvBOkeFfE8Fr2j3xYCRjOGBpRCTDl263RLvC0E1PFbwtn8q4L5GKW1u/qk0os6ZGSL/GqdgMpm5XAqsNe36s=  ;
X-YMail-OSG: b_c9CSgVM1mWXqKW3kJbkU7Ey6JCQSbYL0WXs68vCAbHgAHa3fHCl4QxkSb6btLuyPHELNOIbQ--
Date: Mon, 17 Sep 2007 19:51:59 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-kernel@vger.kernel.org
Cc: achim_leubner@adaptec.com
Subject: [PATCH 2/2] unify DMA_..BIT_MASK definitions: cleanup
	drivers/scsi/gdth.c
Message-ID: <20070917175159.GC4941@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

move local #defines to the dma-mappings header.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--
Index: 23-rc6/drivers/scsi/gdth.c
===================================================================
--- 23-rc6/drivers/scsi/gdth.c.orig	2007-09-17 17:53:26.000000000 +0200
+++ 23-rc6/drivers/scsi/gdth.c	2007-09-17 17:53:49.000000000 +0200
@@ -392,12 +392,7 @@
 #include <linux/proc_fs.h>
 #include <linux/time.h>
 #include <linux/timer.h>
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,6)
 #include <linux/dma-mapping.h>
-#else
-#define DMA_32BIT_MASK	0x00000000ffffffffULL
-#define DMA_64BIT_MASK	0xffffffffffffffffULL
-#endif
 
 #ifdef GDTH_RTC
 #include <linux/mc146818rtc.h>
-- 
Regards/Gruﬂ,
    Boris.
