Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbYGNC6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbYGNC6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 22:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756321AbYGNC5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 22:57:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:20526 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202AbYGNC5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 22:57:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=pA7AumBwB4jv7737IFJ3hnOhV21Ja5rlGSEpW77ND9jEw6DonqaSWLAL7yldfBL41V
         qnvzxW6BHZ7rSYkAOfMYdpl/ipExsXmJEX6jj/OU/KBnv+28m5r+gYyQFu7TvQbPiH+G
         NM0Ds6Z+64bHBvml5cq9x05Gq/+pzO2A7FsT4=
Message-Id: <20080714025742.370469321@gmail.com>
References: <20080714025631.338886297@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 14 Jul 2008 11:56:33 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Andrew Vasquez <linux-driver@qlogic.com>,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Seokmann Ju <seokmann.ju@qlogic.com>
Subject: [patch -mmotm 2/6] fix qla2xxx-use-memory_read_from_buffer.patch
Content-Disposition: inline; filename=qla2xxx-use-memory_read_from_buffer-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now memory_read_from_buffer() belongs in string.h

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Vasquez <linux-driver@qlogic.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    1 -
 1 file changed, 1 deletion(-)

Index: 2.6-mmotm/drivers/scsi/qla2xxx/qla_attr.c
===================================================================
--- 2.6-mmotm.orig/drivers/scsi/qla2xxx/qla_attr.c
+++ 2.6-mmotm/drivers/scsi/qla2xxx/qla_attr.c
@@ -8,7 +8,6 @@
 
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
-#include <linux/fs.h>
 
 static int qla24xx_vport_disable(struct fc_vport *, bool);
 

-- 
