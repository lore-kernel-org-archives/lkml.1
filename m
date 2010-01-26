Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842Ab0A0AHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0A0AHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041Ab0A0AHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:07:25 -0500
Received: from kroah.org ([198.145.64.141]:35086 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab0AZXm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:42:59 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:21 2010
Message-Id: <20100126233921.631156799@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ajit Khaparde <ajitk@serverengines.com>,
       "David S. Miller" <davem@davemloft.net>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [06/98] be2net: Add the new PCI IDs to PCI_DEVICE_TABLE.
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ajit Khaparde <ajitk@serverengines.com>

commit 59fd5d87a4243a992f3a3e69f3627cf4c509608e upstream.

This patch adds the PCI IDs for the next generation chip to the
PCI_DEVICE_ID table.

Signed-off-by: Ajit Khaparde <ajitk@serverengines.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/benet/be_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/benet/be_main.c
+++ b/drivers/net/benet/be_main.c
@@ -31,8 +31,10 @@ MODULE_PARM_DESC(rx_frag_size, "Size of 
 
 static DEFINE_PCI_DEVICE_TABLE(be_dev_ids) = {
 	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID1) },
+	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID2) },
 	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID1) },
 	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID2) },
+	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID3) },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, be_dev_ids);


