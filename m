Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbZCRMHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbZCRMHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZCRMHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:07:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:41211 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbZCRMHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:07:32 -0400
Subject: [PATCH -tip] x86: cpu/mttr/cleanup.c fix compilation warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Mar 2009 17:36:55 +0530
Message-Id: <1237378015.13488.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] x86: cpu/mttr/cleanup.c fix compilation warning

arch/x86/kernel/cpu/mtrr/cleanup.c:197: warning: format ‘%d’ expects type ‘int’, but argument 2 has type ‘long unsigned int’

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index f4f89fb..ce0fe4b 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -160,8 +160,9 @@ x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
 		       unsigned long extra_remove_base,
 		       unsigned long extra_remove_size)
 {
-	unsigned long i, base, size;
+	unsigned long base, size;
 	mtrr_type type;
+	int i;
 
 	for (i = 0; i < num_var_ranges; i++) {
 		type = range_state[i].type;
-- 
1.6.0.6



