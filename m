Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYGRMWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYGRMWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758117AbYGRMWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:22:05 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:29862 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851AbYGRMWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:22:04 -0400
Message-Id: <4880A721.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 13:22:25 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <ketuzsezr@darnok.org>, <pjones@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] iscsi_ibft_find: fix modpost warning
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exporting __init functions is wrong.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/firmware/iscsi_ibft_find.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.26/drivers/firmware/iscsi_ibft_find.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-firmware-iscsi-modpost-warning/drivers/firmware/iscsi_ibft_find.c	2008-07-17 14:45:12.000000000 +0200
@@ -81,4 +81,3 @@ void __init reserve_ibft_region(void)
 	if (ibft_addr)
 		reserve_bootmem(pos, PAGE_ALIGN(len), BOOTMEM_DEFAULT);
 }
-EXPORT_SYMBOL_GPL(reserve_ibft_region);



