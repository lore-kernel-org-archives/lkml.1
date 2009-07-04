Return-Path: <linux-kernel-owner+w=401wt.eu-S1759852AbZGDCfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852AbZGDCfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759398AbZGDCfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:35:17 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:51333 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759348AbZGDCfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WihAIIZvcsxHW6U9ClY4ZJL9RQcMEVThnWz/hbveQUdk9vTW66OiuPw5W5/3PFWJyC
         i7x1ebNp4kZvXatNO9ECNx6ZS/m3kWf/GhxUL0f9+hAsNYjKrPEdpXMVFCoCkjz/BIdQ
         KkEgmR9f+UDvQ+I2HQtI5M/OpCgmAhl1VFMxQ=
From: tom.leiming@gmail.com
To: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/3] dma-mapping:X86:remove CONFIG_HAVE_DMA_ATTRS
Date: Sat,  4 Jul 2009 10:34:54 +0800
Message-Id: <1246674895-9610-3-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1246674895-9610-2-git-send-email-tom.leiming@gmail.com>
References: <1246674895-9610-1-git-send-email-tom.leiming@gmail.com>
 <1246674895-9610-2-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>


Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 arch/x86/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c86a1af..a135d27 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -28,7 +28,6 @@ config X86
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_FRAME_POINTERS
-	select HAVE_DMA_ATTRS
 	select HAVE_KRETPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
-- 
1.6.0.GIT

