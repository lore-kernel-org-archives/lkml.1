Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbYFVXfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbYFVXfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 19:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbYFVXfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 19:35:10 -0400
Received: from nebensachen.de ([195.34.83.29]:44620 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991AbYFVXfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 19:35:08 -0400
X-Hashcash: 1:20:080622:bzolnier@gmail.com::Vy+siP3Fa/LAOMmV:00000000000000000000000000000000000000000002ifF
X-Hashcash: 1:20:080622:linux-ide@vger.kernel.org::xvaIwG68X56Cwq+w:0000000000000000000000000000000000000eI8
X-Hashcash: 1:20:080622:linux-kernel@vger.kernel.org::Z4H76Bt72ZjblhAI:0000000000000000000000000000000000sf4
X-Hashcash: 1:20:080622:randy.dunlap@oracle.com::k8AkxnsyZlneO2PI:000000000000000000000000000000000000002f5U
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 3/4] Update documentation of HDIO_DRIVE_RESET ioctl
References: <87k5gmz596.fsf@denkblock.local>
	<200806192247.25063.bzolnier@gmail.com>
	<87wskhuk98.fsf@denkblock.local>
Date: Mon, 23 Jun 2008 01:35:00 +0200
In-Reply-To: <87wskhuk98.fsf@denkblock.local> (Elias Oltmanns's message of
	"Mon, 23 Jun 2008 01:23:31 +0200")
Message-ID: <87fxr5ujq3.fsf_-_@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alter the entry for HDIO_DRIVE_RESET in Documentation/ioctl/hdio.txt to
reflect a functional change in the driver.  Besides, the entry has been
inaccurate before.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 Documentation/ioctl/hdio.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/ioctl/hdio.txt b/Documentation/ioctl/hdio.txt
index c19efde..a859734 100644
--- a/Documentation/ioctl/hdio.txt
+++ b/Documentation/ioctl/hdio.txt
@@ -508,12 +508,12 @@ HDIO_DRIVE_RESET		execute a device reset
 
 	error returns:
 	  EACCES	Access denied:  requires CAP_SYS_ADMIN
+	  EBUSY		Device busy:	reset operation in progress already
 
 	notes:
 
-	  Abort any current command, prevent anything else from being
-	  queued, execute a reset on the device, and issue BLKRRPART
-	  ioctl on the block device.
+	  Execute a reset on the device as soon as the current IO
+	  operation has completed.
 
 	  Executes an ATAPI soft reset if applicable, otherwise
 	  executes an ATA soft reset on the controller.
