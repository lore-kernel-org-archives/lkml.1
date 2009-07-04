Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbZGDCf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbZGDCf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759369AbZGDCfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:35:25 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:51333 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759545AbZGDCfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:35:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wDLpci0vkLI3Ecwe21IwKFaVlKik2wdwd6NCFylXxrWLEe0X7kfBWp88R1W4d0Gh/U
         a4nCDwpig1/FZdquQE9mlCtczJoD+XwoT4jSBdNHKEmq1RQ9sicI4kadrLEP3IAT9b0+
         nCq/aC0L1omGFSJNF7797NDoHtL73e3EvNw8I=
From: tom.leiming@gmail.com
To: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 3/3] dma-mapping:IA64:remove CONFIG_HAVE_DMA_ATTRS
Date: Sat,  4 Jul 2009 10:34:55 +0800
Message-Id: <1246674895-9610-4-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1246674895-9610-3-git-send-email-tom.leiming@gmail.com>
References: <1246674895-9610-1-git-send-email-tom.leiming@gmail.com>
 <1246674895-9610-2-git-send-email-tom.leiming@gmail.com>
 <1246674895-9610-3-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>


Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 arch/ia64/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 328d2f8..07b7f68 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -25,7 +25,6 @@ config IA64
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE if (!ITANIUM)
 	select HAVE_FUNCTION_TRACER
-	select HAVE_DMA_ATTRS
 	select HAVE_KVM
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
-- 
1.6.0.GIT

