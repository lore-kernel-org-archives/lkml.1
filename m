Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbZKDRdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbZKDRdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932149AbZKDRdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:33:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbZKDRc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:32:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=GyPx/5alVUIiqWE+uEH/QhUGfM1oVH5ndfTAh/k+hhUjGwjrlavuCOlC85IuNvr2N8
         h0gZR1mzH6pQ82ymWh4M+u48qYrpgH4F+iSBQ9LXGVmQEMAi5VBLuBEPYZWwHcKLtVC3
         S8O7x68o6/+uMtz2CL2Qjqh+QIy3Z1RaviWk8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:32:40 +0100
Message-Id: <20091104173239.28463.22571.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/41] rt2800pci: fix comment about IV/EIV fields
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800pci: fix comment about IV/EIV fields

The bit tested by hardware is TXD_W3_WIV and its value
equals the negated value of ENTRY_TXD_ENCRYPT_IV bit.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -2206,8 +2206,8 @@ static void rt2800pci_write_tx_desc(stru
 
 	/*
 	 * Always write 0 to IV/EIV fields, hardware will insert the IV
-	 * from the IVEIV register when ENTRY_TXD_ENCRYPT_IV is set to 0.
-	 * When ENTRY_TXD_ENCRYPT_IV is set to 1 it will use the IV data
+	 * from the IVEIV register when TXD_W3_WIV is set to 0.
+	 * When TXD_W3_WIV is set to 1 it will use the IV data
 	 * from the descriptor. The TXWI_W1_WIRELESS_CLI_ID indicates which
 	 * crypto entry in the registers should be used to encrypt the frame.
 	 */
