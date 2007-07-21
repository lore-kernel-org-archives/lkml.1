Return-Path: <linux-kernel-owner+w=401wt.eu-S939502AbXGUPEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939502AbXGUPEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938674AbXGUPCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:02:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938503AbXGUPCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:02:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=Cck+zkuTem6oWOwTzXDY6JU7bE0h/Bs2I4VOq419QV4dOJJ7LuE2KDgHXP6G/Ue+8X/DhBIWyW/71feQqFsXFaaeiskG2CnVfe7cuQFtF+2r0HZrU/Ag366XJCFncMTLQGbSL/MX/2o9Oghj9+XduAtQ/ZDcWCDUoCSVHF5R19g=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][04/37] Clean up duplicate includes in drivers/atm/
Date: Sat, 21 Jul 2007 17:01:50 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Chas Williams <chas@cmf.nrl.navy.mil>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211701.50788.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	drivers/atm/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index 55fd1b4..144a49f 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -65,7 +65,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/dma-mapping.h>
 
 /* -------------------- TUNABLE PARAMATERS: */
 
