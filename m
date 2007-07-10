Return-Path: <linux-kernel-owner+w=401wt.eu-S1764017AbXGJJrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764017AbXGJJrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbXGJJrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:47:16 -0400
Received: from v813.rev.tld.pl ([195.149.226.213]:44216 "EHLO
	smtp.host4.kei.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497AbXGJJrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:47:15 -0400
X-clamdmail: clamdmail 0.18a
From: Marcin Juszkiewicz <openembedded@hrw.one.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] PCMCIA: add Socket Ethernet card into pcnet_cs
Date: Tue, 10 Jul 2007 11:40:28 +0200
User-Agent: KMail/1.9.7
Cc: netdev@vger.kernel.org, linux-pcmcia@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707101140.30649.openembedded@hrw.one.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Juszkiewicz <openembedded@hrw.one.pl>

One card submitted by Ångström user.

Signed-off-by: Marcin Juszkiewicz <openembedded@hrw.one.pl>

Index: git/drivers/net/pcmcia/pcnet_cs.c
===================================================================
--- git.orig/drivers/net/pcmcia/pcnet_cs.c      2007-03-07 09:48:53.046502055 +0100
+++ git/drivers/net/pcmcia/pcnet_cs.c   2007-03-07 09:50:26.426256388 +0100
@@ -1577,6 +1577,7 @@
        PCMCIA_DEVICE_MANF_CARD(0x0274, 0x1103),
        PCMCIA_DEVICE_MANF_CARD(0x0274, 0x1121),
        PCMCIA_DEVICE_PROD_ID12("2408LAN", "Ethernet", 0x352fff7f, 0x00b2e941),
+       PCMCIA_DEVICE_PROD_ID1234("Socket", "CF 10/100 Ethernet Card", "Revision B", "05/11/06", 0xb38bcc2e, 0x4de88352, 0xeaca6c8d, 0x7e57c22e),
        PCMCIA_DEVICE_PROD_ID123("Cardwell", "PCMCIA", "ETHERNET", 0x9533672e, 0x281f1c5d, 0x3ff7175b),
        PCMCIA_DEVICE_PROD_ID123("CNet  ", "CN30BC", "ETHERNET", 0x9fe55d3d, 0x85601198, 0x3ff7175b),
        PCMCIA_DEVICE_PROD_ID123("Digital", "Ethernet", "Adapter", 0x9999ab35, 0x00b2e941, 0x4b0d829e),


-- 
JID: hrw-jabber.org
OpenEmbedded developer/consultant

                Great response time! Was that 5 baud or 10?


