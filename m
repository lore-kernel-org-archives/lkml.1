Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbZBDSsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbZBDSsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758602AbZBDShn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:43 -0500
Received: from kroah.org ([198.145.64.141]:51229 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755749AbZBDSh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:29 -0500
Date: Wed, 4 Feb 2009 10:35:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mark Lord <mlord@pobox.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 32/33] sata_mv: Fix chip type for Hightpoint RocketRaid
	1740/1742
Message-ID: <20090204183518.GG13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sata_mv-fix-chip-type-for-hightpoint-rocketraid-1740-1742.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Lord <liml@rtr.ca>

commit 4462254ac6be9150aae87d54d388fc348d6fcead upstream.

Fix chip type for the Highpoint RocketRAID 1740 and 1742 PCI cards.
These really do have Marvell 6042 chips on them, rather than the 5081 chip.

Confirmed by multiple (two) users (for the 1740), and by examining
the product photographs from Highpoint's web site.

Signed-off-by: Mark Lord <mlord@pobox.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_mv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -669,8 +669,8 @@ static const struct pci_device_id mv_pci
 	{ PCI_VDEVICE(MARVELL, 0x5081), chip_508x },
 	/* RocketRAID 1720/174x have different identifiers */
 	{ PCI_VDEVICE(TTI, 0x1720), chip_6042 },
-	{ PCI_VDEVICE(TTI, 0x1740), chip_508x },
-	{ PCI_VDEVICE(TTI, 0x1742), chip_508x },
+	{ PCI_VDEVICE(TTI, 0x1740), chip_6042 },
+	{ PCI_VDEVICE(TTI, 0x1742), chip_6042 },
 
 	{ PCI_VDEVICE(MARVELL, 0x6040), chip_604x },
 	{ PCI_VDEVICE(MARVELL, 0x6041), chip_604x },

