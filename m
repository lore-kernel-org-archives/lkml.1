Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbYBUCo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbYBUCo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 21:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYBUCot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 21:44:49 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42376 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYBUCos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 21:44:48 -0500
Date: Wed, 20 Feb 2008 18:53:17 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: remove double-checking empty zero pages debug
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802201853.17265.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so far, no one complained that.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index fafeb95..f4a5a2b 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -574,14 +574,6 @@ void __init mem_init(void)
 
 	/* clear_bss() already clear the empty_zero_page */
 
-	/* temporary debugging - double check it's true: */
-	{
-		int i;
-
-		for (i = 0; i < 1024; i++)
-			WARN_ON_ONCE(empty_zero_page[i]);
-	}
-
 	reservedpages = 0;
 
 	/* this will put all low memory onto the freelists */
