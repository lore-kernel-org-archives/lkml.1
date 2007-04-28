Return-Path: <linux-kernel-owner+w=401wt.eu-S1163367AbXD1SA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163367AbXD1SA4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163320AbXD1RxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:10 -0400
Received: from ns1.suse.de ([195.135.220.2]:34435 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163311AbXD1Rww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:52 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [26/35] x86_64: Correct max number of CPUs in Kconfig
Message-Id: <20070428175251.A5843151D1@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Pointed out by Adrian Bunk

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/Kconfig
===================================================================
--- linux.orig/arch/x86_64/Kconfig
+++ linux/arch/x86_64/Kconfig
@@ -415,13 +415,13 @@ config OUT_OF_LINE_PFN_TO_PAGE
 	depends on DISCONTIGMEM
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-256)"
+	int "Maximum number of CPUs (2-255)"
 	range 2 255
 	depends on SMP
 	default "8"
 	help
 	  This allows you to specify the maximum number of CPUs which this
-	  kernel will support. Current maximum is 256 CPUs due to
+	  kernel will support. Current maximum is 255 CPUs due to
 	  APIC addressing limits. Less depending on the hardware.
 
 	  This is purely to save memory - each supported CPU requires
