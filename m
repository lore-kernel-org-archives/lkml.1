Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbZKTNUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbZKTNUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 08:20:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZKTNUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 08:20:02 -0500
Received: from ns2.fox-it.com ([82.94.91.210]:12268 "EHLO mail2.fox-it.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbZKTNUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 08:20:01 -0500
Date: Fri, 20 Nov 2009 14:20:05 +0100
From: Jasper Spaans <spaans@fox-it.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <trivial@kernel.org>
Subject: [PATCH] [trivial] arch/x86/kernel/apic/apic_flat_64.c: Make
 comment match the code
Message-ID: <20091120132005.GA22676@spaans64.fox.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the comment match the code, this also holds for intel systems,
according to probe_64.c in the same directory.

Signed-off-by: Jasper Spaans <spaans@fox-it.com>
---
 arch/x86/kernel/apic/apic_flat_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index d0c99ab..bd2dc04 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -223,7 +223,7 @@ struct apic apic_flat =  {
 };
 
 /*
- * Physflat mode is used when there are more than 8 CPUs on a AMD system.
+ * Physflat mode is used when there are more than 8 CPUs on a system.
  * We cannot use logical delivery in this case because the mask
  * overflows, so use physical mode.
  */
-- 
1.6.3.3
