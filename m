Return-Path: <linux-kernel-owner+w=401wt.eu-S965687AbXECJab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965687AbXECJab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965706AbXECJaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:30:30 -0400
Received: from iona.labri.fr ([147.210.8.143]:34710 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965687AbXECJa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:30:26 -0400
Date: Thu, 3 May 2007 11:30:25 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, akpm@google.com, alan@redhat.com
Subject: [PATCH] Fix pata_qdi.c probe code
Message-ID: <20070503093025.GB3595@implementation.labri.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, akpm@google.com, alan@redhat.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

There is a small typo in the probe code of pata_qdi.c, here is a patch.

Samuel

--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch

diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index 27685ce..fb8c9e1 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -375,7 +375,7 @@ static __init int qdi_init(void)
 				res = inb(port + 3);
 				if (res & 1) {
 					/* Single channel mode */
-					if (qdi_init_one(port, 6580, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04))
+					if (qdi_init_one(port, 6580, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04) == 0)
 						ct++;
 				} else {
 					/* Dual channel mode */

--tThc/1wpZn/ma/RB--
