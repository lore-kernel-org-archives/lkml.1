Return-Path: <linux-kernel-owner+w=401wt.eu-S1946528AbXBIPqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946528AbXBIPqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946532AbXBIPom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:44:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2693 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946544AbXBIPe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nD8NmAlrH5L6o04U+dgS9+6ehtSsU4m7B4r6zUttCa45CeIyk6jdQwGbxTtH1XhxXnDUj+S8jeeXF50u/VQldGxTayqz9NerDjcTb4gPSqS3XlNcqiLkazQzSOUa/JwFBZFLJEDzteVCRE3CSc/XCy47ZR2UElCOtkxn6SMM+x4=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk
Subject: [PATCH 08/34] __initdata cleanup - m32r
Date: Fri, 9 Feb 2007 17:18:59 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091719.00073.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

**NOT TESTED***

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/m32r/kernel/setup.c linux-2.6.20-rc6-mm3/arch/m32r/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/m32r/kernel/setup.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/m32r/kernel/setup.c	2007-01-31 22:19:30.000000000 +0200
@@ -64,7 +64,7 @@ struct screen_info screen_info = {
 
 extern int root_mountflags;
 
-static char __initdata command_line[COMMAND_LINE_SIZE];
+static char __initdata command_line[COMMAND_LINE_SIZE] = "";
 
 static struct resource data_resource = {
 	.name   = "Kernel data",
diff -urNp linux-2.6.20-rc6-mm3.org/arch/m32r/mm/discontig.c linux-2.6.20-rc6-mm3/arch/m32r/mm/discontig.c
--- linux-2.6.20-rc6-mm3.org/arch/m32r/mm/discontig.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/m32r/mm/discontig.c	2007-01-31 22:19:30.000000000 +0200
@@ -20,7 +20,7 @@ extern char _end[];
 
 struct pglist_data *node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(node_data);
-static bootmem_data_t node_bdata[MAX_NUMNODES] __initdata;
+static bootmem_data_t node_bdata[MAX_NUMNODES] __initdata = {{0}};
 
 pg_data_t m32r_node_data[MAX_NUMNODES];
 
