Return-Path: <linux-kernel-owner+w=401wt.eu-S1762886AbXGFKSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762886AbXGFKSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbXGFKS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:18:27 -0400
Received: from mail.macqel.be ([194.78.208.39]:11373 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbXGFKS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:18:26 -0400
Date: Fri, 6 Jul 2007 12:18:23 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ppp : white space cleanup
Message-ID: <20070706101823.GA12380@muff.macqel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This removes useless spaces at begin of lines

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff -r 6c0a10cc415a drivers/net/ppp_async.c
--- a/drivers/net/ppp_async.c	Thu Jul  5 16:10:16 2007 -0700
+++ b/drivers/net/ppp_async.c	Fri Jul  6 12:15:38 2007 +0200
@@ -887,15 +887,15 @@ ppp_async_input(struct asyncppp *ap, con
 				skb = dev_alloc_skb(ap->mru + PPP_HDRLEN + 2);
 				if (skb == 0)
 					goto nomem;
- 				ap->rpkt = skb;
- 			}
- 			if (skb->len == 0) {
- 				/* Try to get the payload 4-byte aligned.
- 				 * This should match the
- 				 * PPP_ALLSTATIONS/PPP_UI/compressed tests in
- 				 * process_input_packet, but we do not have
- 				 * enough chars here to test buf[1] and buf[2].
- 				 */
+				ap->rpkt = skb;
+			}
+			if (skb->len == 0) {
+				/* Try to get the payload 4-byte aligned.
+				 * This should match the
+				 * PPP_ALLSTATIONS/PPP_UI/compressed tests in
+				 * process_input_packet, but we do not have
+				 * enough chars here to test buf[1] and buf[2].
+				 */
 				if (buf[0] != PPP_ALLSTATIONS)
 					skb_reserve(skb, 2 + (buf[0] & 1));
 			}
