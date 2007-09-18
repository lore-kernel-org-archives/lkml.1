Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbXIRGRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbXIRGRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 02:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758361AbXIRGRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 02:17:24 -0400
Received: from smtp108.plus.mail.re1.yahoo.com ([69.147.102.71]:42542 "HELO
	smtp108.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758322AbXIRGRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 02:17:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=cPFkmpp0V98sf8ABKMOkDg6M3MeFyrahW/wDJYbq/h6fQiUta1v6lsiytwpaFSc+QJR5t5nMuQ/qJkwqOieAaGupjYj/Ftq12fKMiMHjiJwe/YMduHBUws6EjanoBN9a/WRJUl7qq2tfdfWnuPmGGovgwtveagTHktfIt63SxO0=  ;
X-YMail-OSG: B6v4ly8VM1ky2zMY3g_NepVGooVtr4KLrqKuUVfaelFnu4o1ZnEy_Dp5npACp2nTp2pw_rZLew--
Date: Tue, 18 Sep 2007 08:16:43 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-kernel@vger.kernel.org
Cc: achim_leubner@adaptec.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>
Subject: [PATCH 2/2] unify DMA_..BIT_MASK definitions v2: cleanup
	drivers/scsi/gdth.c
Message-ID: <20070918061643.GA15987@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move dma bitmask definitions into the dma-mappings header.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>

---
 23-rc6/drivers/scsi/gdth.c |    5 -----
 1 file changed, 5 deletions(-)

Index: b/23-rc6/drivers/scsi/gdth.c
===================================================================
--- a/23-rc6/drivers/scsi/gdth.c	2007-09-18 08:11:01.000000000 +0200
+++ b/23-rc6/drivers/scsi/gdth.c	2007-09-18 08:14:34.000000000 +0200
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
