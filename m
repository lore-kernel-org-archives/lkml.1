Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZFDMls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZFDMls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZFDMlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:41:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:38699 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbZFDMlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:41:39 -0400
Subject: [PATCH 2/6] headers_check fix: ia64, fpswa.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org
In-Reply-To: <1244118476.5172.29.camel@ht.satnam>
References: <1244118232.5172.26.camel@ht.satnam>
	 <1244118476.5172.29.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 17:59:59 +0530
Message-Id: <1244118599.5172.31.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make headers_check' warning:

  usr/include/asm-ia64/fpswa.h:71: extern's make no sense in userspace

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/ia64/include/asm/fpswa.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/fpswa.h b/arch/ia64/include/asm/fpswa.h
index 62edfce..797b064 100644
--- a/arch/ia64/include/asm/fpswa.h
+++ b/arch/ia64/include/asm/fpswa.h
@@ -68,6 +68,7 @@ typedef struct {
 	efi_fpswa_t	 fpswa;
 } fpswa_interface_t;
 
+#ifdef __KERNEL__
 extern fpswa_interface_t *fpswa_interface;
-
+#endif
 #endif /* _ASM_IA64_FPSWA_H */
-- 
1.6.0.6



