Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbYKTLcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbYKTLcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbYKTLbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:31:06 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47369 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755376AbYKTLbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:31:05 -0500
Subject: [PATCH 2.6.28-rc5 06/11] kmemleak: Add support for ARM
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 20 Nov 2008 11:31:02 +0000
Message-ID: <20081120113102.16607.97751.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.286.g8983
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2008 11:31:02.0556 (UTC) FILETIME=[77E9B5C0:01C94B03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the kmemleak-related entries to the vmlinux.lds.S
linker script.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/kernel/vmlinux.lds.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 4898bdc..3cf1d44 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -120,6 +120,7 @@ SECTIONS
 
 	.data : AT(__data_loc) {
 		__data_start = .;	/* address in memory */
+		_sdata = .;
 
 		/*
 		 * first, the init task union, aligned
@@ -171,6 +172,7 @@ SECTIONS
 		__bss_start = .;	/* BSS				*/
 		*(.bss)
 		*(COMMON)
+		__bss_stop = .;
 		_end = .;
 	}
 					/* Stabs debugging sections.	*/

