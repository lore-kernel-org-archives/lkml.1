Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbZFEIFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbZFEIFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZFEIFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:19 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37444 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbZFEIFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:16 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 01/62] Blackfin: add comment for anomaly 05000171 to init code
Date: Fri,  5 Jun 2009 04:04:10 -0400
Message-Id: <1244189111-19639-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/mach-common/ints-priority.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index a7d7b2d..3498a90 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -1116,6 +1116,9 @@ int __init init_arch_irq(void)
 	    IMASK_IVG14 | IMASK_IVG13 | IMASK_IVG12 | IMASK_IVG11 |
 	    IMASK_IVG10 | IMASK_IVG9 | IMASK_IVG8 | IMASK_IVG7 | IMASK_IVGHW;
 
+	/* This implicitly covers ANOMALY_05000171
+	 * Boot-ROM code modifies SICA_IWRx wakeup registers
+	 */
 #ifdef SIC_IWR0
 	bfin_write_SIC_IWR0(IWR_DISABLE_ALL);
 # ifdef SIC_IWR1
-- 
1.6.3.1

