Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbXKGLS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbXKGLS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 06:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbXKGLSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 06:18:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbXKGLSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 06:18:21 -0500
Date: Wed, 7 Nov 2007 12:18:13 +0100
From: Florian La Roche <laroche@redhat.com>
To: htejun@gmail.com, jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: sata NCQ blacklist entry
Message-ID: <20071107111813.GA9064@dudweiler.stuttgart.redhat.com>
Mail-Followup-To: htejun@gmail.com, jeff@garzik.org,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I've taking email addresses from the last NCQ blacklist changes going
into the kernel.
This Fujitsu drive also gives me spurious command completions. Detailed
output also available at https://bugzilla.redhat.com/show_bug.cgi?id=366181.

Let me know if you need more info or anything else.

regards,

Florian La Roche


--- drivers/ata/libata-core.c
+++ drivers/ata/libata-core.c
@@ -4222,6 +4222,7 @@
 	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
 	{ "WDC WD3200AAJS-00RYA0", "12.01B01",	ATA_HORKAGE_NONCQ, },
 	{ "FUJITSU MHV2080BH",	"00840028",	ATA_HORKAGE_NONCQ, },
+	{ "FUJITSU MHW2160BJ G2",       NULL,           ATA_HORKAGE_NONCQ },
 	{ "ST9120822AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
 	{ "ST9160821AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
 	{ "ST9160821AS",	"3.ALD",	ATA_HORKAGE_NONCQ, },
