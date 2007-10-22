Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbXJVCo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbXJVCo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 22:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbXJVCot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 22:44:49 -0400
Received: from daimi.au.dk ([130.225.16.1]:47631 "EHLO daimi.au.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbXJVCos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 22:44:48 -0400
To: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: [PATCH] Include kernel/Kconfig.instrumentation in i386 and x86-64 Kconfig.
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 22 Oct 2007 04:44:40 +0200
Message-ID: <ye83aw3q353.fsf@camel08.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To get the kernel compiled with instrumentation turned on, I had to
apply the patch below. 

It looks to me like x86 and x86-64 were just left out when the
Kconfig.instrumentation file was created, but maybe I am
misunderstanding how the x86/x86-64 merge is supposed to work.

Soren

Signed-off-by: Soren Sandmann <sandmann@redhat.com>
---
 arch/i386/Kconfig   |    2 ++
 arch/x86_64/Kconfig |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index f6e44fc..b54a82d 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -1266,6 +1266,8 @@ source "crypto/Kconfig"
 
 source "lib/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 #
 # Use the generic interrupt handling code in kernel/irq/:
 #
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index aab25f3..a68865b 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -808,3 +808,5 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
+
+source "kernel/Kconfig.instrumentation"
-- 
1.5.2.4

