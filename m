Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbYAWJVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbYAWJVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 04:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYAWJVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 04:21:09 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:59191 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbYAWJVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 04:21:08 -0500
Date: Wed, 23 Jan 2008 01:27:31 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: should use array directly for early_ptr
In-reply-to: <200801230056.16424.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <200801230127.32113.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801230056.16424.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: should use array directly for early_ptr

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

--- a/arch/x86/kernel/setup_64.c	2008-01-23 01:21:06.000000000 -0800
+++ b/arch/x86/kernel/setup_64.c	2008-01-23 01:21:24.000000000 -0800
@@ -344,10 +344,10 @@
 
 #ifdef CONFIG_SMP
 	/* setup to use the early static init tables during kernel startup */
-	x86_cpu_to_apicid_early_ptr = (void *)&x86_cpu_to_apicid_init;
-	x86_bios_cpu_apicid_early_ptr = (void *)&x86_bios_cpu_apicid_init;
+	x86_cpu_to_apicid_early_ptr = (void *)x86_cpu_to_apicid_init;
+	x86_bios_cpu_apicid_early_ptr = (void *)x86_bios_cpu_apicid_init;
 #ifdef CONFIG_NUMA
-	x86_cpu_to_node_map_early_ptr = (void *)&x86_cpu_to_node_map_init;
+	x86_cpu_to_node_map_early_ptr = (void *)x86_cpu_to_node_map_init;
 #endif
 #endif
 
