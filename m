Return-Path: <linux-kernel-owner+w=401wt.eu-S1762409AbXFCIUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762409AbXFCIUY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 04:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbXFCIUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 04:20:15 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:42008 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbXFCIUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 04:20:13 -0400
X-Originating-Ip: 72.143.65.211
Date: Sun, 3 Jun 2007 04:18:32 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Greg KH <greg@kroah.com>
Subject: [PATCH] Replace remaining comment references to "driverfs" with
 "sysfs".
Message-ID: <Pine.LNX.4.64.0706030416230.15025@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Given that all of the actual code references to "driverfs" have been
replaced with "sysfs," replace the few remaining comment references
just to be consistent.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

 Documentation/pnp.txt           |    4 ++--
 Documentation/s390/cds.txt      |    2 +-
 drivers/i2c/busses/i2c-pasemi.c |    2 +-
 drivers/pci/pci-sysfs.c         |    2 +-
 include/linux/node.h            |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/pnp.txt b/Documentation/pnp.txt
index 481faf5..f58b6fa 100644
--- a/Documentation/pnp.txt
+++ b/Documentation/pnp.txt
@@ -17,9 +17,9 @@ The User Interface
 ------------------
 	The Linux Plug and Play user interface provides a means to activate PnP devices
 for legacy and user level drivers that do not support Linux Plug and Play.  The
-user interface is integrated into driverfs.
+user interface is integrated into sysfs.

-In addition to the standard driverfs file the following are created in each
+In addition to the standard sysfs file the following are created in each
 device's directory:
 id - displays a list of support EISA IDs
 options - displays possible resource configurations
diff --git a/Documentation/s390/cds.txt b/Documentation/s390/cds.txt
index 58919d6..f644ded 100644
--- a/Documentation/s390/cds.txt
+++ b/Documentation/s390/cds.txt
@@ -133,7 +133,7 @@ During its startup the Linux/390 system checks for peripheral devices. Each
 of those devices is uniquely defined by a so called subchannel by the ESA/390
 channel subsystem. While the subchannel numbers are system generated, each
 subchannel also takes a user defined attribute, the so called device number.
-Both subchannel number and device number cannot exceed 65535. During driverfs
+Both subchannel number and device number cannot exceed 65535. During sysfs
 initialisation, the information about control unit type and device types that
 imply specific I/O commands (channel command words - CCWs) in order to operate
 the device are gathered. Device drivers can retrieve this set of hardware
diff --git a/drivers/i2c/busses/i2c-pasemi.c b/drivers/i2c/busses/i2c-pasemi.c
index 58e3271..79c72df 100644
--- a/drivers/i2c/busses/i2c-pasemi.c
+++ b/drivers/i2c/busses/i2c-pasemi.c
@@ -364,7 +364,7 @@ static int __devinit pasemi_smb_probe(struct pci_dev *dev,
 	smbus->adapter.algo = &smbus_algorithm;
 	smbus->adapter.algo_data = smbus;

-	/* set up the driverfs linkage to our parent device */
+	/* set up the sysfs linkage to our parent device */
 	smbus->adapter.dev.parent = &dev->dev;

 	reg_write(smbus, REG_CTL, (CTL_MTR | CTL_MRR |
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 284e83a..0f5a48a 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -10,7 +10,7 @@
  *
  * File attributes for PCI devices
  *
- * Modeled after usb's driverfs.c
+ * Modeled after usb's sysfs.c
  *
  */

diff --git a/include/linux/node.h b/include/linux/node.h
index bc001bc..13e425b 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -8,7 +8,7 @@
  * Basic handling of the devices is done in drivers/base/node.c
  * and system devices are handled in drivers/base/sys.c.
  *
- * Nodes are exported via driverfs in the class/node/devices/
+ * Nodes are exported via sysfs in the class/node/devices/
  * directory.
  *
  * Per-node interfaces can be implemented using a struct device_interface.
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
