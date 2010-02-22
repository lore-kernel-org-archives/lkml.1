Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab0BVOTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 09:19:47 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40671 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0BVOTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 09:19:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=IwUQRupL9wiqbcPN0dgmRl7DXU9gOfsee+QBiy2+EyeVVWUqYKFCJzskgi2HpZD4y/
         NgCJpKD5QBe9Z3BugWY0uaxPEJfB1XCQUxwxy97hMpdgDgLpb/Nzl2FeghIlvfEqmBNz
         lfS/mO0KUiYCbWqtQcGSyTpMachYDSMdwZbzw=
Date: Mon, 22 Feb 2010 22:19:34 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 03/06] kernel.h hexdump cleanup
Message-ID: <20100222141934.GA9030@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hexdump stuff in kernel.h should be put into a standalone head file

cleanup hexdump declarations in kernel.h, put them into hexdump.h
include hexdump.h in every file which need it

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 arch/blackfin/kernel/shadow_console.c       |    1 
 arch/cris/arch-v32/kernel/kgdb.c            |    1 
 arch/frv/kernel/gdb-stub.c                  |    1 
 arch/mn10300/kernel/gdb-stub.c              |    1 
 arch/powerpc/kernel/btext.c                 |    1 
 arch/x86/kernel/mpparse.c                   |    1 
 crypto/ansi_cprng.c                         |    1 
 crypto/testmgr.c                            |    1 
 drivers/bluetooth/btmrvl_main.c             |    1 
 drivers/char/pcmcia/ipwireless/hardware.c   |    1 
 drivers/gpu/drm/drm_edid.c                  |    1 
 drivers/isdn/gigaset/capi.c                 |    1 
 drivers/isdn/gigaset/isocdata.c             |    1 
 drivers/isdn/hardware/mISDN/avmfritz.c      |    1 
 drivers/isdn/hardware/mISDN/mISDNipac.c     |    1 
 drivers/isdn/hardware/mISDN/mISDNisar.c     |    1 
 drivers/isdn/hardware/mISDN/netjet.c        |    1 
 drivers/isdn/hardware/mISDN/w6692.c         |    1 
 drivers/media/dvb/firewire/firedtv-avc.c    |    1 
 drivers/media/video/hdpvr/hdpvr-control.c   |    1 
 drivers/media/video/hdpvr/hdpvr-core.c      |    1 
 drivers/mfd/pcf50633-core.c                 |    1 
 drivers/misc/iwmc3200top/log.h              |    2 -
 drivers/misc/kgdbts.c                       |    1 
 drivers/mtd/tests/mtd_nandecctest.c         |    1 
 drivers/mtd/ubi/debug.c                     |    1 
 drivers/mtd/ubi/io.c                        |    1 
 drivers/net/a2065.c                         |    1 
 drivers/net/arcnet/arcnet.c                 |    1 
 drivers/net/e1000/e1000_main.c              |    1 
 drivers/net/enc28j60.c                      |    1 
 drivers/net/sfc/selftest.c                  |    1 
 drivers/net/skfp/smt.c                      |    1 
 drivers/net/usb/hso.c                       |    1 
 drivers/net/wimax/i2400m/rx.c               |    1 
 drivers/net/wireless/at76c50x-usb.c         |    1 
 drivers/net/wireless/ath/ar9170/main.c      |    1 
 drivers/net/wireless/ath/ar9170/usb.c       |    1 
 drivers/net/wireless/ath/ath5k/debug.c      |    1 
 drivers/net/wireless/ath/ath9k/common.c     |    1 
 drivers/net/wireless/b43/main.c             |    1 
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    1 
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    1 
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 
 drivers/net/wireless/iwmc3200wifi/debug.h   |    1 
 drivers/net/wireless/p54/eeprom.c           |    1 
 drivers/net/wireless/ray_cs.c               |    1 
 drivers/net/wireless/wl12xx/wl1251.h        |    1 
 drivers/pnp/support.c                       |    1 
 drivers/s390/cio/device_fsm.c               |    1 
 drivers/s390/net/qeth_core_main.c           |    1 
 drivers/scsi/osd/osd_initiator.c            |    1 
 drivers/spi/spi_stmp.c                      |    1 
 drivers/staging/hv/ChannelMgmt.c            |    1 
 drivers/staging/wavelan/wavelan_cs.c        |    1 
 drivers/usb/c67x00/c67x00-sched.c           |    1 
 drivers/usb/gadget/storage_common.c         |    1 
 drivers/usb/wusbcore/crypto.c               |    1 
 fs/ext3/super.c                             |    1 
 fs/ext4/super.c                             |    1 
 fs/jffs2/wbuf.c                             |    1 
 fs/jfs/jfs_imap.c                           |    1 
 fs/jfs/jfs_logmgr.c                         |    1 
 fs/jfs/jfs_metapage.c                       |    1 
 fs/jfs/jfs_txnmgr.c                         |    1 
 fs/jfs/xattr.c                              |    1 
 fs/ubifs/debug.c                            |    1 
 fs/ubifs/scan.c                             |    1 
 fs/xfs/support/debug.c                      |    1 
 include/linux/hexdump.h                     |   30 ++++++++++++++++++++++++++++
 include/linux/ide.h                         |    1 
 include/linux/wimax/debug.h                 |    1 
 kernel/kgdb.c                               |    1 
 kernel/trace/trace_output.c                 |    1 
 lib/hexdump.c                               |    1 
 lib/vsprintf.c                              |    1 
 mm/debug-pagealloc.c                        |    1 
 mm/kmemleak.c                               |    1 
 net/ieee802154/af_ieee802154.c              |    1 
 net/ipv4/arp.c                              |    1 
 net/ipv4/netfilter/ipt_CLUSTERIP.c          |    1 
 sound/pci/oxygen/xonar_hdmi.c               |    1 
 84 files changed, 113 insertions(+), 1 deletion(-)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/linux/hexdump.h	2010-02-16 17:33:16.000000000 +0800
@@ -0,0 +1,30 @@
+#ifndef _HEXDUMP_H
+#define _HEXDUMP_H
+
+#include <linux/types.h>
+enum {
+	DUMP_PREFIX_NONE,
+	DUMP_PREFIX_ADDRESS,
+	DUMP_PREFIX_OFFSET
+};
+extern void hex_dump_to_buffer(const void *buf, size_t len,
+				int rowsize, int groupsize,
+				char *linebuf, size_t linebuflen, bool ascii);
+extern void print_hex_dump(const char *level, const char *prefix_str,
+				int prefix_type, int rowsize, int groupsize,
+				const void *buf, size_t len, bool ascii);
+extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
+			const void *buf, size_t len);
+
+extern const char hex_asc[];
+#define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
+#define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
+
+static inline char *pack_hex_byte(char *buf, u8 byte)
+{
+	*buf++ = hex_asc_hi(byte);
+	*buf++ = hex_asc_lo(byte);
+	return buf;
+}
+
+#endif
--- linux-2.6.orig/arch/blackfin/kernel/shadow_console.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/arch/blackfin/kernel/shadow_console.c	2010-02-16 17:33:16.000000000 +0800
@@ -7,6 +7,7 @@
  * Licensed under the GPL-2 or later.
  */
 
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/console.h>
--- linux-2.6.orig/arch/cris/arch-v32/kernel/kgdb.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/arch/cris/arch-v32/kernel/kgdb.c	2010-02-16 17:33:16.000000000 +0800
@@ -163,6 +163,7 @@
  */
 
 
+#include <linux/hexdump.h>
 #include <linux/string.h>
 #include <linux/signal.h>
 #include <linux/kernel.h>
--- linux-2.6.orig/arch/frv/kernel/gdb-stub.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/arch/frv/kernel/gdb-stub.c	2010-02-16 17:33:16.000000000 +0800
@@ -114,6 +114,7 @@
  *
  */
 
+#include <linux/hexdump.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
--- linux-2.6.orig/arch/mn10300/kernel/gdb-stub.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/arch/mn10300/kernel/gdb-stub.c	2010-02-16 17:33:16.000000000 +0800
@@ -120,6 +120,7 @@
  *
  */
 
+#include <linux/hexdump.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
--- linux-2.6.orig/arch/powerpc/kernel/btext.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/arch/powerpc/kernel/btext.c	2010-02-16 17:33:16.000000000 +0800
@@ -3,6 +3,7 @@
  *
  * Benjamin Herrenschmidt <benh@kernel.crashing.org>
  */
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/init.h>
--- linux-2.6.orig/arch/x86/kernel/mpparse.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/arch/x86/kernel/mpparse.c	2010-02-16 17:33:16.000000000 +0800
@@ -7,6 +7,7 @@
  *      (c) 2008 Alexey Starikovskiy <astarikovskiy@suse.de>
  */
 
+#include <linux/hexdump.h>
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/delay.h>
--- linux-2.6.orig/crypto/ansi_cprng.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/crypto/ansi_cprng.c	2010-02-16 17:33:16.000000000 +0800
@@ -13,6 +13,7 @@
  *
  */
 
+#include <linux/hexdump.h>
 #include <crypto/internal/rng.h>
 #include <linux/err.h>
 #include <linux/init.h>
--- linux-2.6.orig/crypto/testmgr.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/crypto/testmgr.c	2010-02-16 17:33:16.000000000 +0800
@@ -13,6 +13,7 @@
  *
  */
 
+#include <linux/hexdump.h>
 #include <crypto/hash.h>
 #include <linux/err.h>
 #include <linux/module.h>
--- linux-2.6.orig/drivers/bluetooth/btmrvl_main.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/bluetooth/btmrvl_main.c	2010-02-16 17:33:16.000000000 +0800
@@ -18,6 +18,7 @@
  * this warranty disclaimer.
  **/
 
+#include <linux/hexdump.h>
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 
--- linux-2.6.orig/drivers/char/pcmcia/ipwireless/hardware.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/char/pcmcia/ipwireless/hardware.c	2010-02-16 17:33:16.000000000 +0800
@@ -15,6 +15,7 @@
  *   Copyright (C) 2007 David Sterba
  */
 
+#include <linux/hexdump.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irq.h>
--- linux-2.6.orig/drivers/gpu/drm/drm_edid.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/gpu/drm/drm_edid.c	2010-02-16 17:33:16.000000000 +0800
@@ -26,6 +26,7 @@
  * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  * DEALINGS IN THE SOFTWARE.
  */
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
--- linux-2.6.orig/drivers/isdn/gigaset/capi.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/isdn/gigaset/capi.c	2010-02-16 17:33:16.000000000 +0800
@@ -11,6 +11,7 @@
  * =====================================================================
  */
 
+#include <linux/hexdump.h>
 #include "gigaset.h"
 #include <linux/ctype.h>
 #include <linux/isdn/capilli.h>
--- linux-2.6.orig/drivers/isdn/gigaset/isocdata.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/isdn/gigaset/isocdata.c	2010-02-16 17:33:16.000000000 +0800
@@ -12,6 +12,7 @@
  * =====================================================================
  */
 
+#include <linux/hexdump.h>
 #include "gigaset.h"
 #include <linux/crc-ccitt.h>
 #include <linux/bitrev.h>
--- linux-2.6.orig/drivers/isdn/hardware/mISDN/avmfritz.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/isdn/hardware/mISDN/avmfritz.c	2010-02-16 17:33:16.000000000 +0800
@@ -20,6 +20,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  */
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
--- linux-2.6.orig/drivers/isdn/hardware/mISDN/mISDNipac.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/isdn/hardware/mISDN/mISDNipac.c	2010-02-16 17:33:16.000000000 +0800
@@ -20,6 +20,7 @@
  *
  */
 
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/mISDNhw.h>
 #include "ipac.h"
--- linux-2.6.orig/drivers/isdn/hardware/mISDN/mISDNisar.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/isdn/hardware/mISDN/mISDNisar.c	2010-02-16 17:33:16.000000000 +0800
@@ -25,6 +25,7 @@
  */
 /* #define DEBUG */
 
+#include <linux/hexdump.h>
 #include <linux/delay.h>
 #include <linux/vmalloc.h>
 #include <linux/mISDNhw.h>
--- linux-2.6.orig/drivers/isdn/hardware/mISDN/netjet.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/isdn/hardware/mISDN/netjet.c	2010-02-16 17:33:16.000000000 +0800
@@ -20,6 +20,7 @@
  *
  */
 
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
--- linux-2.6.orig/drivers/isdn/hardware/mISDN/w6692.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/isdn/hardware/mISDN/w6692.c	2010-02-16 17:33:16.000000000 +0800
@@ -21,6 +21,7 @@
  *
  */
 
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
--- linux-2.6.orig/drivers/media/dvb/firewire/firedtv-avc.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/media/dvb/firewire/firedtv-avc.c	2010-02-16 17:33:16.000000000 +0800
@@ -11,6 +11,7 @@
  *	the License, or (at your option) any later version.
  */
 
+#include <linux/hexdump.h>
 #include <linux/bug.h>
 #include <linux/crc32.h>
 #include <linux/delay.h>
--- linux-2.6.orig/drivers/media/video/hdpvr/hdpvr-control.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/media/video/hdpvr/hdpvr-control.c	2010-02-16 17:33:16.000000000 +0800
@@ -9,6 +9,7 @@
  *
  */
 
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/init.h>
--- linux-2.6.orig/drivers/media/video/hdpvr/hdpvr-core.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/media/video/hdpvr/hdpvr-core.c	2010-02-16 17:33:16.000000000 +0800
@@ -11,6 +11,7 @@
  *
  */
 
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/init.h>
--- linux-2.6.orig/drivers/mfd/pcf50633-core.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/mfd/pcf50633-core.c	2010-02-16 17:33:16.000000000 +0800
@@ -12,6 +12,7 @@
  *
  */
 
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/sysfs.h>
--- linux-2.6.orig/drivers/misc/kgdbts.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/misc/kgdbts.c	2010-02-16 17:33:16.000000000 +0800
@@ -94,6 +94,7 @@
  *
  */
 
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/kgdb.h>
 #include <linux/ctype.h>
--- linux-2.6.orig/drivers/mtd/tests/mtd_nandecctest.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/mtd/tests/mtd_nandecctest.c	2010-02-16 17:33:16.000000000 +0800
@@ -1,3 +1,4 @@
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/list.h>
--- linux-2.6.orig/drivers/mtd/ubi/debug.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/mtd/ubi/debug.c	2010-02-16 17:33:16.000000000 +0800
@@ -26,6 +26,7 @@
 
 #ifdef CONFIG_MTD_UBI_DEBUG
 
+#include <linux/hexdump.h>
 #include "ubi.h"
 
 /**
--- linux-2.6.orig/drivers/mtd/ubi/io.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/mtd/ubi/io.c	2010-02-16 17:33:16.000000000 +0800
@@ -86,6 +86,7 @@
  * back and writes the whole sub-page.
  */
 
+#include <linux/hexdump.h>
 #include <linux/crc32.h>
 #include <linux/err.h>
 #include "ubi.h"
--- linux-2.6.orig/drivers/net/a2065.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/a2065.c	2010-02-16 17:33:16.000000000 +0800
@@ -37,6 +37,7 @@
  *	  both 10BASE-2 (thin coax) and AUI (DB-15) connectors
  */
 
+#include <linux/hexdump.h>
 #include <linux/errno.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
--- linux-2.6.orig/drivers/net/arcnet/arcnet.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/arcnet/arcnet.c	2010-02-16 17:33:16.000000000 +0800
@@ -43,6 +43,7 @@
 
 #define VERSION "arcnet: v3.94 BETA 2007/02/08 - by Avery Pennarun et al.\n"
 
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/delay.h>
--- linux-2.6.orig/drivers/net/e1000/e1000_main.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/e1000/e1000_main.c	2010-02-16 17:33:16.000000000 +0800
@@ -26,6 +26,7 @@
 
 *******************************************************************************/
 
+#include <linux/hexdump.h>
 #include "e1000.h"
 #include <net/ip6_checksum.h>
 
--- linux-2.6.orig/drivers/net/enc28j60.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/enc28j60.c	2010-02-16 17:33:16.000000000 +0800
@@ -13,6 +13,7 @@
  * $Id: enc28j60.c,v 1.22 2007/12/20 10:47:01 claudio Exp $
  */
 
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
--- linux-2.6.orig/drivers/net/sfc/selftest.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/sfc/selftest.c	2010-02-16 17:33:16.000000000 +0800
@@ -8,6 +8,7 @@
  * by the Free Software Foundation, incorporated herein by reference.
  */
 
+#include <linux/hexdump.h>
 #include <linux/netdevice.h>
 #include <linux/module.h>
 #include <linux/delay.h>
--- linux-2.6.orig/drivers/net/skfp/smt.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/skfp/smt.c	2010-02-16 17:33:16.000000000 +0800
@@ -14,6 +14,7 @@
  *
  ******************************************************************************/
 
+#include <linux/hexdump.h>
 #include "h/types.h"
 #include "h/fddi.h"
 #include "h/smc.h"
--- linux-2.6.orig/drivers/net/usb/hso.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/usb/hso.c	2010-02-16 17:33:16.000000000 +0800
@@ -50,6 +50,7 @@
  *
  *****************************************************************************/
 
+#include <linux/hexdump.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/init.h>
--- linux-2.6.orig/drivers/net/wimax/i2400m/rx.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wimax/i2400m/rx.c	2010-02-16 17:33:16.000000000 +0800
@@ -144,6 +144,7 @@
  *       i2400m_msg_size_check
  *       wimax_msg
  */
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/if_arp.h>
 #include <linux/netdevice.h>
--- linux-2.6.orig/drivers/net/wireless/at76c50x-usb.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wireless/at76c50x-usb.c	2010-02-16 17:33:16.000000000 +0800
@@ -24,6 +24,7 @@
  *
  */
 
+#include <linux/hexdump.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
--- linux-2.6.orig/drivers/net/wireless/ath/ar9170/main.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wireless/ath/ar9170/main.c	2010-02-16 17:33:16.000000000 +0800
@@ -37,6 +37,7 @@
  *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/hexdump.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/etherdevice.h>
--- linux-2.6.orig/drivers/net/wireless/ath/ar9170/usb.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wireless/ath/ar9170/usb.c	2010-02-16 17:33:16.000000000 +0800
@@ -37,6 +37,7 @@
  *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/usb.h>
 #include <linux/firmware.h>
--- linux-2.6.orig/drivers/net/wireless/ath/ath5k/debug.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wireless/ath/ath5k/debug.c	2010-02-16 17:33:16.000000000 +0800
@@ -58,6 +58,7 @@
  * THE POSSIBILITY OF SUCH DAMAGES.
  */
 
+#include <linux/hexdump.h>
 #include "base.h"
 #include "debug.h"
 
--- linux-2.6.orig/drivers/net/wireless/ath/ath9k/common.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wireless/ath/ath9k/common.c	2010-02-16 17:33:16.000000000 +0800
@@ -18,6 +18,7 @@
  * Module for common driver code between ath9k and ath9k_htc
  */
 
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
--- linux-2.6.orig/drivers/net/wireless/b43/main.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wireless/b43/main.c	2010-02-16 17:33:16.000000000 +0800
@@ -31,6 +31,7 @@
 
 */
 
+#include <linux/hexdump.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/moduleparam.h>
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.c	2010-02-16 17:33:16.000000000 +0800
@@ -24,6 +24,7 @@
  *
  *****************************************************************************/
 
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-agn.c	2010-02-16 17:33:16.000000000 +0800
@@ -27,6 +27,7 @@
  *
  *****************************************************************************/
 
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-debugfs.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-debugfs.c	2010-02-16 17:33:16.000000000 +0800
@@ -26,6 +26,7 @@
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/debugfs.h>
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c	2010-02-16 17:33:16.000000000 +0800
@@ -27,6 +27,7 @@
  *
  *****************************************************************************/
 
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
--- linux-2.6.orig/drivers/net/wireless/ray_cs.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wireless/ray_cs.c	2010-02-16 17:33:16.000000000 +0800
@@ -30,6 +30,7 @@
  *
 =============================================================================*/
 
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/proc_fs.h>
--- linux-2.6.orig/drivers/net/wireless/wl12xx/wl1251.h	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wireless/wl12xx/wl1251.h	2010-02-16 17:33:16.000000000 +0800
@@ -25,6 +25,7 @@
 #ifndef __WL1251_H__
 #define __WL1251_H__
 
+#include <linux/hexdump.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/bitops.h>
--- linux-2.6.orig/drivers/pnp/support.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/pnp/support.c	2010-02-16 17:33:16.000000000 +0800
@@ -6,6 +6,7 @@
  *	Bjorn Helgaas <bjorn.helgaas@hp.com>
  */
 
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/pnp.h>
--- linux-2.6.orig/drivers/s390/cio/device_fsm.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/s390/cio/device_fsm.c	2010-02-16 17:33:16.000000000 +0800
@@ -7,6 +7,7 @@
  *		 Martin Schwidefsky (schwidefsky@de.ibm.com)
  */
 
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
--- linux-2.6.orig/drivers/s390/net/qeth_core_main.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/s390/net/qeth_core_main.c	2010-02-16 17:33:16.000000000 +0800
@@ -11,6 +11,7 @@
 #define KMSG_COMPONENT "qeth"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/string.h>
--- linux-2.6.orig/drivers/scsi/osd/osd_initiator.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/scsi/osd/osd_initiator.c	2010-02-16 17:33:16.000000000 +0800
@@ -39,6 +39,7 @@
  * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
+#include <linux/hexdump.h>
 #include <scsi/osd_initiator.h>
 #include <scsi/osd_sec.h>
 #include <scsi/osd_attributes.h>
--- linux-2.6.orig/drivers/spi/spi_stmp.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/spi/spi_stmp.c	2010-02-16 17:33:16.000000000 +0800
@@ -15,6 +15,7 @@
  * http://www.opensource.org/licenses/gpl-license.html
  * http://www.gnu.org/copyleft/gpl.html
  */
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
--- linux-2.6.orig/drivers/staging/hv/ChannelMgmt.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/staging/hv/ChannelMgmt.c	2010-02-16 17:33:16.000000000 +0800
@@ -18,6 +18,7 @@
  *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/list.h>
--- linux-2.6.orig/drivers/staging/wavelan/wavelan_cs.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/staging/wavelan/wavelan_cs.c	2010-02-16 17:33:16.000000000 +0800
@@ -57,6 +57,7 @@
  */
 
 /* Do *NOT* add other headers here, you are guaranteed to be wrong - Jean II */
+#include <linux/hexdump.h>
 #include "wavelan_cs.p.h"		/* Private header */
 
 #ifdef WAVELAN_ROAMING
--- linux-2.6.orig/drivers/usb/c67x00/c67x00-sched.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/usb/c67x00/c67x00-sched.c	2010-02-16 17:33:16.000000000 +0800
@@ -21,6 +21,7 @@
  * MA  02110-1301  USA.
  */
 
+#include <linux/hexdump.h>
 #include <linux/kthread.h>
 
 #include "c67x00.h"
--- linux-2.6.orig/drivers/usb/gadget/storage_common.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/usb/gadget/storage_common.c	2010-02-16 17:33:16.000000000 +0800
@@ -54,6 +54,7 @@
  */
 
 
+#include <linux/hexdump.h>
 #include <asm/unaligned.h>
 
 
--- linux-2.6.orig/drivers/usb/wusbcore/crypto.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/usb/wusbcore/crypto.c	2010-02-16 17:33:16.000000000 +0800
@@ -45,6 +45,7 @@
  *             funneled through AES are...16 bytes in size!
  */
 
+#include <linux/hexdump.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
 #include <linux/err.h>
--- linux-2.6.orig/fs/ext3/super.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/fs/ext3/super.c	2010-02-16 17:33:16.000000000 +0800
@@ -16,6 +16,7 @@
  *        David S. Miller (davem@caip.rutgers.edu), 1995
  */
 
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
--- linux-2.6.orig/fs/ext4/super.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/fs/ext4/super.c	2010-02-16 17:33:16.000000000 +0800
@@ -16,6 +16,7 @@
  *        David S. Miller (davem@caip.rutgers.edu), 1995
  */
 
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
--- linux-2.6.orig/fs/jffs2/wbuf.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/fs/jffs2/wbuf.c	2010-02-16 17:33:16.000000000 +0800
@@ -11,6 +11,7 @@
  *
  */
 
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/mtd/mtd.h>
--- linux-2.6.orig/fs/jfs/jfs_imap.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/fs/jfs/jfs_imap.c	2010-02-16 17:33:16.000000000 +0800
@@ -41,6 +41,7 @@
  *	written out when the filesystem is unmounted by diUnmount().
  */
 
+#include <linux/hexdump.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
 #include <linux/pagemap.h>
--- linux-2.6.orig/fs/jfs/jfs_logmgr.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/fs/jfs/jfs_logmgr.c	2010-02-16 17:33:16.000000000 +0800
@@ -59,6 +59,7 @@
  * 32-bit lspn and page eor.
  */
 
+#include <linux/hexdump.h>
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
--- linux-2.6.orig/fs/jfs/jfs_metapage.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/fs/jfs/jfs_metapage.c	2010-02-16 17:33:16.000000000 +0800
@@ -17,6 +17,7 @@
  *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#include <linux/hexdump.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/module.h>
--- linux-2.6.orig/fs/jfs/jfs_txnmgr.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/fs/jfs/jfs_txnmgr.c	2010-02-16 17:33:16.000000000 +0800
@@ -42,6 +42,7 @@
  * hold on to mp+lock thru update of maps
  */
 
+#include <linux/hexdump.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
 #include <linux/completion.h>
--- linux-2.6.orig/fs/jfs/xattr.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/fs/jfs/xattr.c	2010-02-16 17:33:16.000000000 +0800
@@ -17,6 +17,7 @@
  *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#include <linux/hexdump.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
 #include <linux/xattr.h>
--- linux-2.6.orig/fs/ubifs/debug.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/fs/ubifs/debug.c	2010-02-16 17:33:16.000000000 +0800
@@ -29,6 +29,7 @@
 
 #define UBIFS_DBG_PRESERVE_UBI
 
+#include <linux/hexdump.h>
 #include "ubifs.h"
 #include <linux/module.h>
 #include <linux/moduleparam.h>
--- linux-2.6.orig/fs/ubifs/scan.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/fs/ubifs/scan.c	2010-02-16 17:33:16.000000000 +0800
@@ -27,6 +27,7 @@
  * debugging functions.
  */
 
+#include <linux/hexdump.h>
 #include "ubifs.h"
 
 /**
--- linux-2.6.orig/fs/xfs/support/debug.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/fs/xfs/support/debug.c	2010-02-16 17:33:16.000000000 +0800
@@ -15,6 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
+#include <linux/hexdump.h>
 #include <xfs.h>
 #include "debug.h"
 
--- linux-2.6.orig/include/linux/ide.h	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/include/linux/ide.h	2010-02-16 17:33:16.000000000 +0800
@@ -6,6 +6,7 @@
  *  Copyright (C) 1994-2002  Linus Torvalds & authors
  */
 
+#include <linux/hexdump.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/ata.h>
--- linux-2.6.orig/include/linux/wimax/debug.h	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/include/linux/wimax/debug.h	2010-02-16 17:33:16.000000000 +0800
@@ -153,6 +153,7 @@
 #ifndef __debug__h__
 #define __debug__h__
 
+#include <linux/hexdump.h>
 #include <linux/types.h>
 #include <linux/device.h>
 
--- linux-2.6.orig/kernel/kgdb.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/kernel/kgdb.c	2010-02-16 17:33:16.000000000 +0800
@@ -27,6 +27,7 @@
  * version 2. This program is licensed "as is" without any warranty of any
  * kind, whether express or implied.
  */
+#include <linux/hexdump.h>
 #include <linux/pid_namespace.h>
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
--- linux-2.6.orig/kernel/trace/trace_output.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/kernel/trace/trace_output.c	2010-02-16 17:33:16.000000000 +0800
@@ -5,6 +5,7 @@
  *
  */
 
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/ftrace.h>
--- linux-2.6.orig/lib/hexdump.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/lib/hexdump.c	2010-02-16 17:33:16.000000000 +0800
@@ -7,6 +7,7 @@
  * more details.
  */
 
+#include <linux/hexdump.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
 #include <linux/kernel.h>
--- linux-2.6.orig/lib/vsprintf.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/lib/vsprintf.c	2010-02-16 17:33:16.000000000 +0800
@@ -16,6 +16,7 @@
  * - scnprintf and vscnprintf
  */
 
+#include <linux/hexdump.h>
 #include <stdarg.h>
 #include <linux/module.h>
 #include <linux/types.h>
--- linux-2.6.orig/mm/debug-pagealloc.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/mm/debug-pagealloc.c	2010-02-16 17:33:16.000000000 +0800
@@ -1,3 +1,4 @@
+#include <linux/hexdump.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/page-debug-flags.h>
--- linux-2.6.orig/mm/kmemleak.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/mm/kmemleak.c	2010-02-16 17:33:16.000000000 +0800
@@ -63,6 +63,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/hexdump.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
--- linux-2.6.orig/net/ieee802154/af_ieee802154.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/net/ieee802154/af_ieee802154.c	2010-02-16 17:33:16.000000000 +0800
@@ -21,6 +21,7 @@
  * Maxim Gorbachyov <maxim.gorbachev@siemens.com>
  */
 
+#include <linux/hexdump.h>
 #include <linux/net.h>
 #include <linux/capability.h>
 #include <linux/module.h>
--- linux-2.6.orig/net/ipv4/arp.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/net/ipv4/arp.c	2010-02-16 17:33:16.000000000 +0800
@@ -72,6 +72,7 @@
  *		Harald Welte	:	convert to make use of jenkins hash
  */
 
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
--- linux-2.6.orig/net/ipv4/netfilter/ipt_CLUSTERIP.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/net/ipv4/netfilter/ipt_CLUSTERIP.c	2010-02-16 17:33:16.000000000 +0800
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  *
  */
+#include <linux/hexdump.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/jhash.h>
--- linux-2.6.orig/sound/pci/oxygen/xonar_hdmi.c	2010-02-16 17:11:37.000000000 +0800
+++ linux-2.6/sound/pci/oxygen/xonar_hdmi.c	2010-02-16 17:33:16.000000000 +0800
@@ -16,6 +16,7 @@
  *  along with this driver; if not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/hexdump.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <sound/asoundef.h>
--- linux-2.6.orig/drivers/net/wireless/p54/eeprom.c	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wireless/p54/eeprom.c	2010-02-16 17:33:16.000000000 +0800
@@ -16,6 +16,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/hexdump.h>
 #include <linux/init.h>
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
--- linux-2.6.orig/drivers/misc/iwmc3200top/log.h	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/misc/iwmc3200top/log.h	2010-02-16 17:33:16.000000000 +0800
@@ -27,7 +27,7 @@
 #ifndef __LOG_H__
 #define __LOG_H__
 
-
+#include <linux/hexdump.h>
 /* log severity:
  * The log levels here match FW log levels
  * so values need to stay as is */
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-debug.h	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-debug.h	2010-02-16 17:33:16.000000000 +0800
@@ -29,6 +29,7 @@
 #ifndef __iwl_debug_h__
 #define __iwl_debug_h__
 
+#include <linux/hexdump.h>
 struct iwl_priv;
 extern u32 iwl_debug_level;
 
--- linux-2.6.orig/drivers/net/wireless/iwmc3200wifi/debug.h	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/drivers/net/wireless/iwmc3200wifi/debug.h	2010-02-16 17:33:16.000000000 +0800
@@ -24,6 +24,7 @@
 #ifndef __IWM_DEBUG_H__
 #define __IWM_DEBUG_H__
 
+#include <linux/hexdump.h>
 #define IWM_ERR(p, f, a...) dev_err(iwm_to_dev(p), f, ## a)
 #define IWM_WARN(p, f, a...) dev_warn(iwm_to_dev(p), f, ## a)
 #define IWM_INFO(p, f, a...) dev_info(iwm_to_dev(p), f, ## a)
