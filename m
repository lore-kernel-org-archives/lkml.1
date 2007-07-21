Return-Path: <linux-kernel-owner+w=401wt.eu-S939558AbXGUPFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939558AbXGUPFw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939114AbXGUPCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:02:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937809AbXGUPCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=XU7Ulyo2dzhPfV5ko7bXhufFIrgXNVWJ7AkaRXElIfG6K89K94SK8TUvVPt+ZotpTmKJATx8z5AP7ODrHcJoDn4hpkLhL0VClWwWTlArsENDKr01x/TPDFFOitoGHKyHS4knxDBuS41U9TeoIeTsZ2neNUQ+eWeA07vm38gNVuw=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][05/37] Clean up duplicate includes in drivers/block/
Date: Sat, 21 Jul 2007 17:01:52 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Dave Boutcher <boutcher@us.ibm.com>, Ryan Arnold <ryanarn@us.ibm.com>,
       Colin Devilbiss <devilbis@us.ibm.com>,
       Stephen Rothwell <sfr@au1.ibm.com>, Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211701.53199.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	drivers/block/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
index dae3991..f3f32c7 100644
--- a/drivers/block/viodasd.c
+++ b/drivers/block/viodasd.c
@@ -41,7 +41,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/completion.h>
 #include <linux/device.h>
-#include <linux/kernel.h>
 
 #include <asm/uaccess.h>
 #include <asm/vio.h>
