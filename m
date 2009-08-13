Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZHMUFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZHMUFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932254AbZHMT75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:57 -0400
Received: from kroah.org ([198.145.64.141]:41879 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229AbZHMT74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:32 2009
Message-Id: <20090813195132.283752239@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <roel.kluin@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 52/74] atl1c: add missing parentheses
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=atl1c-add-missing-parentheses.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: roel kluin <roel.kluin@gmail.com>

commit c5ad4f592e27d782faea0a787d9181f192a69ef0 upstream.

Parentheses are required or the comparison occurs before the bitand.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atl1c/atl1c.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/atl1c/atl1c.h
+++ b/drivers/net/atl1c/atl1c.h
@@ -188,14 +188,14 @@ struct atl1c_tpd_ext_desc {
 #define RRS_HDS_TYPE_DATA	2
 
 #define RRS_IS_NO_HDS_TYPE(flag) \
-	(((flag) >> (RRS_HDS_TYPE_SHIFT)) & RRS_HDS_TYPE_MASK == 0)
+	((((flag) >> (RRS_HDS_TYPE_SHIFT)) & RRS_HDS_TYPE_MASK) == 0)
 
 #define RRS_IS_HDS_HEAD(flag) \
-	(((flag) >> (RRS_HDS_TYPE_SHIFT)) & RRS_HDS_TYPE_MASK == \
+	((((flag) >> (RRS_HDS_TYPE_SHIFT)) & RRS_HDS_TYPE_MASK) == \
 			RRS_HDS_TYPE_HEAD)
 
 #define RRS_IS_HDS_DATA(flag) \
-	(((flag) >> (RRS_HDS_TYPE_SHIFT)) & RRS_HDS_TYPE_MASK == \
+	((((flag) >> (RRS_HDS_TYPE_SHIFT)) & RRS_HDS_TYPE_MASK) == \
 			RRS_HDS_TYPE_DATA)
 
 /* rrs word 3 bit 0:31 */
@@ -245,7 +245,7 @@ struct atl1c_tpd_ext_desc {
 #define RRS_PACKET_TYPE_802_3  	1
 #define RRS_PACKET_TYPE_ETH	0
 #define RRS_PACKET_IS_ETH(word) \
-	(((word) >> RRS_PACKET_TYPE_SHIFT) & RRS_PACKET_TYPE_MASK == \
+	((((word) >> RRS_PACKET_TYPE_SHIFT) & RRS_PACKET_TYPE_MASK) == \
 			RRS_PACKET_TYPE_ETH)
 #define RRS_RXD_IS_VALID(word) \
 	((((word) >> RRS_RXD_UPDATED_SHIFT) & RRS_RXD_UPDATED_MASK) == 1)


