Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbZBUB7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbZBUB7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 20:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbZBUB6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 20:58:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46187 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbZBUB6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 20:58:52 -0500
Date: Sat, 21 Feb 2009 01:58:47 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: davej@codemonkey.org.uk
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: [PATCH] cpufreq: Make cpufreq-nforce2 less obnoxious
Message-ID: <20090221015847.GA12028@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not owning an nforce2 is a sign of good taste, not an error.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

diff --git a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
index 965ea52..36090cc 100644
--- a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
+++ b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
@@ -420,7 +420,7 @@ static int __init nforce2_init(void)
 
 	/* detect chipset */
 	if (nforce2_detect_chipset()) {
-		printk(KERN_ERR "cpufreq: No nForce2 chipset.\n");
+		printk(KERN_INFO "cpufreq: No nForce2 chipset.\n");
 		return -ENODEV;
 	}
 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
