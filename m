Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbXKUIR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbXKUIR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 03:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbXKUIRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 03:17:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbXKUIRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 03:17:48 -0500
Date: Wed, 21 Nov 2007 17:17:22 +0900 (JST)
Message-Id: <20071121.171722.155742542.jet@gyve.org>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [patch] remove description for non existing parameter in
 generic_set_mtrr
From: Masatake YAMATO <jet@gyve.org>
X-Mailer: Mew version 5.2 on Emacs 22.1.50 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

`do_safe' parameter is not in generic_set_mtrr but explained.
Maybe someone forgot removing.


Signed-off-by: Masatake YAMATO <jet@gyve.org>

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 992f08d..e0c0676 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -417,8 +417,6 @@ static void generic_set_mtrr(unsigned int reg, unsigned long base,
     <base> The base address of the region.
     <size> The size of the region. If this is 0 the region is disabled.
     <type> The type of the region.
-    <do_safe> If TRUE, do the change safely. If FALSE, safety measures should
-    be done externally.
     [RETURNS] Nothing.
 */
 {
