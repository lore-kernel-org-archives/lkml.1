Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbYG0PgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbYG0PgV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 11:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbYG0PfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 11:35:13 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:24861 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbYG0PfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 11:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=eNhBCN8/dFL6qaQkLbatYozQkyeIk/mnRyWykUaqzgtE5iyVG847ivs+RRnYG1NX2F
         SqpUP/iBeb8pP8+SWYG9ffKYP1PhT/2Agy3HvL39iyyRec1JI4Lm0cOy1hlqW7PIplCM
         wBFKqNeU3engzgKiZaRdjfC9uAPCP0a0h/js0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] remove <linux/ata.h> include from <linux/hdreg.h>
Date: Sun, 27 Jul 2008 17:32:13 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807271732.13758.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All <linux/hdreg.h> users that need <linux/ata.h> have been fixed
to include it directly.

Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/hdreg.h |    4 ----
 1 file changed, 4 deletions(-)

Index: b/include/linux/hdreg.h
===================================================================
--- a/include/linux/hdreg.h
+++ b/include/linux/hdreg.h
@@ -1,10 +1,6 @@
 #ifndef _LINUX_HDREG_H
 #define _LINUX_HDREG_H
 
-#ifdef __KERNEL__
-#include <linux/ata.h>
-#endif /* __KERNEL__ */
-
 #include <linux/types.h>
 
 /*
