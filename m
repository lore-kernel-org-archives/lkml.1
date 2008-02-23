Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbYBWOGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbYBWOGn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758731AbYBWOFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:05:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:35830 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758702AbYBWOFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:05:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=eUSlxZnjKnz+AsC2Dsvm2hS7ZphWhq8zHV/nAqK9JXuMh4pQ9MY9p1K5wu/ajD+XEyh3fHpui3Q79WjnD82Zrw3A+51Caa+q1WWNMXN58GImBIhcwbOdhDFSEUsPDxE5KOTyT7mmCdcgnMIZ6Te4Of+FSTsVB8jQaLB6o7HS7+A=
Date: Sat, 23 Feb 2008 15:05:08 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 03/10] IDE: Coding Style fixes to drivers/ide/ide-pnp.c
Message-ID: <20080223150508.2f9addff@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.
Compile tested.

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/ide-pnp.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index c125b05..479663d 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -11,7 +11,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * (for example /usr/src/linux/COPYING); if not, write to the Free
- * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  
+ * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/init.h>
@@ -20,12 +20,12 @@
 
 /* Add your devices here :)) */
 static struct pnp_device_id idepnp_devices[] = {
-  	/* Generic ESDI/IDE/ATA compatible hard disk controller */
+	/* Generic ESDI/IDE/ATA compatible hard disk controller */
 	{.id = "PNP0600", .driver_data = 0},
 	{.id = ""}
 };
 
-static int idepnp_probe(struct pnp_dev * dev, const struct pnp_device_id *dev_id)
+static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 {
 	hw_regs_t hw;
 	ide_hwif_t *hwif;
@@ -47,7 +47,7 @@ static int idepnp_probe(struct pnp_dev * dev, const struct pnp_device_id *dev_id
 		ide_init_port_hw(hwif, &hw);
 
 		printk(KERN_INFO "ide%d: generic PnP IDE interface\n", index);
-		pnp_set_drvdata(dev,hwif);
+		pnp_set_drvdata(dev, hwif);
 
 		ide_device_add(idx, NULL);
 
@@ -57,7 +57,7 @@ static int idepnp_probe(struct pnp_dev * dev, const struct pnp_device_id *dev_id
 	return -1;
 }
 
-static void idepnp_remove(struct pnp_dev * dev)
+static void idepnp_remove(struct pnp_dev *dev)
 {
 	ide_hwif_t *hwif = pnp_get_drvdata(dev);
 
-- 
1.5.4.2.316.gf7a7

