Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbZKXGO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbZKXGO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 01:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZKXGO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 01:14:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37454 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbZKXGO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 01:14:56 -0500
Date: Tue, 24 Nov 2009 17:14:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?B?IkFuZHLDqSBHb2RkYXJkIFJvc2Ei?= <andre.goddard@gmail.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the trivial tree with the net tree
Message-Id: <20091124171459.88cb0c0d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/net/e1000e/lib.c between commit
3bb99fe226ead584a4db674dab546689f705201f ("e1000e: consolidate two dbug
macros into one simpler one") from the net tree and commit
52692d35d013e221137b2fbe800e3e6776111821 ("tree-wide: fix assorted typos
all over the place") from the trivial tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/e1000e/lib.c
index f690a10,b065ba4..0000000
--- a/drivers/net/e1000e/lib.c
+++ b/drivers/net/e1000e/lib.c
@@@ -563,11 -570,11 +563,11 @@@ s32 e1000e_check_for_serdes_link(struc
  			if (rxcw & E1000_RXCW_SYNCH) {
  				if (!(rxcw & E1000_RXCW_IV)) {
  					mac->serdes_has_link = true;
 -					hw_dbg(hw, "SERDES: Link up - autoneg "
 +					e_dbg("SERDES: Link up - autoneg "
- 					   "completed sucessfully.\n");
+ 					   "completed successfully.\n");
  				} else {
  					mac->serdes_has_link = false;
 -					hw_dbg(hw, "SERDES: Link down - invalid"
 +					e_dbg("SERDES: Link down - invalid"
  					   "codewords detected in autoneg.\n");
  				}
  			} else {
