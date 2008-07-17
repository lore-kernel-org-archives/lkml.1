Return-Path: <linux-kernel-owner+w=401wt.eu-S1760403AbYGQHvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760403AbYGQHvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYGQHvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:51:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbYGQHvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:51:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 6/6] x86: tracehook: CONFIG_HAVE_ARCH_TRACEHOOK
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:45:50 -0700 <20080717074550.EE1E215411D@magilla.localdomain>
References: <20080717074550.EE1E215411D@magilla.localdomain>
X-Zippy-Says: Yow!  Are we laid back yet?
Message-Id: <20080717075030.3AE3B15411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:50:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 arch code has all the prerequisites, so set HAVE_ARCH_TRACEHOOK.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 96e0c2e..dab1735 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -27,6 +27,7 @@ config X86
 	select HAVE_FTRACE
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
+	select HAVE_ARCH_TRACEHOOK
 
 config ARCH_DEFCONFIG
 	string
