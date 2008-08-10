Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbYHJPvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbYHJPvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYHJPt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:49:57 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:3529 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbYHJPtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:49:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=iQBlslPaflFAqtg8KCQ3HpBtv6eWvQwrYsTT36BFY2VUggJBSDLQr3G2QJpn+A3jEx
         GkTuATHWw1S+XjWfQaHxgWDP74KRdOQ0xJ1gt7HBIaplGjujZU2QZzCsJIDR84W9HEAA
         F7OLvoJGhPSBNNLuMaj6xBlgULAComX0UO9T4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove unused macros from <asm-parisc/ide.h>
Date: Sun, 10 Aug 2008 17:47:07 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808101747.08025.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/asm-parisc/ide.h |    4 ----
 1 file changed, 4 deletions(-)

Index: b/include/asm-parisc/ide.h
===================================================================
--- a/include/asm-parisc/ide.h
+++ b/include/asm-parisc/ide.h
@@ -13,10 +13,6 @@
 
 #ifdef __KERNEL__
 
-#define ide_request_irq(irq,hand,flg,dev,id)	request_irq((irq),(hand),(flg),(dev),(id))
-#define ide_free_irq(irq,dev_id)		free_irq((irq), (dev_id))
-#define ide_request_region(from,extent,name)	request_region((from), (extent), (name))
-#define ide_release_region(from,extent)		release_region((from), (extent))
 /* Generic I/O and MEMIO string operations.  */
 
 #define __ide_insw	insw
