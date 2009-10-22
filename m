Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbZJVWMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbZJVWMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbZJVWMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:12:39 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:51253 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbZJVWMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:12:36 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/B1tLG7ayrXWASMDzebASk
Subject: [PATCH 07/10] omap2: Fix console serial port number for n8x0
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 22 Oct 2009 15:12:39 -0700
Message-ID: <20091022221239.27408.80500.stgit@localhost>
In-Reply-To: <20091022221013.27408.443.stgit@localhost>
References: <20091022221013.27408.443.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent changes omap serial ports match the physical
numbering like they should. Fix the kernel CMDLINE accordingly
so console works.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/configs/n8x0_defconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/configs/n8x0_defconfig b/arch/arm/configs/n8x0_defconfig
index 8da75de..264f52b 100644
--- a/arch/arm/configs/n8x0_defconfig
+++ b/arch/arm/configs/n8x0_defconfig
@@ -304,7 +304,7 @@ CONFIG_ALIGNMENT_TRAP=y
 CONFIG_ZBOOT_ROM_TEXT=0x10C08000
 CONFIG_ZBOOT_ROM_BSS=0x10200000
 # CONFIG_ZBOOT_ROM is not set
-CONFIG_CMDLINE="root=1f03 rootfstype=jffs2 console=ttyS0,115200n8"
+CONFIG_CMDLINE="root=1f03 rootfstype=jffs2 console=ttyS2,115200n8"
 # CONFIG_XIP_KERNEL is not set
 # CONFIG_KEXEC is not set
 

