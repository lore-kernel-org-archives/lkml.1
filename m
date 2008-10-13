Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbYJMGnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbYJMGnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 02:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYJMGni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 02:43:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:37475 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbYJMGnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 02:43:37 -0400
Message-ID: <48F2ED9F.7020606@kernel.org>
Date: Mon, 13 Oct 2008 15:41:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] block: add BIG FAT WARNING to CONFIG_DEBUG_BLOCK_EXT_DEVT
References: <20081010203043.GA11798@elte.hu> <20081010204015.GA15668@elte.hu> <20081010205642.GA28840@elte.hu> <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org> <48EFF84B.5060108@kernel.org> <20081011071939.GA26465@elte.hu> <20081011140826.GS19428@kernel.dk> <20081011143355.GA6274@elte.hu> <20081011143947.GT19428@kernel.dk> <20081011145823.GA14062@elte.hu> <20081011175818.GY19428@kernel.dk>
In-Reply-To: <20081011175818.GY19428@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Oct 2008 06:43:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_DEBUG_BLOCK_EXT_DEVT can break booting even on some modern
distros.  Add BIG FAT WARNING to keep people at a safe distance.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Okay, w/ or w/o Ingo's change, it would be worthwhile to warn
people more clearly so that we can at least say 'told ya'.  :-)

 lib/Kconfig.debug |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index aa81d28..44e67a1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -652,6 +652,11 @@ config DEBUG_BLOCK_EXT_DEVT
 	depends on BLOCK
 	default n
 	help
+	  BIG FAT WARNING: ENABLING THIS OPTION MIGHT BREAK BOOTING ON
+	  SOME DISTRIBUTIONS.  DO NOT ENABLE THIS UNLESS YOU KNOW WHAT
+	  YOU ARE DOING.  Distros, please enable this and fix whatever
+	  is broken.
+
 	  Conventionally, block device numbers are allocated from
 	  predetermined contiguous area.  However, extended block area
 	  may introduce non-contiguous block device numbers.  This
