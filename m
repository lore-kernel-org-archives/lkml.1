Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZCJQrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZCJQrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbZCJQnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:50 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34638 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbZCJQnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:42 -0400
Message-Id: <39a78d02ec371f1ac1ce1e8c132f73c9d3aa69fa.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:49:19 +0000
Subject: [PATCH 28/31] x86: Auto-load cpuid module when device opened.
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpuid module is missing the char-major-203-* alias that would cause
it to be auto-loaded when a device of that type is opened.  This patch
adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 arch/x86/kernel/cpuid.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 2ac1f0c..8211f3a 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -237,3 +237,4 @@ module_exit(cpuid_exit);
 MODULE_AUTHOR("H. Peter Anvin <hpa@zytor.com>");
 MODULE_DESCRIPTION("x86 generic CPUID driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(CPUID_MAJOR);
-- 
1.6.0.5

