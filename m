Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbXJHSSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbXJHSSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbXJHSRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:17:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49998 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbXJHSRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:17:53 -0400
Date: Mon, 8 Oct 2007 11:06:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 05/12] libata: update drive blacklists
Message-ID: <20071008180619.GF7627@kroah.com>
References: <20071008180406.052382073@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-update-drive-blacklists.patch"
In-Reply-To: <20071008180551.GA7627@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <cebbert@redhat.com>

Update the libata drive blacklists to the latest in 2.6.23-rc8.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3774,6 +3774,8 @@ static const struct ata_blacklist_entry 
 	{ "SAMSUNG CD-ROM SN-124","N001",	ATA_HORKAGE_NODMA },
 	{ "Seagate STT20000A", NULL,		ATA_HORKAGE_NODMA },
 	{ "IOMEGA  ZIP 250       ATAPI", NULL,	ATA_HORKAGE_NODMA }, /* temporary fix */
+	{ "IOMEGA  ZIP 250       ATAPI       Floppy",
+				NULL,		ATA_HORKAGE_NODMA },
 
 	/* Weird ATAPI devices */
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 },
@@ -3787,7 +3789,13 @@ static const struct ata_blacklist_entry 
 	{ "FUJITSU MHT2060BH",	NULL,		ATA_HORKAGE_NONCQ },
 	/* NCQ is broken */
 	{ "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ },
+	{ "Maxtor 6B200M0",	"BANC1BM0",	ATA_HORKAGE_NONCQ },
 	{ "Maxtor 6B200M0",	"BANC1B10",	ATA_HORKAGE_NONCQ },
+	{ "Maxtor 7B250S0",	"BANC1B70",	ATA_HORKAGE_NONCQ, },
+	{ "Maxtor 7B300S0",	"BANC1B70",	ATA_HORKAGE_NONCQ },
+	{ "Maxtor 7V300F0",	"VA111630",	ATA_HORKAGE_NONCQ },
+	{ "HITACHI HDS7250SASUN500G 0621KTAWSD", "K2AOAJ0AHITACHI",
+	 ATA_HORKAGE_NONCQ },
 	/* NCQ hard hangs device under heavier load, needs hard power cycle */
 	{ "Maxtor 6B250S0",	"BANC1B70",	ATA_HORKAGE_NONCQ },
 	/* Blacklist entries taken from Silicon Image 3124/3132
@@ -3801,8 +3809,9 @@ static const struct ata_blacklist_entry 
 	{ "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
 	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
 	{ "FUJITSU MHV2080BH",	"00840028",	ATA_HORKAGE_NONCQ, },
-
-	/* Devices with NCQ limits */
+	{ "ST9160821AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
+	{ "ST3160812AS",	"3.AD",		ATA_HORKAGE_NONCQ, },
+	{ "SAMSUNG HD401LJ",	"ZZ100-15",	ATA_HORKAGE_NONCQ, },
 
 	/* End Marker */
 	{ }

-- 
