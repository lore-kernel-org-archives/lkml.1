Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbXJXOv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbXJXOv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbXJXOvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:51:18 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:37059 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbXJXOvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:51:17 -0400
Date: Wed, 24 Oct 2007 15:51:09 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Remove inclusions of <linux/autoconf.h>
Message-ID: <20071024145109.GA9535@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing should ever include this file.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/blackfin/mach-common/interrupt.S |    1 -
 arch/blackfin/mm/blackfin_sram.c      |    1 -
 arch/m68knommu/lib/memcpy.c           |    1 -
 arch/mips/au1000/common/gpio.c        |    1 -
 drivers/char/mxser.c                  |    1 -
 drivers/char/mxser_new.c              |    1 -
 drivers/firmware/dmi-id.c             |    1 -
 drivers/ide/pci/delkin_cb.c           |    1 -
 drivers/misc/asus-laptop.c            |    1 -
 drivers/misc/fujitsu-laptop.c         |    1 -
 drivers/misc/msi-laptop.c             |    1 -
 drivers/spi/spi.c                     |    1 -
 12 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/blackfin/mach-common/interrupt.S b/arch/blackfin/mach-common/interrupt.S
index c6b32fe..4de3764 100644
--- a/arch/blackfin/mach-common/interrupt.S
+++ b/arch/blackfin/mach-common/interrupt.S
@@ -30,7 +30,6 @@
 
 #include <asm/blackfin.h>
 #include <asm/mach/irq.h>
-#include <linux/autoconf.h>
 #include <linux/linkage.h>
 #include <asm/entry.h>
 #include <asm/asm-offsets.h>
diff --git a/arch/blackfin/mm/blackfin_sram.c b/arch/blackfin/mm/blackfin_sram.c
index b99ea88..e41f0e8 100644
--- a/arch/blackfin/mm/blackfin_sram.c
+++ b/arch/blackfin/mm/blackfin_sram.c
@@ -27,7 +27,6 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <linux/autoconf.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
diff --git a/arch/m68knommu/lib/memcpy.c b/arch/m68knommu/lib/memcpy.c
index 0d55775..b50dbca 100644
--- a/arch/m68knommu/lib/memcpy.c
+++ b/arch/m68knommu/lib/memcpy.c
@@ -1,6 +1,5 @@
 
 #include <linux/types.h>
-#include <linux/autoconf.h>
 
 void * memcpy(void * to, const void * from, size_t n)
 {
diff --git a/arch/mips/au1000/common/gpio.c b/arch/mips/au1000/common/gpio.c
index 8527856..0b658f1 100644
--- a/arch/mips/au1000/common/gpio.c
+++ b/arch/mips/au1000/common/gpio.c
@@ -27,7 +27,6 @@
  * 	others have a second one : GPIO2
  */
 
-#include <linux/autoconf.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/types.h>
diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index fd0abef..4742078 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -37,7 +37,6 @@
 
 
 #include <linux/module.h>
-#include <linux/autoconf.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index 081c84c..bf1bee4 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/autoconf.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
index b6e1eb7..dbbda9a 100644
--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/dmi.h>
 #include <linux/device.h>
-#include <linux/autoconf.h>
 
 struct dmi_device_attribute{
 	struct device_attribute dev_attr;
diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
index 8382908..f51b36c 100644
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -18,7 +18,6 @@
  *  License.  See the file COPYING in the main directory of this archive for
  *  more details.
  */
-#include <linux/autoconf.h>
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/mm.h>
diff --git a/drivers/misc/asus-laptop.c b/drivers/misc/asus-laptop.c
index 7dce318..0846c33 100644
--- a/drivers/misc/asus-laptop.c
+++ b/drivers/misc/asus-laptop.c
@@ -33,7 +33,6 @@
  *  Sam Lin        - GPS support
  */
 
-#include <linux/autoconf.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/drivers/misc/fujitsu-laptop.c b/drivers/misc/fujitsu-laptop.c
index d366a6c..981eb13 100644
--- a/drivers/misc/fujitsu-laptop.c
+++ b/drivers/misc/fujitsu-laptop.c
@@ -50,7 +50,6 @@
 #include <linux/dmi.h>
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
-#include <linux/autoconf.h>
 
 #define FUJITSU_DRIVER_VERSION "0.3"
 
diff --git a/drivers/misc/msi-laptop.c b/drivers/misc/msi-laptop.c
index 83679c7..de898c6 100644
--- a/drivers/misc/msi-laptop.c
+++ b/drivers/misc/msi-laptop.c
@@ -58,7 +58,6 @@
 #include <linux/dmi.h>
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
-#include <linux/autoconf.h>
 
 #define MSI_DRIVER_VERSION "0.5"
 
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 89769ce..b95eb1a 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -18,7 +18,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/autoconf.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/init.h>
