Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0BST3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:29:55 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56959 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab0BST3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:29:53 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 7/7] arm/boot/hack: set uImage load address to 0x81000000
To: linux@arm.linux.org.uk, catalin.marinas@arm.com, jeremy.kerr@canonical.com,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: tim.bird@am.sony.com
Date: Fri, 19 Feb 2010 12:29:46 -0700
Message-ID: <20100219192905.15318.30916.stgit@angua>
In-Reply-To: <20100219185953.15318.4850.stgit@angua>
References: <20100219185953.15318.4850.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Total hack.
Don't merge.
This will go away when I fix patch 6/7

g.

---

 arch/arm/boot/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/Makefile b/arch/arm/boot/Makefile
index 4a590f4..9aeea2f 100644
--- a/arch/arm/boot/Makefile
+++ b/arch/arm/boot/Makefile
@@ -67,7 +67,7 @@ quiet_cmd_uimage = UIMAGE  $@
 ifeq ($(CONFIG_ZBOOT_ROM),y)
 $(obj)/uImage: LOADADDR=$(CONFIG_ZBOOT_ROM_TEXT)
 else
-$(obj)/uImage: LOADADDR=$(ZRELADDR)
+$(obj)/uImage: LOADADDR=0x81000000
 endif
 
 ifeq ($(CONFIG_THUMB2_KERNEL),y)

