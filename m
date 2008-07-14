Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbYGNC6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbYGNC6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 22:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756500AbYGNC5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 22:57:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:20526 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479AbYGNC5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 22:57:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=MwUgVflJ0LURkl6hQMZ8ck1sn0yTmfTGwU0dK+cpx97omzcf2PaaZZ7qPJhDLgASPy
         +zxFkboyy4D1tqPQsP7C1FjOSAujH+3dIyB5hxlobH0QJp111VJpjOud8ShU8jfrkSX2
         lPew8Z2t/iCFgwFKFYjMR4Z0cBev2Z9nBVX9M=
Message-Id: <20080714025749.860983365@gmail.com>
References: <20080714025631.338886297@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 14 Jul 2008 11:56:35 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Antonino A. Daplas" <adaplas@pol.net>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: [patch -mmotm 4/6] fix aty-use-memory_read_from_buffer.patch
Content-Disposition: inline; filename=aty-use-memory_read_from_buffer-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now memory_read_from_buffer() belongs in string.h

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
---
 drivers/video/aty/radeon_base.c |    1 -
 1 file changed, 1 deletion(-)

Index: 2.6-mmotm/drivers/video/aty/radeon_base.c
===================================================================
--- 2.6-mmotm.orig/drivers/video/aty/radeon_base.c
+++ 2.6-mmotm/drivers/video/aty/radeon_base.c
@@ -70,7 +70,6 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/device.h>
-#include <linux/fs.h>
 
 #include <asm/io.h>
 #include <linux/uaccess.h>

-- 
