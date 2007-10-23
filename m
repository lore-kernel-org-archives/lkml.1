Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbXJWKIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbXJWKIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbXJWKHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:07:23 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51230 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbXJWKHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:07:22 -0400
Date: Tue, 23 Oct 2007 03:07:24 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: typo about sequence of cpu_index and cpu_online in
 show_cpuinfo
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200710230307.24793.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: typo about sequence of cpu_index and cpu_online in show_cpuinfo

use the real cpu_index instead of 0.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 2d42b41..2196b51 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -89,9 +89,9 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	int fpu_exception;
 
 #ifdef CONFIG_SMP
+	n = c->cpu_index;
 	if (!cpu_online(n))
 		return 0;
-	n = c->cpu_index;
 #endif
 	seq_printf(m, "processor\t: %d\n"
 		"vendor_id\t: %s\n"
