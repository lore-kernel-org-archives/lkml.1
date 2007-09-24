Return-Path: <linux-kernel-owner+w=401wt.eu-S1762506AbXIXQhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762506AbXIXQhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760624AbXIXQ1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:27:22 -0400
Received: from canuck.infradead.org ([209.217.80.40]:57978 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760699AbXIXQ1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:27:19 -0400
Date: Mon, 24 Sep 2007 09:21:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Willy Tarreau <w@1wt.eu>, Ayaz Abdulla <aabdulla@nvidia.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: [34/50] fix realtek phy id in forcedeth
Message-ID: <20070924162156.GI13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-realtek-phy-id-in-forcedeth.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

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
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -551,7 +551,7 @@ union ring_type {
 #define PHY_OUI_MARVELL	0x5043
 #define PHY_OUI_CICADA	0x03f1
 #define PHY_OUI_VITESSE	0x01c1
-#define PHY_OUI_REALTEK	0x01c1
+#define PHY_OUI_REALTEK	0x0732
 #define PHYID1_OUI_MASK	0x03ff
 #define PHYID1_OUI_SHFT	6
 #define PHYID2_OUI_MASK	0xfc00

-- 
