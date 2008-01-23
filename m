Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbYAWIt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbYAWIt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 03:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYAWItw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 03:49:52 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:58867 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbYAWItv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 03:49:51 -0500
Date: Wed, 23 Jan 2008 00:56:16 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: remove duplicated line about
 x86_bios_cpu_apicid_early_ptr
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <200801230056.16424.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: remove duplicated line about x86_bios_cpu_apicid_early_ptr

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 2643a8f..b587166 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -349,7 +349,6 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_NUMA
 	x86_cpu_to_node_map_early_ptr = (void *)&x86_cpu_to_node_map_init;
 #endif
-	x86_bios_cpu_apicid_early_ptr = (void *)&x86_bios_cpu_apicid_init;
 #endif
 
 #ifdef CONFIG_ACPI
