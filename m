Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZJBB6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZJBB6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbZJBB6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:58:05 -0400
Received: from kroah.org ([198.145.64.141]:33015 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbZJBBcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:10 2009
Message-Id: <20091002012410.482625698@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: [031/136] tty: serial/pcmcia: add ID for Advantech card
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=tty-serial-pcmcia-add-id-for-advantech-card.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Wolfram Sang <w.sang@pengutronix.de>

commit 7a4b23104bd2624d16681158a9b338c502c103a0 upstream.

Add ID as reported in:

http://lists.infradead.org/pipermail/linux-pcmcia/2009-May/006127.html

Reported-by: Kenneth Moorman <KMoorman@transy.edu>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/serial_cs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/serial/serial_cs.c
+++ b/drivers/serial/serial_cs.c
@@ -884,6 +884,7 @@ static struct pcmcia_device_id serial_id
 	PCMCIA_DEVICE_CIS_MANF_CARD(0x0192, 0xa555, "SW_555_SER.cis"),  /* Sierra Aircard 555 CDMA 1xrtt Modem -- pre update */
 	PCMCIA_DEVICE_CIS_MANF_CARD(0x013f, 0xa555, "SW_555_SER.cis"),  /* Sierra Aircard 555 CDMA 1xrtt Modem -- post update */
 	PCMCIA_DEVICE_CIS_PROD_ID12("MultiTech", "PCMCIA 56K DataFax", 0x842047ee, 0xc2efcf03, "MT5634ZLX.cis"),
+	PCMCIA_DEVICE_CIS_PROD_ID12("ADVANTECH", "COMpad-32/85B-2", 0x96913a85, 0x27ab5437, "COMpad2.cis"),
 	PCMCIA_DEVICE_CIS_PROD_ID12("ADVANTECH", "COMpad-32/85B-4", 0x96913a85, 0xcec8f102, "COMpad4.cis"),
 	PCMCIA_DEVICE_CIS_PROD_ID123("ADVANTECH", "COMpad-32/85", "1.0", 0x96913a85, 0x8fbe92ae, 0x0877b627, "COMpad2.cis"),
 	PCMCIA_DEVICE_CIS_PROD_ID2("RS-COM 2P", 0xad20b156, "RS-COM-2P.cis"),


