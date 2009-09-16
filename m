Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbZIPI6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbZIPI6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbZIPI6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:58:18 -0400
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:28934 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757572AbZIPI6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:58:18 -0400
Date: Wed, 16 Sep 2009 11:58:15 +0300
From: Dragos Tatulea <dtatulea@ixiacom.com>
To: paulus@samba.org, linux-kernel@vger.kernel.org
Cc: Octavian Purdila <opurdila@ixiacom.com>
Subject: [PATCH] ppc: add ppc750 CL as supported by oprofile
Message-ID: <20090916115815.6d9120e9@dragos-tp.localdomain>
Organization: IXIA
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Sep 2009 08:58:16.0223 (UTC) FILETIME=[D4474AF0:01CA36AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	Here's a patch that adds the ppc750 CL cpu as supported by oprofile.

-- Dragos

Signed-off-by: Dragos Tatulea <dtatulea@ixiacom.com>
---
 arch/powerpc/kernel/cputable.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index 0b9c913..03c862b 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -711,6 +711,8 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.cpu_setup		= __setup_cpu_750,
 		.machine_check		= machine_check_generic,
 		.platform		= "ppc750",
+		.oprofile_cpu_type      = "ppc/750",
+		.oprofile_type		= PPC_OPROFILE_G4,
 	},
 	{	/* 745/755 */
 		.pvr_mask		= 0xfffff000,
