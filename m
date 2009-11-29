Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZK2Cs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZK2Cs3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 21:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbZK2Cs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 21:48:28 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:43881 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZK2Cs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 21:48:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nfZgJP23HDZGolqSjgfo/NIEBPIcYqbRMyhwKvQdcEpcC0tQN4TvRNDzkRtFuJcamp
         okdSnLDceqaUI1Z6ZAKmHFLfeEV1lSPN2Pzv9/Bw8pG5t07o96gBj+5JnnGADwlwR94v
         /drj2V6WR6CaIx9tI1eS02tzmxltR/fIcofsE=
Date: Sat, 28 Nov 2009 23:49:44 -0300
From: Rudy Matela <rudy.matela@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: Coding style corrections on Sealevel Systems 4021
 driver.
Message-ID: <20091129024944.GB20636@oblivion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed braces position on some statements.
Inserted a space between an "if" keyword and a parenthesis.

Signed-off-by: Rudy Matela <rudy.matela@gmail.com>
---

 drivers/net/wan/sealevel.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/sealevel.c b/drivers/net/wan/sealevel.c
index 0c525e2..6b03704 100644
--- a/drivers/net/wan/sealevel.c
+++ b/drivers/net/wan/sealevel.c
@@ -84,8 +84,7 @@ static int sealevel_open(struct net_device *d)
 	 *	Link layer up.
 	 */
 
-	switch (unit)
-	{
+	switch (unit) {
 		case 0:
 			err = z8530_sync_dma_open(d, slvl->chan);
 			break;
@@ -133,8 +132,7 @@ static int sealevel_close(struct net_device *d)
 	hdlc_close(d);
 	netif_stop_queue(d);
 
-	switch (unit)
-	{
+	switch (unit) {
 		case 0:
 			z8530_sync_dma_close(d, slvl->chan);
 			break;
@@ -342,8 +340,7 @@ static void __exit slvl_shutdown(struct slvl_board *b)
 
 	z8530_shutdown(&b->board);
 
-	for (u = 0; u < 2; u++)
-	{
+	for (u = 0; u < 2; u++) {
 		struct net_device *d = b->dev[u].chan->netdevice;
 		unregister_hdlc_device(d);
 		free_netdev(d);
@@ -391,7 +388,7 @@ static int __init slvl_init_module(void)
 
 static void __exit slvl_cleanup_module(void)
 {
-	if(slvl_unit)
+	if (slvl_unit)
 		slvl_shutdown(slvl_unit);
 }
 
