Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbXIREcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbXIREcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 00:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbXIREcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 00:32:10 -0400
Received: from smtp108.plus.mail.re1.yahoo.com ([69.147.102.71]:38142 "HELO
	smtp108.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753469AbXIREcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 00:32:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=4zihntPLGp2wRap6td0oCHc26GAzS+oRx5oyUnp5YiB/kgdSiNAP135lnzKKAkvD/msuq8rRjc6CqGYx1hAoDkMLi8wr5iVAcUKxXkki60KoX44eIh16FPwj5AKw77NgXnhCJSbgod7of2n5WZhH/pRpP6d8QyUl+wbs/6hLW2k=  ;
X-YMail-OSG: LEU0UlMVM1luXtSXny9l41m6Uj02ScZDAynzO6626t7XlWa1C8eCS94_eTX01Ywo6yp0fKPZBw--
Date: Tue, 18 Sep 2007 06:31:32 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-kernel@vger.kernel.org
Cc: achim_leubner@adaptec.com, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 2/2] unify DMA_..BIT_MASK definitions v1: cleanup
	drivers/scsi/gdth.c
Message-ID: <20070918043132.GA9340@gollum.tnic>
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
