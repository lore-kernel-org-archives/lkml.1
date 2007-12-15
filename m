Return-Path: <linux-kernel-owner+w=401wt.eu-S933903AbXLNXMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903AbXLNXMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 18:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbXLNXMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 18:12:41 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:62261 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbXLNXMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 18:12:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type;
        b=aBtWu/DC919APIYAKsybJqm6fYTP2FvwNkPd+iiAuA9c2uwY150855xwzEkyZFQ9STrFnaH09wiSPa29OTwQ5fpxL1g9BV1xVPu7vunn6h7EFYcP2DxY0pW0pwzSIQ7ms0/g0cyrPhevp5VNgHwNSRc1O02kB0IiAvn/wka1jTU=
Message-ID: <47631BC0.5090500@googlemail.com>
Date: Sat, 15 Dec 2007 01:11:44 +0100
From: =?ISO-8859-15?Q?Michael_K=FChn?= <breiteseite1337@googlemail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071214)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [x86_64] remove unused variable from drivers/ata/ahci.c
Content-Type: multipart/mixed;
 boundary="------------080708020404020106060908"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080708020404020106060908
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi,

my first kernel patch, yay. :-)

On the file drivers/ata/ahci.c in line 1433 is declared a variable that
is never used in the function. I removed it.

Patch is in attachments (based on 2.6.23.10).

--------------080708020404020106060908
Content-Type: text/x-patch;
 name="ahci.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ahci.patch"

--- linux-2.6.23.10/drivers/ata/ahci.c	2007-12-14 19:01:59.000000000 +0100
+++ linux-2.6.23.10.new/drivers/ata/ahci.c	2007-12-15 01:03:41.000000000 +0100
@@ -1430,7 +1430,6 @@
 {
 	void __iomem *port_mmio = ap->ioaddr.cmd_addr;
 	struct ata_eh_info *ehi = &ap->eh_info;
-	struct ahci_port_priv *pp = ap->private_data;
 	u32 status, qc_active;
 	int rc;
 

--------------080708020404020106060908--
