Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbZELPsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbZELPsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757895AbZELPrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:47:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:51107 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758052AbZELPri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:47:38 -0400
Subject: [PATCH 2/10 -tip] x86: get_model_name() user of X86_FEATURE_PNAME
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
In-Reply-To: <1242142623.2547.13.camel@ht.satnam>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 12 May 2009 21:08:12 +0530
Message-Id: <1242142692.2547.15.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 542684c..3994feb 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -352,7 +352,7 @@ static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	unsigned int *v;
 	char *p, *q;
 
-	if (c->extended_cpuid_level < 0x80000004)
+	if (!cpu_has(c, X86_FEATURE_PNAME))
 		return;
 
 	v = (unsigned int *)c->x86_model_id;
-- 
1.6.0.6



