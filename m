Return-Path: <linux-kernel-owner+w=401wt.eu-S1763929AbYBOIRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763929AbYBOIRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 03:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYBOIRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 03:17:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbYBOIRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 03:17:41 -0500
Date: Fri, 15 Feb 2008 03:17:36 -0500
From: Chris Snook <csnook@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] make LKDTM depend on BLOCK
Message-ID: <20080215081736.GA22933@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Make LKDTM depend on BLOCK to prevent build failures with certain configs.

Signed-off-by: Chris Snook <csnook@redhat.com>

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a370fe8..24b327c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -524,6 +524,7 @@ config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
 	depends on DEBUG_KERNEL
 	depends on KPROBES
+	depends on BLOCK
 	default n
 	help
 	This module enables testing of the different dumping mechanisms by
