Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290Ab0ASOXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab0ASOXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220Ab0ASOXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:23:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:58322 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab0ASOXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:23:04 -0500
Date: Tue, 19 Jan 2010 14:22:38 GMT
From: tip-bot for Thadeu Lima de Souza Cascardo 
	<cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       cascardo@holoscopio.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, cascardo@holoscopio.com, mingo@elte.hu
In-Reply-To: <1263764685-9871-1-git-send-email-cascardo@holoscopio.com>
References: <1263764685-9871-1-git-send-email-cascardo@holoscopio.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, trivial: Fix grammo in tsc comment about Geode TSC reliability
Message-ID: <tip-00097c4fdf117d9845d772f571a987ae95523f8c@git.kernel.org>
Git-Commit-ID: 00097c4fdf117d9845d772f571a987ae95523f8c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Jan 2010 14:22:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00097c4fdf117d9845d772f571a987ae95523f8c
Gitweb:     http://git.kernel.org/tip/00097c4fdf117d9845d772f571a987ae95523f8c
Author:     Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
AuthorDate: Sun, 17 Jan 2010 19:44:44 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Jan 2010 09:01:39 +0100

x86, trivial: Fix grammo in tsc comment about Geode TSC reliability

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: marcelo@kvack.org
Cc: dilinger@collabora.co.uk
Cc: trivial@kernel.org
LKML-Reference: <1263764685-9871-1-git-send-email-cascardo@holoscopio.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 597683a..23066ec 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -806,7 +806,7 @@ static void __init check_system_tsc_reliable(void)
 	unsigned long res_low, res_high;
 
 	rdmsr_safe(MSR_GEODE_BUSCONT_CONF0, &res_low, &res_high);
-	/* Geode_LX - the OLPC CPU has a possibly a very reliable TSC */
+	/* Geode_LX - the OLPC CPU has a very reliable TSC */
 	if (res_low & RTSC_SUSP)
 		tsc_clocksource_reliable = 1;
 #endif
