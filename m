Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbXELPae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbXELPae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 11:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbXELPa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 11:30:27 -0400
Received: from lixom.net ([66.141.50.11]:33779 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698AbXELPa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 11:30:26 -0400
Date: Sat, 12 May 2007 10:33:07 -0500
To: linux-pcmcia@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] pcmcia: export pcmcia_bus_type
Message-ID: <20070512153307.GA13223@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export pcmcia_bus_type so modules can register bus notifiers.


Signed-off-by: Olof Johansson <olof@lixom.net>

Index: powerpc/drivers/pcmcia/ds.c
===================================================================
--- powerpc.orig/drivers/pcmcia/ds.c
+++ powerpc/drivers/pcmcia/ds.c
@@ -1515,6 +1515,7 @@ struct bus_type pcmcia_bus_type = {
 	.suspend = pcmcia_dev_suspend,
 	.resume = pcmcia_dev_resume,
 };
+EXPORT_SYMBOL(pcmcia_bus_type);
 
 
 static int __init init_pcmcia_bus(void)
