Return-Path: <linux-kernel-owner+w=401wt.eu-S965381AbXCAQyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965381AbXCAQyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965382AbXCAQyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:54:37 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45869 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965381AbXCAQyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:54:37 -0500
Date: Thu, 1 Mar 2007 17:57:05 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] pata_winbond: set cable type
Message-ID: <20070301175705.6f2a7902@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_winbond.c linux-2.6.21-rc2/drivers/ata/pata_winbond.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/pata_winbond.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/pata_winbond.c	2007-03-01 15:16:12.697846496 +0000
@@ -152,6 +152,7 @@
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
