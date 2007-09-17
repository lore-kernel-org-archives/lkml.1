Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbXIQR7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbXIQR7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 13:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbXIQR7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 13:59:01 -0400
Received: from smtp109.plus.mail.re1.yahoo.com ([69.147.102.72]:30222 "HELO
	smtp109.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752368AbXIQR7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 13:59:00 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2007 13:59:00 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=kdW5tYaVHCSkJVB47o20q+lfrq+Wtr8aORjdDOVDCUJjS/ITgwvPNecUHeLx66aky1yD2OWv8ZISJOYjAOea5KVuNUDvGhaURWZxRXCDi5hKls+11yFCk3V9fGFSQvV5bca/peEL+w6vEmlwX/p00JiXD9u+owok6KD7kga0NLU=  ;
X-YMail-OSG: zAkrrOAVM1m.GaH.G0bTzfHUCqumRzZRLwh_JFj1H8Lmmfg6Ij3N8wHtLSQoxOp_DeTJ7yWWkQ--
Date: Mon, 17 Sep 2007 19:51:39 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] unify DMA_..BIT_MASK definitions
Message-ID: <20070917175139.GA4941@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patches remove redundant DMA_..BIT_MASK definitions across two drivers.
First off, consolidate dma bitmask definitions in the proper header file...

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--
Index: 23-rc6/include/linux/dma-mapping.h
===================================================================
--- 23-rc6/include/linux/dma-mapping.h.orig	2007-09-17 17:48:20.000000000 +0200
+++ 23-rc6/include/linux/dma-mapping.h	2007-09-17 19:34:21.000000000 +0200
@@ -17,6 +17,7 @@
 #define DMA_48BIT_MASK	0x0000ffffffffffffULL
 #define DMA_40BIT_MASK	0x000000ffffffffffULL
 #define DMA_39BIT_MASK	0x0000007fffffffffULL
+#define DMA_35BIT_MASK	0x00000007ffffffffULL
 #define DMA_32BIT_MASK	0x00000000ffffffffULL
 #define DMA_31BIT_MASK	0x000000007fffffffULL
 #define DMA_30BIT_MASK	0x000000003fffffffULL
-- 
Regards/Gruﬂ,
    Boris.
