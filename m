Return-Path: <linux-kernel-owner+w=401wt.eu-S965524AbXG0Xp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524AbXG0Xp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965162AbXG0XpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:45:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965148AbXG0XpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:45:13 -0400
Date: Fri, 27 Jul 2007 19:43:17 -0400
From: Bill Nottingham <notting@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] remove gratuitous space in airo module description
Message-ID: <20070727234317.GA3595@nostromo.devel.redhat.com>
Mail-Followup-To: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the modinfo looks like:

description:    Support for Cisco/Aironet 802.11 wireless ethernet                    cards.  Direct support for ISA/PCI/MPI cards and support               for PCMCIA when used with airo_cs.

Arguably, it should be cut at the end of the first sentence. 
This at least makes it somewhat more legible.

diff -up linux-2.6.22.x86_64/drivers/net/wireless/airo.c.foo linux-2.6.22.x86_64/drivers/net/wireless/airo.c
--- linux-2.6.22.x86_64/drivers/net/wireless/airo.c.foo	2007-07-27 19:03:59.000000000 -0400
+++ linux-2.6.22.x86_64/drivers/net/wireless/airo.c	2007-07-27 19:04:15.000000000 -0400
@@ -241,8 +241,8 @@ static int proc_perm = 0644;
 
 MODULE_AUTHOR("Benjamin Reed");
 MODULE_DESCRIPTION("Support for Cisco/Aironet 802.11 wireless ethernet \
-                   cards.  Direct support for ISA/PCI/MPI cards and support \
-		   for PCMCIA when used with airo_cs.");
+cards.  Direct support for ISA/PCI/MPI cards and support \
+for PCMCIA when used with airo_cs.");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_SUPPORTED_DEVICE("Aironet 4500, 4800 and Cisco 340/350");
 module_param_array(io, int, NULL, 0);

Signed-off-by: Bill Nottingham <notting@redhat.com>

Bill
