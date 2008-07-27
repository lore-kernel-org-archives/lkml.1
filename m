Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbYG0Gxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbYG0Gxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756959AbYG0GxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:53:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756887AbYG0GxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:53:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Fcc: ~/Mail/linus
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] powerpc: tracehook: CONFIG_HAVE_ARCH_TRACEHOOK
In-Reply-To: Roland McGrath's message of  Saturday, 26 July 2008 23:48:59 -0700 <20080727064859.69692154280@magilla.localdomain>
References: <20080727064859.69692154280@magilla.localdomain>
X-Shopping-List: (1) Hydroelectric reluctant insurgents
   (2) Educated luminous winters
   (3) Illogical yies
   (4) Economical nutrition
Message-Id: <20080727065320.972D9154280@magilla.localdomain>
Date: Sat, 26 Jul 2008 23:53:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The powerpc arch code has all the prerequisites, so set HAVE_ARCH_TRACEHOOK.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index fe88418..587da5e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -117,6 +117,7 @@ config PPC
 	select HAVE_KPROBES
 	select HAVE_ARCH_KGDB
 	select HAVE_KRETPROBES
+	select HAVE_ARCH_TRACEHOOK
 	select HAVE_LMB
 	select HAVE_DMA_ATTRS if PPC64
 	select USE_GENERIC_SMP_HELPERS if SMP
