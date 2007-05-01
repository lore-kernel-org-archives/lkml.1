Return-Path: <linux-kernel-owner+w=401wt.eu-S1946499AbXEAD6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946499AbXEAD6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946503AbXEAD6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:58:35 -0400
Received: from ns2.suse.de ([195.135.220.15]:49000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946499AbXEAD6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:30 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: ebiederm@xmission.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the 2G/2G split.
Message-Id: <20070501035829.1C93D13CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: ebiederm@xmission.com

When in PAE mode we require that the user kernel divide to be
on a 1G boundary.  The 2G/2G split does not have that property
so require !X86_PAE

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index 1a94a73..80003de 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -570,6 +570,7 @@ choice
 		depends on !HIGHMEM
 		bool "3G/1G user/kernel split (for full 1G low memory)"
 	config VMSPLIT_2G
+		depends on !X86_PAE
 		bool "2G/2G user/kernel split"
 	config VMSPLIT_1G
 		bool "1G/3G user/kernel split"
-- 
1.5.1.1.181.g2de0


