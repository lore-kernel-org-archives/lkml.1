Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbXLDKpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbXLDKpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 05:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbXLDKpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 05:45:34 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:36807 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbXLDKpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 05:45:33 -0500
Date: Tue, 4 Dec 2007 11:45:29 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: PATCH: Hitachi disk quirk
Message-ID: <20071204104529.GA4098@ics.muni.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 04 Dec 2007 11:45:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello,

the following patch should be applied into 2.6.24-rc3 as the mentioned Hitachi
disk has also problem with NCQ.

-- 
Luká¹ Hejtmánek

--PNTmBPCT7hxwcZjr
Content-Type: text/x-diff; charset=iso-8859-2
Content-Disposition: attachment; filename="ata.patch"

--- a/drivers/ata/libata-core.c	2007-12-04 11:08:20.000000000 +0100
+++ b/drivers/ata/libata-core.c	2007-12-04 11:09:23.000000000 +0100
@@ -4159,6 +4159,7 @@
 	{ "HTS541612J9SA00",	"SBDIC7JP",	ATA_HORKAGE_NONCQ, },
 	{ "HDT722516DLA380",	"V43OA96A",	ATA_HORKAGE_NONCQ, },
 	{ "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
+	{ "HITACHI HTS541616J9SA00", "SB4IC7UP", ATA_HORKAGE_NONCQ, },
 	{ "Hitachi HTS542525K9SA00", "BBFOC31P", ATA_HORKAGE_NONCQ, },
 	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
 	{ "WDC WD3200AAJS-00RYA0", "12.01B01",	ATA_HORKAGE_NONCQ, },

--PNTmBPCT7hxwcZjr--
