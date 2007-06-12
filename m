Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbXFLHu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbXFLHu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbXFLHut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:50:49 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:55307 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753733AbXFLHus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:50:48 -0400
Message-Id: <466E6CAB.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 12 Jun 2007 09:51:39 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: [PATCH] x86-64: remove unused variable maxcpus
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

.. and adjust documentation to properly reflect options that are
x86-64 specific.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 Documentation/x86_64/boot-options.txt |    6 ------
 arch/x86_64/kernel/mpparse.c          |    1 -
 2 files changed, 7 deletions(-)

--- linux-2.6.22-rc4/Documentation/x86_64/boot-options.txt	2007-06-11 18:09:13.000000000 +0200
+++ 2.6.22-rc4-x86_64-maxcpus/Documentation/x86_64/boot-options.txt	2007-05-24 17:47:50.000000000 +0200
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
 
--- linux-2.6.22-rc4/arch/x86_64/kernel/mpparse.c	2007-06-11 18:09:18.000000000 +0200
+++ 2.6.22-rc4-x86_64-maxcpus/arch/x86_64/kernel/mpparse.c	2007-05-24 17:44:48.000000000 +0200
@@ -32,7 +32,6 @@
 
 /* Have we found an MP table */
 int smp_found_config;
-unsigned int __initdata maxcpus = NR_CPUS;
 
 /*
  * Various Linux-internal data structures created from the



