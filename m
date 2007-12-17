Return-Path: <linux-kernel-owner+w=401wt.eu-S1763965AbXLQVQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763965AbXLQVQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbXLQVP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:15:58 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3555 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbXLQVP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:15:56 -0500
Subject: Re: [PATCH] drivers/net/: Spelling fixes
From: Joe Perches <joe@perches.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Li Yang <leoli@freescale.com>,
       Ramkrishna Vepa <ram.vepa@neterion.com>,
       Rastapur Santosh <santosh.rastapur@neterion.com>,
       Sivakumar Subramani <sivakumar.subramani@neterion.com>,
       Sreenivasa Honnur <sreenivasa.honnur@neterion.com>,
       linuxppc-dev@ozlabs.org, netdev@vger.kernel.org
In-Reply-To: <20071217215635.16fe17af@morte>
References: <1197920439-5455-2-git-send-email-joe@perches.com>
	 <20071217215635.16fe17af@morte>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 13:15:45 -0800
Message-Id: <1197926145.27386.56.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-17 at 21:56 +0100, Stefano Brivio wrote:
> On Mon, 17 Dec 2007 11:40:08 -0800
> Joe Perches <joe@perches.com> wrote:
> > diff --git a/drivers/net/ucc_geth_ethtool.c
> b/drivers/net/ucc_geth_ethtool.c
> > index 9a9622c..f8d319b 100644
> > --- a/drivers/net/ucc_geth_ethtool.c
> > +++ b/drivers/net/ucc_geth_ethtool.c
> > @@ -7,7 +7,7 @@
> >   *
> >   * Limitation: 
> >   * Can only get/set setttings of the first queue.
>                          ^^^

Good eyes...  Unrelated to what I changed too.
cheers, Joe

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index 121cb10..cdfb2b0 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -6823,8 +6823,8 @@ static void do_s2io_card_down(struct s2io_nic * sp, int do_io)
 	while(do_io) {
 		/* As per the HW requirement we need to replenish the
 		 * receive buffer to avoid the ring bump. Since there is
-		 * no intention of processing the Rx frame at this pointwe are
-		 * just settting the ownership bit of rxd in Each Rx
+		 * no intention of processing the Rx frame at this point we are
+		 * just setting the ownership bit of rxd in each Rx
 		 * ring to HW and set the appropriate buffer size
 		 * based on the ring mode
 		 */
diff --git a/drivers/net/ucc_geth_ethtool.c b/drivers/net/ucc_geth_ethtool.c
index f8d319b..3e50df8 100644
--- a/drivers/net/ucc_geth_ethtool.c
+++ b/drivers/net/ucc_geth_ethtool.c
@@ -6,7 +6,7 @@
  * Author: Li Yang <leoli@freescale.com>
  *
  * Limitation: 
- * Can only get/set setttings of the first queue.
+ * Can only get/set settings of the first queue.
  * Need to re-open the interface manually after changing some parameters.
  *
  * This program is free software; you can redistribute  it and/or modify it


