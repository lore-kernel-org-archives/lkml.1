Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbXFYC3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbXFYC3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 22:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbXFYC3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 22:29:09 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:45579 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbXFYC3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 22:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cDUW7OtL4KuVKbKKZuIWoUDt4Su4BJRc3osGAX0H58wMznUf4I1QU+zkKEpf5PK95UH+6s4CFAuB0Ab33CSloSzu8e9/WvPvbXZcsuKMj13McQ26Kmhna3KLUmynXem49vqe9R61klRviBt7DVyATnIe30ec9DLHe0JQZx4dGzg=
Message-ID: <467F286B.40607@gmail.com>
Date: Mon, 25 Jun 2007 11:28:59 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, enricoss@tiscali.it,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 2.6.22-rc5] libata: add HTS541616J9SA00 to NCQ blacklist
References: <fa.sspu6LOivd/touNtS2IsMKPqHa0@ifi.uio.no> <fa.19XJG1Asdp1zwcWLxolIH6F+5lY@ifi.uio.no> <467EC909.9040006@shaw.ca> <467F2495.3080509@gmail.com>
In-Reply-To: <467F2495.3080509@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Another member of HTS5416* family doing spurious NCQ completion.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Enrico Sardi <enricoss@tiscali.it>
---
 drivers/ata/libata-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index adfae9d..fbca8d8 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3803,6 +3803,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* Drives which do spurious command completion */
 	{ "HTS541680J9SA00",	"SB2IC7EP",	ATA_HORKAGE_NONCQ, },
 	{ "HTS541612J9SA00",	"SBDIC7JP",	ATA_HORKAGE_NONCQ, },
+	{ "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
 	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
 
 	/* Devices with NCQ limits */
