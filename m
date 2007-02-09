Return-Path: <linux-kernel-owner+w=401wt.eu-S1946539AbXBIPeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946539AbXBIPeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946536AbXBIPeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:34:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2693 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946539AbXBIPeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=AcSO10jOU1GWRq3S17dW8nit8SGqocrQZOveVvZCjDt4YPv8uClNe75oxcp0tRxDwFd0pZS5vGxbbkAU01Mgl4zpzFj0iEFN7SboMJkZHmBGXPzQStxpTF9/RGrEwsGPPxTTwg5KAxzMHlNZh9Zwhe5gmeoK5EG3n5prUYkSZ2w=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, spyro@f2s.com
Subject: [PATCH 02/34] __initdata cleanup - arm
Date: Fri, 9 Feb 2007 17:13:52 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091713.53050.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/arm/kernel/setup.c linux-2.6.20-rc6-mm3/arch/arm/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/arm/kernel/setup.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/arm/kernel/setup.c	2007-01-31 22:19:30.000000000 +0200
@@ -106,7 +106,7 @@ unsigned long phys_initrd_size __initdat
 static struct meminfo meminfo __initdata = { 0, };
 static const char *cpu_name;
 static const char *machine_name;
-static char __initdata command_line[COMMAND_LINE_SIZE];
+static char __initdata command_line[COMMAND_LINE_SIZE] = "";
 
 static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
 static union { char c[4]; unsigned long l; } endian_test __initdata = { { 'l', '?', '?', 'b' } };
@@ -753,7 +753,7 @@ static struct init_tags {
 	{ 0, ATAG_NONE }
 };
 
-static void (*init_machine)(void) __initdata;
+static void (*init_machine)(void) __initdata = NULL;
 
 static int __init customize_machine(void)
 {
diff -urNp linux-2.6.20-rc6-mm3.org/arch/arm26/kernel/setup.c linux-2.6.20-rc6-mm3/arch/arm26/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/arm26/kernel/setup.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/arm26/kernel/setup.c	2007-01-31 22:19:30.000000000 +0200
@@ -80,7 +80,7 @@ unsigned long phys_initrd_size __initdat
 static struct meminfo meminfo __initdata = { 0, };
 static struct proc_info_item proc_info;
 static const char *machine_name;
-static char __initdata command_line[COMMAND_LINE_SIZE];
+static char __initdata command_line[COMMAND_LINE_SIZE] = "";
 
 static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
 
