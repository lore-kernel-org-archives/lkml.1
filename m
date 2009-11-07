Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbZKGVnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbZKGVnX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbZKGVnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:43:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46901 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251AbZKGVnU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:43:20 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Michael H. Warfield" <mhw@wittsend.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:42:53 +0000
Message-ID: <1257630173.15927.386.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 05/75] ip2: declare MODULE_FIRMWARE
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/ip2/ip2main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 517271c..791e589 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -3197,3 +3197,5 @@ static struct pci_device_id ip2main_pci_tbl[] __devinitdata = {
 };
 
 MODULE_DEVICE_TABLE(pci, ip2main_pci_tbl);
+
+MODULE_FIRMWARE("intelliport2.bin");
-- 
1.6.5.2



