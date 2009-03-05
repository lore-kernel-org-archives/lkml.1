Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbZCEPky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbZCEPky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 10:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbZCEPkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 10:40:43 -0500
Received: from havoc.gtf.org ([69.61.125.42]:41421 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbZCEPkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 10:40:42 -0500
Date: Thu, 5 Mar 2009 10:40:40 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, sshtylyov@ru.mvista.com,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] libata: add CFA specific identify data words
Message-ID: <20090305154040.GA23182@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Declare and use constants for CFA specific identify data words 162 and 163.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

---
Sergei said:
This patch is against the current pata-2.6 series. I'd prefer that Bart merged
it thru his tree as my next patch adding CF mode support to IDE depends on it.

jgarzik adds:
I didn't see this in your latest submission, Bart.  It is simple and
harmless and might as well go ahead upstream, to eliminate the
cross-tree dependency that Sergei speaks of (his patch also touched
drivers/ata/libata-core.c, but I excluded that from below).

 include/linux/ata.h       |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Index: linux-2.6/include/linux/ata.h
===================================================================
--- linux-2.6.orig/include/linux/ata.h
+++ linux-2.6/include/linux/ata.h
@@ -89,6 +89,8 @@ enum {
 	ATA_ID_DLF		= 128,
 	ATA_ID_CSFO		= 129,
 	ATA_ID_CFA_POWER	= 160,
+	ATA_ID_CFA_KEY_MGMT	= 162,
+	ATA_ID_CFA_MODES	= 163,
 	ATA_ID_ROT_SPEED	= 217,
 	ATA_ID_PIO4		= (1 << 1),
 

