Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYBXE1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYBXE1g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 23:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755755AbYBXE1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 23:27:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60794 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239AbYBXE1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 23:27:01 -0500
Date: Sun, 24 Feb 2008 15:27:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ke Wei <kewei@marvell.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi/mvsas.c needs to include linux/ctype.h fo isalnum
Message-Id: <20080224152700.20365867.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/mvsas.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Discovered while compiling Linus' tree in preparation for today's linux-next.

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index 30e20e6..de762f4 100755
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -35,6 +35,7 @@
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
+#include <linux/ctype.h>
 #include <scsi/libsas.h>
 #include <asm/io.h>
 
-- 
1.5.4.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
