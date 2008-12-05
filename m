Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYLELmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYLELmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 06:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYLELmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 06:42:24 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:23768 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbYLELmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 06:42:23 -0500
Message-ID: <4939139C.8090806@msgid.tls.msk.ru>
Date: Fri, 05 Dec 2008 14:42:20 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [trivial] fix missing space in printk
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------030804070701070903010902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030804070701070903010902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Just come across this when booting on an old hw..
Looks somewhat ugly, that single missing space ;)

And oh,

Signed-Off-By: Michael Tokarev <mjt@tls.msk.ru>

;)

/mjt

--------------030804070701070903010902
Content-Type: text/x-patch;
 name="notlistedbythebios.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="notlistedbythebios.diff"

--- a/arch/x86/kernel/smpboot.c	2008-10-10 02:13:53.000000000 +0400
+++ b/arch/x86/kernel/smpboot.c	2008-12-05 14:39:29.608353301 +0300
@@ -1084,7 +1084,7 @@ static int __init smp_sanity_check(unsig
 #endif
 
 	if (!physid_isset(hard_smp_processor_id(), phys_cpu_present_map)) {
-		printk(KERN_WARNING "weird, boot CPU (#%d) not listed"
+		printk(KERN_WARNING "weird, boot CPU (#%d) not listed "
 				    "by the BIOS.\n", hard_smp_processor_id());
 		physid_set(hard_smp_processor_id(), phys_cpu_present_map);
 	}

--------------030804070701070903010902--
