Return-Path: <linux-kernel-owner+w=401wt.eu-S1764394AbXGJJoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764394AbXGJJoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbXGJJoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:44:11 -0400
Received: from v813.rev.tld.pl ([195.149.226.213]:42740 "EHLO
	smtp.host4.kei.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362AbXGJJoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:44:10 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2007 05:44:10 EDT
X-clamdmail: clamdmail 0.18a
From: Marcin Juszkiewicz <openembedded@hrw.one.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] PCMCIA: Add another MemoryCard to ide-cd/pata_pcmcia
Date: Tue, 10 Jul 2007 11:37:23 +0200
User-Agent: KMail/1.9.7
Cc: linux-pcmcia@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707101137.25955.openembedded@hrw.one.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Juszkiewicz <openembedded@hrw.one.pl>

One card submitted by user.

Signed-off-by: Marcin Juszkiewicz <openembedded@hrw.one.pl>

Index: linux-git/drivers/ide/legacy/ide-cs.c
===================================================================
--- linux-git.orig/drivers/ide/legacy/ide-cs.c  2007-07-03 11:17:05.000000000 +0200
+++ linux-git/drivers/ide/legacy/ide-cs.c       2007-07-10 11:32:53.000000000 +0200
@@ -386,6 +386,7 @@
        PCMCIA_DEVICE_PROD_ID12("HITACHI", "microdrive", 0xf4f43949, 0xa6d76178),
        PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
        PCMCIA_DEVICE_PROD_ID12("IBM", "IBM17JSSFP20", 0xb569a6e5, 0xf2508753),
+       PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF8GB", 0x2e6d1829, 0xacbe682e),
        PCMCIA_DEVICE_PROD_ID12("IO DATA", "CBIDE2      ", 0x547e66dc, 0x8671043b),
        PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDE", 0x547e66dc, 0x5c5ab149),
        PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDEII", 0x547e66dc, 0xb3662674),
Index: linux-git/drivers/ata/pata_pcmcia.c
===================================================================
--- linux-git.orig/drivers/ata/pata_pcmcia.c    2007-07-10 11:33:04.000000000 +0200
+++ linux-git/drivers/ata/pata_pcmcia.c 2007-07-10 11:33:40.000000000 +0200
@@ -382,6 +382,7 @@
        PCMCIA_DEVICE_PROD_ID12("HITACHI", "microdrive", 0xf4f43949, 0xa6d76178),
        PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
        PCMCIA_DEVICE_PROD_ID12("IBM", "IBM17JSSFP20", 0xb569a6e5, 0xf2508753),
+       PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF8GB", 0x2e6d1829, 0xacbe682e),
        PCMCIA_DEVICE_PROD_ID12("IO DATA", "CBIDE2      ", 0x547e66dc, 0x8671043b),
        PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDE", 0x547e66dc, 0x5c5ab149),
        PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDEII", 0x547e66dc, 0xb3662674),

-- 
JID: hrw-jabber.org
OpenEmbedded developer/consultant

                        If it works, don't fix it.
                        		-- Sam Rayburn


