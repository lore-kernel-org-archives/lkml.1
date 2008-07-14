Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYGNC6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYGNC6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 22:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756439AbYGNC5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 22:57:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:19719 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406AbYGNC5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 22:57:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=qtU00GPfIEl/HZAdjxjypZmzJGJ3dQNiEaslTMa+S5ZL1BorbKIl5XOQoZlQqBuEgl
         7sZmyqrY243J1AQ435B5CP7MmyyaU3S4ZEYuEX577pAkAvYkUEN9AhFCmuVrU4A5C7dJ
         9ZZKjCdk0b42wyrU3Fg85kOaJD6elm8WYdmK0=
Message-Id: <20080714025746.065967662@gmail.com>
References: <20080714025631.338886297@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 14 Jul 2008 11:56:34 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>, Zhang Rui <rui.zhang@intel.com>,
       Matt Domsch <Matt_Domsch@dell.com>
Subject: [patch -mmotm 3/6] fix dcdbas-use-memory_read_from_buffer.patch
Content-Disposition: inline; filename=dcdbas-use-memory_read_from_buffer-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now memory_read_from_buffer() belongs in string.h

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
---
 drivers/firmware/dcdbas.c |    1 -
 1 file changed, 1 deletion(-)

Index: 2.6-mmotm/drivers/firmware/dcdbas.c
===================================================================
--- 2.6-mmotm.orig/drivers/firmware/dcdbas.c
+++ 2.6-mmotm/drivers/firmware/dcdbas.c
@@ -34,7 +34,6 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
-#include <linux/fs.h>
 #include <asm/io.h>
 
 #include "dcdbas.h"

-- 
