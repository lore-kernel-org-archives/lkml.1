Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbXKAVyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbXKAVyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 17:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbXKAVyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:54:13 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:58070 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753621AbXKAVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:54:12 -0400
Date: Thu, 1 Nov 2007 22:53:48 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Josh Logan <joshtlogan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk>,
       Edward Hsu <edward_hsu@realtek.com.tw>, linux-kernel@vger.kernel.org
Subject: Re: Abit F-190HD Onboard rlt8169 Ethernet Controller
Message-ID: <20071101215348.GA17449@electric-eye.fr.zoreil.com>
References: <20071029061532.5d10dfc6@snowcone> <20071029083333.18a4dab7@the-village.bc.nu> <4729FC36.3040000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4729FC36.3040000@gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Logan <joshtlogan@gmail.com> :
[...]
> I have had this board for a few months as well and I have needed to 
> patch the driver to use 0x0001 as well.

Ok.

Can people give the patch below a try before I submit it to Jeff ?

From: Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk>
Date: Thu, 1 Nov 2007 22:48:15 +0100
Subject: [PATCH] r8169: add PCI ID for the 8168 in the Abit Fatal1ty F-190HD motherboard

Signed-off-by: Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk>
Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Edward Hsu <edward_hsu@realtek.com.tw>
---
 drivers/net/r8169.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index b94fa7e..702334e 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -171,6 +171,8 @@ static struct pci_device_id rtl8169_pci_tbl[] = {
 	{ PCI_DEVICE(0x16ec,			0x0116), 0, 0, RTL_CFG_0 },
 	{ PCI_VENDOR_ID_LINKSYS,		0x1032,
 		PCI_ANY_ID, 0x0024, 0, 0, RTL_CFG_0 },
+	{ 0x0001,				0x8168,
+		PCI_ANY_ID, 0x2410, 0, 0, RTL_CFG_2 },
 	{0,},
 };
 
-- 
1.5.3.3

