Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbXGCPHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbXGCPHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758420AbXGCPHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:07:03 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40500 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757884AbXGCPHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:07:01 -0400
Date: Tue, 3 Jul 2007 16:12:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: [PATCH] libata: Allow modular builds of drivers using
 ata_dumb_qc_prep
Message-ID: <20070703161244.008fc5aa@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/libata-core.c linux-2.6.22-rc6-mm1/drivers/ata/libata-core.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/libata-core.c	2007-07-02 20:50:11.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/ata/libata-core.c	2007-07-02 21:36:20.000000000 +0100
@@ -6842,6 +6976,7 @@
 EXPORT_SYMBOL_GPL(ata_data_xfer);
 EXPORT_SYMBOL_GPL(ata_data_xfer_noirq);
 EXPORT_SYMBOL_GPL(ata_qc_prep);
+EXPORT_SYMBOL_GPL(ata_dumb_qc_prep);
 EXPORT_SYMBOL_GPL(ata_noop_qc_prep);
 EXPORT_SYMBOL_GPL(ata_bmdma_setup);
 EXPORT_SYMBOL_GPL(ata_bmdma_start);
