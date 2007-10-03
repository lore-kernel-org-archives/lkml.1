Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbXJCIIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbXJCIIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbXJCIIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:08:16 -0400
Received: from mail.blastwave.org ([147.87.98.10]:51157 "EHLO
	mail.blastwave.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbXJCIIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:08:14 -0400
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2007 04:08:14 EDT
Date: Wed, 3 Oct 2007 09:58:44 +0200
From: Attila Kinali <attila@kinali.ch>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add manufacturer and card id of teltonica pcmcia modems
Message-Id: <20071003095844.b12a44f4.attila@kinali.ch>
Organization: SEELE
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds the manufacturer and card id of teltonica
pcmcia modems to serial_cs.c

Signed-off-by: Attila Kinali <attila@kinali.ch>

--- linux-2.6.22.7/drivers/serial/serial_cs.c.orig	2007-10-03 09:38:53.000000000 +0200
+++ linux-2.6.22.7/drivers/serial/serial_cs.c	2007-10-03 09:39:22.000000000 +0200
@@ -939,6 +939,7 @@
 	PCMCIA_MFC_DEVICE_PROD_ID12(1,"Elan","Serial Port: SL432",0x3beb8cf2,0x1cce7ac4),
 	PCMCIA_MFC_DEVICE_PROD_ID12(2,"Elan","Serial Port: SL432",0x3beb8cf2,0x1cce7ac4),
 	PCMCIA_MFC_DEVICE_PROD_ID12(3,"Elan","Serial Port: SL432",0x3beb8cf2,0x1cce7ac4),
+	PCMCIA_DEVICE_MANF_CARD(0x0279, 0x950b),
 	/* too generic */
 	/* PCMCIA_MFC_DEVICE_MANF_CARD(0, 0x0160, 0x0002), */
 	/* PCMCIA_MFC_DEVICE_MANF_CARD(1, 0x0160, 0x0002), */


		Attila Kinali

-- 
Praised are the Fountains of Shelieth, the silver harp of the waters,
But blest in my name forever this stream that stanched my thirst!
                         -- Deed of Morred
