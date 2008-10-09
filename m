Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbYJISzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbYJISzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbYJISzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:55:07 -0400
Received: from 0x55512ece.adsl.cybercity.dk ([85.81.46.206]:23017 "EHLO
	sko.w0.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbYJISzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:55:06 -0400
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Oct 2008 14:55:06 EDT
Date: Thu, 9 Oct 2008 20:47:24 +0200 (CEST)
From: Hans Schou <linux@schou.dk>
X-X-Sender: linux@sko.w0.dk
To: linux-kernel@vger.kernel.org
Subject: [PATCH] More informative about unknown CPU
Message-ID: <Pine.LNX.4.64.0810092014190.7473@sko.w0.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi

Write the name of the unknown vendor_id to output instead of just "file 
not found".

Tag changed to 'vendor_id' as used in /proc/cpuinfo

Signed-off-by: Hans Schou <linux@schou.dk>


--- linux.trees.git/arch/x86/kernel/cpu/common.c.orig   2008-10-09 17:33:29.000000000 +0200
+++ linux.trees.git/arch/x86/kernel/cpu/common.c        2008-10-09 17:33:59.000000000 +0200
@@ -413,7 +413,7 @@ static void __cpuinit get_cpu_vendor(str

         if (!printed) {
                 printed++;
-               printk(KERN_ERR "CPU: Vendor unknown, using generic init.\n");
+               printk(KERN_ERR "CPU: vendor_id '%s' unknown, using generic init.\n", v);
                 printk(KERN_ERR "CPU: Your system may be unstable.\n");
         }

