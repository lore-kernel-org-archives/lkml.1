Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbXLRCmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbXLRCmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 21:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764187AbXLRCjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 21:39:48 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:35874 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763909AbXLRCjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 21:39:47 -0500
Date: Mon, 17 Dec 2007 21:39:28 -0500
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [PATCH 7/7] Makefile
In-reply-to: <20071218023913.8530.46661.stgit@terra.home>
To: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-id: <20071218023928.8530.25171.stgit@terra.home>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071218023913.8530.46661.stgit@terra.home>
User-Agent: StGIT/0.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
---

 Makefile |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/Makefile b/Makefile
index c1825aa..15ada3f 100644
--- a/Makefile
+++ b/Makefile
@@ -35,6 +35,9 @@ MAKEFLAGS += -rR --no-print-directory
 # To put more focus on warnings, be less verbose as default
 # Use 'make V=1' to see the full commands
 
+ARCH=powerpc
+CROSS_COMPILE=powerpc-603e-linux-gnu-
+
 ifdef V
   ifeq ("$(origin V)", "command line")
     KBUILD_VERBOSE = $(V)

