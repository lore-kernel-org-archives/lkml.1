Return-Path: <linux-kernel-owner+w=401wt.eu-S940404AbXGUPK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940404AbXGUPK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939265AbXGUPEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:04:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:39272 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939425AbXGUPD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=apzA/lrt0eEzykktsf2HT7us1/kqCwjzCCS7DXc9L8z4xawM8DmOPBH3DGmQqbMCWsj6ixMLwoigf4f49btwwAivN8Ntl2K2Z9BLrm1cJbiytoNJ51+8R5RTaFotcPstZBitp4Nb3n+q7BZsJvXRjB7h7cgtcOVN0pGVvnTGoJA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][16/37] Clean up duplicate includes in drivers/w1/
Date: Sat, 21 Jul 2007 17:03:00 +0200
User-Agent: KMail/1.9.7
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.00931.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	drivers/w1/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/w1/masters/matrox_w1.c b/drivers/w1/masters/matrox_w1.c
index d356da5..1550431 100644
--- a/drivers/w1/masters/matrox_w1.c
+++ b/drivers/w1/masters/matrox_w1.c
@@ -33,7 +33,6 @@
 #include <linux/slab.h>
 #include <linux/pci_ids.h>
 #include <linux/pci.h>
-#include <linux/timer.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
