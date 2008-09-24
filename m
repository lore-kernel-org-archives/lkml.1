Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbYIXSfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbYIXSfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYIXSfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:35:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40452 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbYIXSfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:35:18 -0400
Date: Wed, 24 Sep 2008 14:35:17 -0400
From: Bill Nottingham <notting@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: be less annoying on boot
Message-ID: <20080924183517.GA24209@nostromo.devel.redhat.com>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As long as we're printing mostly useless messages on every boot regardless
of debug level, make them 5% more amusing.

Signed-off-by: Bill Nottingham <notting@redhat.com>

(Alternatively, just remove them, of course...)

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kernel.patch"

diff -up linux-2.6.26.noarch/arch/x86/kernel/head64.c.foo linux-2.6.26.noarch/arch/x86/kernel/head64.c
--- linux-2.6.26.noarch/arch/x86/kernel/head64.c.foo	2008-09-24 14:31:27.000000000 -0400
+++ linux-2.6.26.noarch/arch/x86/kernel/head64.c	2008-09-24 14:31:33.000000000 -0400
@@ -112,7 +112,7 @@ void __init x86_64_start_kernel(char * r
 
 	x86_64_init_pda();
 
-	early_printk("Kernel really alive\n");
+	early_printk("Kernel really alive! It's alive! IT'S ALIIIIIIIIIVE!\n");
 
 	x86_64_start_reservations(real_mode_data);
 }

--k1lZvvs/B4yU6o8G--
