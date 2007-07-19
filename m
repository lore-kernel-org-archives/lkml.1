Return-Path: <linux-kernel-owner+w=401wt.eu-S937973AbXGSKQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937973AbXGSKQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761276AbXGSJzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:51 -0400
Received: from ns.suse.de ([195.135.220.2]:35410 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879AbXGSJza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:30 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [37/58] x86_64: remove unused variable maxcpus
Message-Id: <20070719095523.44B0314E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
.. and adjust documentation to properly reflect options that are
x86-64 specific.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 Documentation/x86_64/boot-options.txt |    6 ------
 arch/x86_64/kernel/mpparse.c          |    1 -
 2 files changed, 7 deletions(-)

Index: linux/Documentation/x86_64/boot-options.txt
===================================================================
--- linux.orig/Documentation/x86_64/boot-options.txt
+++ linux/Documentation/x86_64/boot-options.txt
@@ -134,12 +134,6 @@ Non Executable Mappings
 
 SMP
 
-  nosmp	Only use a single CPU
-
-  maxcpus=NUMBER only use upto NUMBER CPUs
-
-  cpumask=MASK   only use cpus with bits set in mask
-
   additional_cpus=NUM Allow NUM more CPUs for hotplug
 		 (defaults are specified by the BIOS, see Documentation/x86_64/cpu-hotplug-spec)
 
Index: linux/arch/x86_64/kernel/mpparse.c
===================================================================
--- linux.orig/arch/x86_64/kernel/mpparse.c
+++ linux/arch/x86_64/kernel/mpparse.c
@@ -32,7 +32,6 @@
 
 /* Have we found an MP table */
 int smp_found_config;
-unsigned int __initdata maxcpus = NR_CPUS;
 
 /*
  * Various Linux-internal data structures created from the
