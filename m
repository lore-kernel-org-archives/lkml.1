Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZCJQsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZCJQsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbZCJQnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:51 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34637 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbZCJQnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:42 -0400
Message-Id: <85078680b8c2073119e29e4e6c0a907709c5d022.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:48:36 +0000
Subject: [PATCH 27/31] x86: Auto-load msr module when device opened.
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The msr module is missing the char-major-202-* alias that would cause it
to be auto-loaded when a device of that type is opened.  This patch adds
the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 arch/x86/kernel/msr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 7262666..7d2bb98 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -249,3 +249,4 @@ module_exit(msr_exit)
 MODULE_AUTHOR("H. Peter Anvin <hpa@zytor.com>");
 MODULE_DESCRIPTION("x86 generic MSR driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(MSR_MAJOR);
-- 
1.6.0.5

