Return-Path: <linux-kernel-owner+w=401wt.eu-S1761064AbYGDRBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064AbYGDRBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760582AbYGDQ57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:57:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:5166 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760910AbYGDQ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:57:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oQLmU0R6ilJQqxy/i5qDDQXMv/9MbdaKV8BVgaXM8OCQema+uCyDvf7xhepsKDLrGv
         RuSfRjZNjJFIsiQHGQtPNfo3C+YMO2sohcCqT5SabnR7A7ZLDeuNEDhWUKp40uL66z3T
         rDMobmkIgbgfwR7pvbX40totjZxnF903kTkdk=
Date: Sat, 5 Jul 2008 01:57:50 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Antonino A. Daplas" <adaplas@pol.net>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: [PATCH -mm] fix aty-use-memory_read_from_buffer.patch
Message-ID: <20080704165749.GF22477@localhost.localdomain>
References: <200807040647.m646lXpN017508@imap1.linux-foundation.org> <1215182555.5413.8.camel@localhost.localdomain> <20080704163942.GA15214@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20080704163942.GA15214@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Index: 2.6-mm/drivers/video/aty/radeon_base.c
===================================================================
--- 2.6-mm.orig/drivers/video/aty/radeon_base.c
+++ 2.6-mm/drivers/video/aty/radeon_base.c
@@ -70,7 +70,6 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/device.h>
-#include <linux/fs.h>
 
 #include <asm/io.h>
 #include <linux/uaccess.h>
