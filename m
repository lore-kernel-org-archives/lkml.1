Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbZBZQ3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbZBZQ3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbZBZQ3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:29:02 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:9284 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbZBZQ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:29:00 -0500
Date: Thu, 26 Feb 2009 09:28:58 -0700
From: David Altobelli <david.altobelli@hp.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, david.altobelli@hp.com
Subject: [PATCH] new pci device for hpilo
Message-ID: <20090226162858.GA29790@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Future iLO devices will have an HP vendor id, applies to 2.6.29.

Please CC me on any replies.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
---

--- linux-2.6.28/drivers/misc/hpilo.c.orig	2009-02-20 13:59:42.000000000 -0600
+++ linux-2.6.28/drivers/misc/hpilo.c	2009-02-20 14:02:46.000000000 -0600
@@ -710,6 +710,7 @@ out:
 
 static struct pci_device_id ilo_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB204) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3307) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ilo_devices);
@@ -758,7 +759,7 @@ static void __exit ilo_exit(void)
 	class_destroy(ilo_class);
 }
 
-MODULE_VERSION("0.06");
+MODULE_VERSION("1.0");
 MODULE_ALIAS(ILO_NAME);
 MODULE_DESCRIPTION(ILO_NAME);
 MODULE_AUTHOR("David Altobelli <david.altobelli@hp.com>");
