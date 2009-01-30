Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZA3KVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZA3KVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZA3KSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:18:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54383 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbZA3KRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:17:54 -0500
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, lnxninja@linux.vnet.ibm.com,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Remove now unused default_update_genapic
Date: Fri, 30 Jan 2009 11:17:16 +0100
Message-Id: <1233310639-27916-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233310639-27916-10-git-send-email-andi@firstfloor.org>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
 <1233310639-27916-2-git-send-email-andi@firstfloor.org>
 <1233310639-27916-3-git-send-email-andi@firstfloor.org>
 <1233310639-27916-4-git-send-email-andi@firstfloor.org>
 <1233310639-27916-5-git-send-email-andi@firstfloor.org>
 <1233310639-27916-6-git-send-email-andi@firstfloor.org>
 <1233310639-27916-7-git-send-email-andi@firstfloor.org>
 <1233310639-27916-8-git-send-email-andi@firstfloor.org>
 <1233310639-27916-9-git-send-email-andi@firstfloor.org>
 <1233310639-27916-10-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/setup.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d6627cf..535e6bd 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -600,13 +600,7 @@ static int __init setup_elfcorehdr(char *arg)
 early_param("elfcorehdr", setup_elfcorehdr);
 #endif
 
-static int __init default_update_genapic(void)
-{
-	return 0;
-}
-
 static struct x86_quirks default_x86_quirks __initdata = {
-	.update_genapic         = default_update_genapic,
 };
 
 struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
-- 
1.5.6.5

