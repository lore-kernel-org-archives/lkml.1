Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbZFIKSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbZFIKSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760109AbZFIKQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:16:31 -0400
Received: from kroah.org ([198.145.64.141]:59869 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760131AbZFIKQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:16:30 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:55 2009
Message-Id: <20090609094055.307662062@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jay Vosburgh <fubar@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 14/87] bonding: Remove debug printk
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=bonding-remove-debug-printk.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jay Vosburgh <fubar@us.ibm.com>

[ Upstream commit 2690f8d62e98779c71625dba9a0fd525d8b2263d ]

	Remove debug printk I accidently left in as part of commit:

commit 6146b1a4da98377e4abddc91ba5856bef8f23f1e
Author: Jay Vosburgh <fubar@us.ibm.com>
Date:   Tue Nov 4 17:51:15 2008 -0800

    bonding: Fix ALB mode to balance traffic on VLANs

	Reported by Duncan Gibb <duncan.gibb@siriusit.co.uk>

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/bonding/bond_alb.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -370,8 +370,6 @@ static int rlb_arp_recv(struct sk_buff *
 
 	if (arp->op_code == htons(ARPOP_REPLY)) {
 		/* update rx hash table for this ARP */
-		printk("rar: update orig %s bond_dev %s\n", orig_dev->name,
-		       bond_dev->name);
 		bond = netdev_priv(bond_dev);
 		rlb_update_entry_from_arp(bond, arp);
 		pr_debug("Server received an ARP Reply from client\n");


