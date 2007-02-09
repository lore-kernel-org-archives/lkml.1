Return-Path: <linux-kernel-owner+w=401wt.eu-S1946567AbXBIPiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946567AbXBIPiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946571AbXBIPfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:35:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2693 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946570AbXBIPfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:35:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=PjnDofYYOg3Tns8zxmHgo59YanteTB4dk+l4cArMIGBBi+/jMfixa8gkGsMaa95sicGdLX7cDCKsMsE3N8u4cA0vMrYW+HZxQDSmGOXPMdAwjbl9yV+a3Lt5y3kBsDxT50VPz5cYND/KQSedOPxthwWuooyuX+U4sRJeGxMZDUw=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, philb@gnu.org, tim@cyberelk.net,
       andrea@suse.de
Subject: [PATCH 30/34] __initdata cleanup - parallel
Date: Fri, 9 Feb 2007 17:33:36 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091733.36249.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/drivers/parport/parport_gsc.c linux-2.6.20-rc6-mm3/drivers/parport/parport_gsc.c
--- linux-2.6.20-rc6-mm3.org/drivers/parport/parport_gsc.c	2007-01-31 22:15:40.000000000 +0200
+++ linux-2.6.20-rc6-mm3/drivers/parport/parport_gsc.c	2007-01-31 22:19:30.000000000 +0200
@@ -350,7 +350,7 @@ struct parport *__devinit parport_gsc_pr
 
 #define PARPORT_GSC_OFFSET 0x800
 
-static int __initdata parport_count;
+static int __initdata parport_count = 0;
 
 static int __devinit parport_init_chip(struct parisc_device *dev)
 {
