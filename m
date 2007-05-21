Return-Path: <linux-kernel-owner+w=401wt.eu-S1759803AbXEUSbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803AbXEUSbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756390AbXEUSbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:31:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756590AbXEUSbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:31:11 -0400
Date: Mon, 21 May 2007 14:31:03 -0400
From: Dave Jones <davej@redhat.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org
Subject: Add Seagate STT20000A to DMA blacklist.
Message-ID: <20070521183102.GA14537@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Robert Hancock <hancockr@shaw.ca>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>, bzolnier@gmail.com,
	linux-ide@vger.kernel.org
References: <fa.6aGWKqGWP2vDWJvVhFqggIUaWVk@ifi.uio.no> <fa.70JldrzRTUl84Jt2lSquANqNr2Q@ifi.uio.no> <fa.xozW+S/WBbGA8Gv2z3FmAe/XymA@ifi.uio.no> <4651E2AF.2080109@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4651E2AF.2080109@shaw.ca>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=1044 points out an
additional hard disk that doesn't handle DMA transfers correctly.
This patch is the libata variant of the earlier patch to drivers/ide/

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6/drivers/ata/libata-core.c~	2007-05-21 14:27:40.000000000 -0400
+++ linux-2.6/drivers/ata/libata-core.c	2007-05-21 14:28:48.000000000 -0400
@@ -3771,6 +3771,7 @@ static const struct ata_blacklist_entry 
 	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",NULL,ATA_HORKAGE_NODMA },
 	{ "_NEC DV5800A", 	NULL,		ATA_HORKAGE_NODMA },
 	{ "SAMSUNG CD-ROM SN-124","N001",	ATA_HORKAGE_NODMA },
+	{ "Seagate STT20000A", NULL,		ATA_HORKAGE_NODMA },
 
 	/* Weird ATAPI devices */
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 |

-- 
http://www.codemonkey.org.uk
