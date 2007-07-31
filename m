Return-Path: <linux-kernel-owner+w=401wt.eu-S1761333AbXGaNKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761333AbXGaNKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760649AbXGaNJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:09:15 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42959
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760034AbXGaNJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:09:13 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:09:04 EDT
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125439.238012000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:19 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Paul Mackerras <paulus@samba.org>
Subject: [Patch 03/16] Remove unnecessary kmalloc casts from the powerpc arch.
Content-Disposition: inline; filename=arch_powerpc_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: Paul Mackerras <paulus@samba.org>

---
 arch/powerpc/kernel/ibmebus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/arch/powerpc/kernel/ibmebus.c
===================================================================
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -383,7 +383,7 @@ static int ibmebus_match_path(struct dev
 
 static char *ibmebus_chomp(const char *in, size_t count)
 {
-	char *out = (char*)kmalloc(count + 1, GFP_KERNEL);
+	char *out = kmalloc(count + 1, GFP_KERNEL);
 	if (!out)
 		return NULL;
 

-- 
