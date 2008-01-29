Return-Path: <linux-kernel-owner+w=401wt.eu-S934134AbYA2TnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134AbYA2TnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760038AbYA2Tlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:41:42 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:52743 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbYA2Tli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:41:38 -0500
Date: Tue, 29 Jan 2008 11:16:31 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 4/4] x86_64: increse MAX_EARLY_RES for NODE_DATA and bootmap
In-reply-to: <200801291113.35974.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-id: <200801291116.31729.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801291113.35974.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 4/4] x86_64: increse MAX_EARLY_RES for NODE_DATA and bootmap

otherise early_node_mem will use up these for 8 nodes system

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/e820_64.c b/arch/x86/kernel/e820_64.c
index f8b7beb..e3d3815 100644
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -50,7 +50,7 @@ static unsigned long __initdata end_user_pfn = MAXMEM>>PAGE_SHIFT;
 /*
  * Early reserved memory areas.
  */
-#define MAX_EARLY_RES 20
+#define MAX_EARLY_RES 30
 
 struct early_res {
 	unsigned long start, end;


