Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbZLRTiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbZLRTiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbZLRTge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:36:34 -0500
Received: from kroah.org ([198.145.64.141]:47435 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbZLRTga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:36:30 -0500
Subject: patch staging-slicoss-convert-to-netdev_tx_t.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Fri, 18 Dec 2009 11:33:52 -0800
In-Reply-To: <20091218075107.GA4479@coldcone>
Message-ID: <12611648322694@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: staging: slicoss Convert to netdev_tx_t

to my gregkh-2.6 tree.  Its filename is

    staging-slicoss-convert-to-netdev_tx_t.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From kirjanov@gmail.com  Fri Dec 18 10:32:34 2009
From: "Denis Kirjanov <kirjanov@gmail.com" <kirjanov@gmail.com>
Date: Fri, 18 Dec 2009 10:51:07 +0300
Subject: staging: slicoss Convert to netdev_tx_t
To: gregkh@suse.de, liodot@gmail.com, charrer@alacritech.com
Cc: devel@linuxdriverproject.org
Message-ID: <20091218075107.GA4479@coldcone>
Content-Disposition: inline


Convert to netdev_tx_t.

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/staging/slicoss/slicoss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -101,7 +101,7 @@ static struct net_device_stats *slic_get
 static int slic_entry_open(struct net_device *dev);
 static int slic_entry_halt(struct net_device *dev);
 static int slic_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
-static int slic_xmit_start(struct sk_buff *skb, struct net_device *dev);
+static netdev_tx_t slic_xmit_start(struct sk_buff *skb, struct net_device *dev);
 static void slic_xmit_fail(struct adapter *adapter, struct sk_buff *skb,
 			   void *cmd, u32 skbtype, u32 status);
 static void slic_config_pci(struct pci_dev *pcidev);
@@ -784,7 +784,7 @@ static void slic_xmit_build_request(stru
 
 #define NORMAL_ETHFRAME     0
 
-static int slic_xmit_start(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t slic_xmit_start(struct sk_buff *skb, struct net_device *dev)
 {
 	struct sliccard *card;
 	struct adapter *adapter = (struct adapter *)netdev_priv(dev);

