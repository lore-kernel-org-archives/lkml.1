Return-Path: <linux-kernel-owner+w=401wt.eu-S965280AbXCFQeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280AbXCFQeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:34:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965283AbXCFQeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:34:02 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:56229 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965280AbXCFQeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:34:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BxSlyLi8SqPneTwWRXooCD7b7/1/uXLHC5XGhFBeNU7JvEgD8/aaxDlyD0kpYaGEqRqlD2EnxSM6yWeB1HfuJb4cyNbgL5vkUoJQGamAJ7sKar8EzLvpZiRhcn+7jXmrAHL2FLvegM3nmOIZptg27ln2Y0x41lh7Ps2mfcB1j8w=
Message-ID: <9c21eeae0703060833m69ebe196o302508f1e809d03@mail.gmail.com>
Date: Tue, 6 Mar 2007 08:33:59 -0800
From: "David Brown" <dmlb2000@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] remove availability for PAGE_SIZE and friends (ppc)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Same patch as the i386 one only for ppc.

Thanks,
- David Brown

diff --git a/include/asm-ppc/page.h b/include/asm-ppc/page.h
index fe95c82..79d54af 100644
--- a/include/asm-ppc/page.h
+++ b/include/asm-ppc/page.h
@@ -3,6 +3,8 @@

 #include <asm/asm-compat.h>

+#ifdef __KERNEL__
+
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT     12
 #define PAGE_SIZE      (ASM_CONST(1) << PAGE_SHIFT)
@@ -13,8 +15,6 @@
  */
 #define PAGE_MASK      (~((1 << PAGE_SHIFT) - 1))

-#ifdef __KERNEL__
-
 /* This must match what is in arch/ppc/Makefile */
 #define PAGE_OFFSET    CONFIG_KERNEL_START
 #define KERNELBASE     PAGE_OFFSET
