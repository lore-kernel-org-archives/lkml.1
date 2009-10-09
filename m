Return-Path: <linux-kernel-owner+w=401wt.eu-S1761565AbZJIX0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbZJIX0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761386AbZJIX0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:26:45 -0400
Received: from kroah.org ([198.145.64.141]:56291 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761314AbZJIX0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:26:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:22:33 2009
Message-Id: <20091009232233.573039908@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:21:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Randy Dunlap <rdunlap@xenotime.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [1/8] net: Fix wrong sizeof
From: gregkh@mini.kroah.org
References: <20091009232123.464253035@mini.kroah.org>
Content-Disposition: inline; filename=net-fix-wrong-sizeof.patch
In-Reply-To: <20091009232300.GA403@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

commit b607bd900051efc3308c4edc65dd98b34b230021 upstream.

Which is why I have always preferred sizeof(struct foo) over
sizeof(var).

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/iseries_veth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/iseries_veth.c
+++ b/drivers/net/iseries_veth.c
@@ -495,7 +495,7 @@ static void veth_take_cap_ack(struct vet
 			   cnx->remote_lp);
 	} else {
 		memcpy(&cnx->cap_ack_event, event,
-		       sizeof(&cnx->cap_ack_event));
+		       sizeof(cnx->cap_ack_event));
 		cnx->state |= VETH_STATE_GOTCAPACK;
 		veth_kick_statemachine(cnx);
 	}


