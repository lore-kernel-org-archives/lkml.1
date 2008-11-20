Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYKTLcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYKTLcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbYKTLbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:31:01 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47361 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755370AbYKTLbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:31:00 -0500
Subject: [PATCH 2.6.28-rc5 05/11] kmemleak: Add support for i386
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 20 Nov 2008 11:30:56 +0000
Message-ID: <20081120113056.16607.20723.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.286.g8983
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2008 11:30:56.0993 (UTC) FILETIME=[7498DD10:01C94B03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the kmemleak-related entries to the vmlinux.lds.S
linker script.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/x86/kernel/vmlinux_32.lds.S |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index a9b8560..b5d2b49 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -62,6 +62,7 @@ SECTIONS
 
   /* writeable */
   . = ALIGN(PAGE_SIZE);
+  _sdata = .;			/* Start of data section */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
 	DATA_DATA
 	CONSTRUCTORS

