Return-Path: <linux-kernel-owner+w=401wt.eu-S932450AbXJMOz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbXJMOz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762064AbXJMOm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:57 -0400
Received: from 1wt.eu ([62.212.114.60]:3034 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762053AbXJMOm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:56 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143510.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:52 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Willy Tarreau <w@1wt.eu>, Ayaz Abdulla <aabdulla@nvidia.com>,
       Chuck Ebbert <cebbert@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 30/35] fix realtek phy id in forcedeth
Content-Disposition: inline; filename=0087-fix-realtek-phy-id-in-forcedeth.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit ba685fb2abd71162bea6895a99449c1071b01402 in mainline.

As noticed by Chuck Ebbert, commit c5e3ae8823693b260ce1f217adca8add1bc0b3de
introduced a copy-paste typo, as realtek phy is 0x732 and not 0x1c1. Obvious
fix below suggested by Ayaz Abdulla.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/forcedeth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: 2.6/drivers/net/forcedeth.c
===================================================================
--- 2.6.orig/drivers/net/forcedeth.c
+++ 2.6/drivers/net/forcedeth.c
@@ -554,6 +554,7 @@ union ring_type {
 #define PHY_OUI_MARVELL	0x5043
 #define PHY_OUI_CICADA	0x03f1
 #define PHY_OUI_VITESSE	0x01c1
+#define PHY_OUI_REALTEK	0x0732
 #define PHYID1_OUI_MASK	0x03ff
 #define PHYID1_OUI_SHFT	6
 #define PHYID2_OUI_MASK	0xfc00

-- 
