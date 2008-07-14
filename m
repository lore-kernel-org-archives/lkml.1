Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbYGNC7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbYGNC7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 22:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbYGNC6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 22:58:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:20526 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbYGNC6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 22:58:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=iuxAyaaEMqn0Vft5FixCjJ/rMwnXMTsidnG+rQO62eiA3s8HhlOhn7rP3BLVQNPZKc
         7YaFyFsWbZKBTe2RRxb7Mnj47s9acXf+Vm4HtEBVDOAFApvsbuv/BeuVJNn51l4ncUUp
         /4IZ1BvqzkXTuHYN3GXosbqLuogwNDpoAojxc=
Message-Id: <20080714025756.999018757@gmail.com>
References: <20080714025631.338886297@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 14 Jul 2008 11:56:37 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Abhay Salunke <Abhay_Salunke@dell.com>, Zhang Rui <rui.zhang@intel.com>,
       Matt Domsch <Matt_Domsch@dell.com>
Subject: [patch -mmotm 6/6] fix dell_rbu-use-memory_read_from_buffer.patch
Content-Disposition: inline; filename=dell_rbu-use-memory_read_from_buffer-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now memory_read_from_buffer() belongs in string.h

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Abhay Salunke <Abhay_Salunke@dell.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
---
 drivers/firmware/dell_rbu.c |    1 -
 1 file changed, 1 deletion(-)

Index: 2.6-mmotm/drivers/firmware/dell_rbu.c
===================================================================
--- 2.6-mmotm.orig/drivers/firmware/dell_rbu.c
+++ 2.6-mmotm/drivers/firmware/dell_rbu.c
@@ -44,7 +44,6 @@
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <linux/dma-mapping.h>
-#include <linux/fs.h>
 
 MODULE_AUTHOR("Abhay Salunke <abhay_salunke@dell.com>");
 MODULE_DESCRIPTION("Driver for updating BIOS image on DELL systems");

-- 
