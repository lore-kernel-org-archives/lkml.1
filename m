Return-Path: <linux-kernel-owner+w=401wt.eu-S1765959AbYBCLd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765959AbYBCLd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 06:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbYBCLcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:32:51 -0500
Received: from hu-out-0506.google.com ([72.14.214.230]:23922 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbYBCLct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:32:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=gTAbTmB35fWpet6c6o+8y7sbLQWeZpcW+/0IOjsPitbDK4c6AnuQQJSKet/5/V0T7TNHVYhDGW/9dlHCs3CaiQPF1N6DxtBv001znYdjSHN5Hbh6XJzXUICHlJSv5x0mWx0iYUZSKzeAWB9+S2dDtkBQ7xD7W0XaBVWbjJbIQoE=
References: <20080203112217.126814108@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sun, 03 Feb 2008 14:22:20 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-kernel@vger.kernel.org, davem@davemloft.net, bryan.wu@analog.com,
       hskinnemoen@atmel.co, dhowells@redhat.com
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 3/4] FRV: cleanup - use _AC macro to define PAGE_SIZE
Content-Disposition: inline; filename=asm-frv.diff
Message-ID: <47a5a65e.1ae7300a.7328.ffff9f86@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 mem-layout.h |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

Index: linux-2.6.git/include/asm-frv/mem-layout.h
===================================================================
--- linux-2.6.git.orig/include/asm-frv/mem-layout.h	2008-01-21 19:35:27.000000000 +0300
+++ linux-2.6.git/include/asm-frv/mem-layout.h	2008-02-03 13:45:25.000000000 +0300
@@ -12,6 +12,8 @@
 #ifndef _ASM_MEM_LAYOUT_H
 #define _ASM_MEM_LAYOUT_H
 
+#include <linux/const.h>
+
 #ifndef __ASSEMBLY__
 #define __UL(X)	((unsigned long) (X))
 #else
@@ -22,13 +24,7 @@
  * PAGE_SHIFT determines the page size
  */
 #define PAGE_SHIFT			14
-
-#ifndef __ASSEMBLY__
-#define PAGE_SIZE			(1UL << PAGE_SHIFT)
-#else
-#define PAGE_SIZE			(1 << PAGE_SHIFT)
-#endif
-
+#define PAGE_SIZE			(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK			(~(PAGE_SIZE-1))
 
 /*****************************************************************************/

-- 
