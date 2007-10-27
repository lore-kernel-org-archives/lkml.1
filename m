Return-Path: <linux-kernel-owner+w=401wt.eu-S932341AbXJZXqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbXJZXqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbXJZXqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:46:13 -0400
Received: from outland.allotrope.com.au ([206.251.255.246]:52966 "EHLO
	Outland.Allotrope.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbXJZXqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:46:12 -0400
X-Greylist: delayed 1633 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 19:46:12 EDT
Message-ID: <52990.58.172.210.17.1193526927.squirrel@webmail.allotrope.com.au>
Date: Sun, 28 Oct 2007 10:15:27 +1100 (EST)
Subject: An additional entry to the pnp_dev_table for the serial driver 
     against 2.6.21.4
From: "Damian Jurd" <dnj@Allotrope.com.au>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6-7.el4.centos4
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All,

The following is an extra entry to enable the touch screen on the new LG
C1 EXPRESS DUAL machine.

Thanks,
D.

diff -uprN -X linux-2.6.21.4__vanilla/Documentation/dontdiff
linux-2.6.21.4__vanilla/drivers/serial/8250_pnp.c
linux-2.6.21.4__C1-PB11A3/drivers/serial/8250_pnp.c
--- linux-2.6.21.4__vanilla/drivers/serial/8250_pnp.c   2007-06-08
07:27:31.000000000 +1000
+++ linux-2.6.21.4__C1-PB11A3/drivers/serial/8250_pnp.c 2007-06-10
10:53:31.000000000 +1000
@@ -343,6 +343,8 @@ static const struct pnp_device_id pnp_de
        /* Fujitsu Wacom Tablet PC devices */
        {       "FUJ02E5",              0       },
        {       "FUJ02E6",              0       },
+       /* LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6
in disguise) */
+       {       "LTS0001",              0       },
        /* Rockwell's (PORALiNK) 33600 INT PNP */
        {       "WCI0003",              0       },
        /* Unkown PnP modems */


