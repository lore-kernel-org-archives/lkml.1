Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934264Ab0BYW2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:28:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:40053 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934167Ab0BYW2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:28:04 -0500
Date: Thu, 25 Feb 2010 22:27:39 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <4B858E89.7040807@kernel.org>
References: <4B858E89.7040807@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, pci: Exclude Moorestown PCI code if CONFIG_X86_MRST=n
Message-ID: <tip-722a639fd2cec44501c04ae32af57fd822c5a2d5@git.kernel.org>
Git-Commit-ID: 722a639fd2cec44501c04ae32af57fd822c5a2d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 22:27:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  722a639fd2cec44501c04ae32af57fd822c5a2d5
Gitweb:     http://git.kernel.org/tip/722a639fd2cec44501c04ae32af57fd822c5a2d5
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 24 Feb 2010 12:39:37 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 25 Feb 2010 14:26:43 -0800

x86, pci: Exclude Moorestown PCI code if CONFIG_X86_MRST=n

If we don't have any Moorestown CPU support compiled in, we don't need
the Moorestown PCI support either.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4B858E89.7040807@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/pci/Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 4753ebc..56caf2a 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -13,7 +13,9 @@ obj-$(CONFIG_X86_VISWS)		+= visws.o
 
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 
-obj-y				+= common.o early.o mrst.o
+obj-$(CONFIG_X86_MRST)		+= mrst.o
+
+obj-y				+= common.o early.o
 obj-y				+= amd_bus.o
 obj-$(CONFIG_X86_64)		+= bus_numa.o
 
