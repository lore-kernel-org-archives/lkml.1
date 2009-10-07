Return-Path: <linux-kernel-owner+w=401wt.eu-S933560AbZJGNQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560AbZJGNQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933469AbZJGNQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:16:10 -0400
Received: from mail-ew0-f225.google.com ([209.85.219.225]:37562 "EHLO
	mail-ew0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112AbZJGNQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:16:05 -0400
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Oct 2009 09:16:04 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OJB/D6MmFUjTph6cSbTtdY7wgy935j4vc9lESu2hoUBlNXAeAjkE+5+ek3KfsMJzai
         KUuNikOVA6czG7ICY3urejSJ/kGhpy+ueAbRvAszoEKeup64yXKDzHIupj8dK/PMlI0y
         p/cms4mbLbS4vsN7ncFYzgNNF8UGLw5TTBN54=
Date: Wed, 7 Oct 2009 17:09:06 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] headers: remove sched.h from interrupt.h
Message-ID: <20091007130906.GA21924@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After m68k's task_thread_info() doesn't refer to current,
it's possible to remove sched.h from interrupt.h and not break m68k!
Many thanks to Heiko Carstens for allowing this.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/arm/kernel/time.c                          |    1 +
 arch/arm/mach-integrator/pci_v3.c               |    1 +
 arch/arm/plat-s3c24xx/adc.c                     |    1 +
 arch/blackfin/kernel/time.c                     |    1 +
 arch/m32r/kernel/smp.c                          |    1 +
 arch/um/drivers/line.c                          |    1 +
 arch/um/drivers/port_kern.c                     |    1 +
 arch/um/kernel/irq.c                            |    1 +
 arch/x86/kernel/cpu/mcheck/mce_intel.c          |    1 +
 arch/x86/kernel/pci-gart_64.c                   |    1 +
 arch/x86/kernel/reboot.c                        |    1 +
 arch/xtensa/kernel/time.c                       |    1 +
 crypto/aead.c                                   |    1 +
 drivers/char/applicom.c                         |    1 +
 drivers/char/epca.c                             |    1 +
 drivers/char/generic_serial.c                   |    1 +
 drivers/char/istallion.c                        |    1 +
 drivers/char/nozomi.c                           |    1 +
 drivers/char/pty.c                              |    1 +
 drivers/char/rio/riocmd.c                       |    1 +
 drivers/char/rio/rioctrl.c                      |    1 +
 drivers/char/rio/riotty.c                       |    1 +
 drivers/char/ser_a2232.c                        |    1 +
 drivers/char/stallion.c                         |    1 +
 drivers/char/tlclk.c                            |    1 +
 drivers/hwmon/sht15.c                           |    1 +
 drivers/ieee1394/raw1394.c                      |    1 +
 drivers/ieee1394/video1394.c                    |    1 +
 drivers/infiniband/core/iwcm.c                  |    1 +
 drivers/infiniband/core/ucma.c                  |    1 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c     |    1 +
 drivers/infiniband/hw/cxgb3/iwch_qp.c           |    1 +
 drivers/infiniband/hw/ipath/ipath_driver.c      |    1 +
 drivers/infiniband/hw/ipath/ipath_iba7220.c     |    1 +
 drivers/infiniband/hw/ipath/ipath_intr.c        |    1 +
 drivers/infiniband/hw/ipath/ipath_qp.c          |    1 +
 drivers/infiniband/hw/ipath/ipath_ruc.c         |    1 +
 drivers/infiniband/hw/ipath/ipath_ud.c          |    1 +
 drivers/infiniband/hw/ipath/ipath_user_pages.c  |    1 +
 drivers/infiniband/hw/ipath/ipath_user_sdma.c   |    1 +
 drivers/infiniband/hw/ipath/ipath_verbs_mcast.c |    1 +
 drivers/input/keyboard/hilkbd.c                 |    1 +
 drivers/input/keyboard/sunkbd.c                 |    1 +
 drivers/input/serio/libps2.c                    |    1 +
 drivers/input/serio/serio_raw.c                 |    1 +
 drivers/input/serio/serport.c                   |    1 +
 drivers/isdn/capi/kcapi.c                       |    1 +
 drivers/isdn/hisax/arcofi.c                     |    1 +
 drivers/isdn/hisax/hfc_2bds0.c                  |    1 +
 drivers/isdn/hisax/hfc_pci.c                    |    1 +
 drivers/isdn/hysdn/hysdn_procconf.c             |    1 +
 drivers/isdn/hysdn/hysdn_proclog.c              |    1 +
 drivers/isdn/pcbit/drv.c                        |    1 +
 drivers/isdn/pcbit/layer2.c                     |    1 +
 drivers/isdn/sc/init.c                          |    1 +
 drivers/lguest/interrupts_and_traps.c           |    1 +
 drivers/media/dvb/dvb-core/dvb_net.c            |    1 +
 drivers/media/video/meye.c                      |    1 +
 drivers/media/video/videobuf-core.c             |    1 +
 drivers/media/video/videobuf-dma-sg.c           |    1 +
 drivers/message/fusion/mptlan.c                 |    1 +
 drivers/mfd/ucb1x00-core.c                      |    1 +
 drivers/misc/hpilo.c                            |    1 +
 drivers/misc/ibmasm/command.c                   |    1 +
 drivers/misc/ibmasm/event.c                     |    1 +
 drivers/misc/ibmasm/r_heartbeat.c               |    1 +
 drivers/misc/phantom.c                          |    1 +
 drivers/mtd/devices/m25p80.c                    |    1 +
 drivers/mtd/devices/sst25l.c                    |    1 +
 drivers/net/bonding/bond_sysfs.c                |    1 +
 drivers/net/depca.c                             |    1 +
 drivers/net/e100.c                              |    1 +
 drivers/net/eql.c                               |    1 +
 drivers/net/ethoc.c                             |    1 +
 drivers/net/ewrk3.c                             |    1 +
 drivers/net/forcedeth.c                         |    1 +
 drivers/net/hamachi.c                           |    1 +
 drivers/net/hamradio/baycom_epp.c               |    1 +
 drivers/net/hamradio/baycom_ser_fdx.c           |    1 +
 drivers/net/hamradio/baycom_ser_hdx.c           |    1 +
 drivers/net/hamradio/hdlcdrv.c                  |    1 +
 drivers/net/hp100.c                             |    1 +
 drivers/net/igb/igb_ethtool.c                   |    1 +
 drivers/net/irda/toim3232-sir.c                 |    1 +
 drivers/net/ns83820.c                           |    1 +
 drivers/net/pcnet32.c                           |    1 +
 drivers/net/sb1000.c                            |    1 +
 drivers/net/sis900.c                            |    1 +
 drivers/net/skfp/skfddi.c                       |    1 +
 drivers/net/skge.c                              |    1 +
 drivers/net/slip.c                              |    1 +
 drivers/net/sungem.c                            |    1 +
 drivers/net/tokenring/ibmtr.c                   |    1 +
 drivers/net/typhoon.c                           |    1 +
 drivers/net/wan/cosa.c                          |    1 +
 drivers/net/wan/cycx_x25.c                      |    1 +
 drivers/net/wan/dscc4.c                         |    1 +
 drivers/net/wan/farsync.c                       |    1 +
 drivers/net/wireless/b43/pio.c                  |    1 +
 drivers/net/wireless/b43legacy/main.c           |    1 +
 drivers/net/wireless/b43legacy/phy.c            |    1 +
 drivers/net/wireless/hostap/hostap_info.c       |    1 +
 drivers/net/wireless/hostap/hostap_ioctl.c      |    1 +
 drivers/net/wireless/ipw2x00/ipw2200.c          |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c          |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-hcmd.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-tx.c           |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c     |    1 +
 drivers/net/wireless/iwmc3200wifi/cfg80211.c    |    1 +
 drivers/net/wireless/iwmc3200wifi/commands.c    |    1 +
 drivers/net/wireless/iwmc3200wifi/main.c        |    1 +
 drivers/net/wireless/iwmc3200wifi/rx.c          |    1 +
 drivers/net/wireless/libertas/cmd.c             |    1 +
 drivers/net/wireless/libertas/tx.c              |    1 +
 drivers/net/wireless/prism54/isl_ioctl.c        |    1 +
 drivers/net/wireless/prism54/islpci_dev.c       |    1 +
 drivers/net/wireless/prism54/islpci_mgt.c       |    1 +
 drivers/net/wireless/rt2x00/rt2x00debug.c       |    1 +
 drivers/pci/pcie/aer/aerdrv.c                   |    1 +
 drivers/rtc/interface.c                         |    1 +
 drivers/rtc/rtc-dev.c                           |    1 +
 drivers/uio/uio.c                               |    1 +
 drivers/uwb/whc-rc.c                            |    1 +
 fs/file.c                                       |    1 +
 include/linux/interrupt.h                       |    2 +-
 include/linux/mmc/host.h                        |    1 +
 kernel/irq/handle.c                             |    1 +
 kernel/mutex-debug.c                            |    1 +
 kernel/time/timekeeping.c                       |    1 +
 lib/debugobjects.c                              |    1 +
 lib/fault-inject.c                              |    1 +
 mm/vmalloc.c                                    |    1 +
 net/irda/ircomm/ircomm_tty_attach.c             |    1 +
 net/irda/irlan/irlan_common.c                   |    1 +
 net/irda/irlan/irlan_eth.c                      |    1 +
 net/irda/irnet/irnet_irda.c                     |    1 +
 net/irda/irnet/irnet_ppp.c                      |    1 +
 net/mac80211/rc80211_pid_debugfs.c              |    1 +
 net/netfilter/nf_conntrack_core.c               |    1 +
 net/sunrpc/xprtrdma/svc_rdma_transport.c        |    1 +
 net/wireless/core.c                             |    1 +
 145 files changed, 145 insertions(+), 1 deletion(-)

--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/timex.h>
 #include <linux/errno.h>
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -31,6 +31,7 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
+#include <asm/signal.h>
 #include <asm/system.h>
 #include <asm/mach/pci.h>
 #include <asm/irq_regs.h>
--- a/arch/arm/plat-s3c24xx/adc.c
+++ b/arch/arm/plat-s3c24xx/adc.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
+#include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/err.h>
 #include <linux/clk.h>
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -14,6 +14,7 @@
 #include <linux/time.h>
 #include <linux/irq.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 
 #include <asm/blackfin.h>
 #include <asm/time.h>
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -17,6 +17,7 @@
 
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -5,6 +5,7 @@
 
 #include "linux/irqreturn.h"
 #include "linux/kd.h"
+#include "linux/sched.h"
 #include "chan_kern.h"
 #include "irq_kern.h"
 #include "irq_user.h"
--- a/arch/um/drivers/port_kern.c
+++ b/arch/um/drivers/port_kern.c
@@ -7,6 +7,7 @@
 #include "linux/interrupt.h"
 #include "linux/list.h"
 #include "linux/mutex.h"
+#include "linux/workqueue.h"
 #include "asm/atomic.h"
 #include "init.h"
 #include "irq_kern.h"
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -10,6 +10,7 @@
 #include "linux/interrupt.h"
 #include "linux/kernel_stat.h"
 #include "linux/module.h"
+#include "linux/sched.h"
 #include "linux/seq_file.h"
 #include "as-layout.h"
 #include "kern_util.h"
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/percpu.h>
+#include <linux/sched.h>
 #include <asm/apic.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -16,6 +16,7 @@
 #include <linux/agp_backend.h>
 #include <linux/init.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -4,6 +4,7 @@
 #include <linux/pm.h>
 #include <linux/efi.h>
 #include <linux/dmi.h>
+#include <linux/sched.h>
 #include <linux/tboot.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -30,6 +30,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/serial.h>
 #include <linux/delay.h>
 #include <linux/ctype.h>
--- a/drivers/char/generic_serial.c
+++ b/drivers/char/generic_serial.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/tty.h>
+#include <linux/sched.h>
 #include <linux/serial.h>
 #include <linux/mm.h>
 #include <linux/generic_serial.h>
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -19,6 +19,7 @@
 /*****************************************************************************/
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/interrupt.h>
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -48,6 +48,7 @@
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
+#include <linux/sched.h>
 #include <linux/serial.h>
 #include <linux/interrupt.h>
 #include <linux/kmod.h>
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -18,6 +18,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/fcntl.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/major.h>
 #include <linux/mm.h>
--- a/drivers/char/rio/riocmd.c
+++ b/drivers/char/rio/riocmd.c
@@ -32,6 +32,7 @@
 */
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/tty.h>
--- a/drivers/char/rio/rioctrl.c
+++ b/drivers/char/rio/rioctrl.c
@@ -31,6 +31,7 @@
 */
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <asm/io.h>
--- a/drivers/char/rio/riotty.c
+++ b/drivers/char/rio/riotty.c
@@ -33,6 +33,7 @@
 #define __EXPLICIT_DEF_H__
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/tty.h>
--- a/drivers/char/ser_a2232.c
+++ b/drivers/char/ser_a2232.c
@@ -89,6 +89,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/sched.h>
 #include <linux/tty.h>
 
 #include <asm/setup.h>
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -27,6 +27,7 @@
 /*****************************************************************************/
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
--- a/drivers/char/tlclk.c
+++ b/drivers/char/tlclk.c
@@ -32,6 +32,7 @@
 #include <linux/kernel.h>	/* printk() */
 #include <linux/fs.h>		/* everything... */
 #include <linux/errno.h>	/* error codes */
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -30,6 +30,7 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
+#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
 #include <linux/err.h>
--- a/drivers/ieee1394/raw1394.c
+++ b/drivers/ieee1394/raw1394.c
@@ -29,6 +29,7 @@
 
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
--- a/drivers/ieee1394/video1394.c
+++ b/drivers/ieee1394/video1394.c
@@ -30,6 +30,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/wait.h>
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -40,6 +40,7 @@
 #include <linux/idr.h>
 #include <linux/interrupt.h>
 #include <linux/rbtree.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/completion.h>
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -34,6 +34,7 @@
 #include <linux/file.h>
 #include <linux/mutex.h>
 #include <linux/poll.h>
+#include <linux/sched.h>
 #include <linux/idr.h>
 #include <linux/in.h>
 #include <linux/in6.h>
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -37,6 +37,7 @@
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/list.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/ethtool.h>
 #include <linux/rtnetlink.h>
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -29,6 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
+#include <linux/sched.h>
 #include "iwch_provider.h"
 #include "iwch.h"
 #include "iwch_cm.h"
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -31,6 +31,7 @@
  * SOFTWARE.
  */
 
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/idr.h>
 #include <linux/pci.h>
--- a/drivers/infiniband/hw/ipath/ipath_iba7220.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba7220.c
@@ -37,6 +37,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <rdma/ib_verbs.h>
--- a/drivers/infiniband/hw/ipath/ipath_intr.c
+++ b/drivers/infiniband/hw/ipath/ipath_intr.c
@@ -33,6 +33,7 @@
 
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 
 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
--- a/drivers/infiniband/hw/ipath/ipath_qp.c
+++ b/drivers/infiniband/hw/ipath/ipath_qp.c
@@ -32,6 +32,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/sched.h>
 #include <linux/vmalloc.h>
 
 #include "ipath_verbs.h"
--- a/drivers/infiniband/hw/ipath/ipath_ruc.c
+++ b/drivers/infiniband/hw/ipath/ipath_ruc.c
@@ -31,6 +31,7 @@
  * SOFTWARE.
  */
 
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 
 #include "ipath_verbs.h"
--- a/drivers/infiniband/hw/ipath/ipath_ud.c
+++ b/drivers/infiniband/hw/ipath/ipath_ud.c
@@ -31,6 +31,7 @@
  * SOFTWARE.
  */
 
+#include <linux/sched.h>
 #include <rdma/ib_smi.h>
 
 #include "ipath_verbs.h"
--- a/drivers/infiniband/hw/ipath/ipath_user_pages.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_pages.c
@@ -33,6 +33,7 @@
 
 #include <linux/mm.h>
 #include <linux/device.h>
+#include <linux/sched.h>
 
 #include "ipath_kernel.h"
 
--- a/drivers/infiniband/hw/ipath/ipath_user_sdma.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_sdma.c
@@ -33,6 +33,7 @@
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/dmapool.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/highmem.h>
--- a/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c
@@ -32,6 +32,7 @@
  */
 
 #include <linux/rculist.h>
+#include <linux/sched.h>
 
 #include "ipath_verbs.h"
 
--- a/drivers/input/keyboard/hilkbd.c
+++ b/drivers/input/keyboard/hilkbd.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/hil.h>
 #include <linux/io.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <asm/irq.h>
 #ifdef CONFIG_HP300
--- a/drivers/input/keyboard/sunkbd.c
+++ b/drivers/input/keyboard/sunkbd.c
@@ -27,6 +27,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
--- a/drivers/input/serio/libps2.c
+++ b/drivers/input/serio/libps2.c
@@ -13,6 +13,7 @@
 
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -9,6 +9,7 @@
  * the Free Software Foundation.
  */
 
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/poll.h>
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -15,6 +15,7 @@
 
 #include <asm/uaccess.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
--- a/drivers/isdn/hisax/arcofi.c
+++ b/drivers/isdn/hisax/arcofi.c
@@ -10,6 +10,7 @@
  *
  */
  
+#include <linux/sched.h>
 #include "hisax.h"
 #include "isdnl1.h"
 #include "isac.h"
--- a/drivers/isdn/hisax/hfc_2bds0.c
+++ b/drivers/isdn/hisax/hfc_2bds0.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/sched.h>
 #include "hisax.h"
 #include "hfc_2bds0.h"
 #include "isdnl1.h"
--- a/drivers/isdn/hisax/hfc_pci.c
+++ b/drivers/isdn/hisax/hfc_pci.c
@@ -20,6 +20,7 @@
 #include "hfc_pci.h"
 #include "isdnl1.h"
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/interrupt.h>
 
 static const char *hfcpci_revision = "$Revision: 1.48.2.4 $";
--- a/drivers/isdn/hysdn/hysdn_procconf.c
+++ b/drivers/isdn/hysdn/hysdn_procconf.c
@@ -11,6 +11,7 @@
  *
  */
 
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
--- a/drivers/isdn/hysdn/hysdn_proclog.c
+++ b/drivers/isdn/hysdn/hysdn_proclog.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
+#include <linux/sched.h>
 #include <linux/smp_lock.h>
 
 #include "hysdn_defs.h"
--- a/drivers/isdn/pcbit/drv.c
+++ b/drivers/isdn/pcbit/drv.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 
 #include <linux/types.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
--- a/drivers/isdn/pcbit/layer2.c
+++ b/drivers/isdn/pcbit/layer2.c
@@ -27,6 +27,7 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
--- a/drivers/isdn/sc/init.c
+++ b/drivers/isdn/sc/init.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include "includes.h"
 #include "hardware.h"
 #include "card.h"
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -16,6 +16,7 @@
 #include <linux/uaccess.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include "lg.h"
 
 /* Allow Guests to use a non-128 (ie. non-Linux) syscall trap. */
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -63,6 +63,7 @@
 #include <asm/uaccess.h>
 #include <linux/crc32.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 
 #include "dvb_demux.h"
 #include "dvb_net.h"
--- a/drivers/media/video/meye.c
+++ b/drivers/media/video/meye.c
@@ -28,6 +28,7 @@
  */
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/videodev.h>
 #include <media/v4l2-common.h>
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -56,6 +56,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/sched.h>
 
 #define my_VERSION	MPT_LINUX_VERSION_COMMON
 #define MYNAM		"mptlan"
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -18,6 +18,7 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/errno.h>
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -18,6 +18,7 @@
 #include <linux/device.h>
 #include <linux/file.h>
 #include <linux/cdev.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/uaccess.h>
--- a/drivers/misc/ibmasm/command.c
+++ b/drivers/misc/ibmasm/command.c
@@ -22,6 +22,7 @@
  *
  */
 
+#include <linux/sched.h>
 #include "ibmasm.h"
 #include "lowlevel.h"
 
--- a/drivers/misc/ibmasm/event.c
+++ b/drivers/misc/ibmasm/event.c
@@ -22,6 +22,7 @@
  *
  */
 
+#include <linux/sched.h>
 #include "ibmasm.h"
 #include "lowlevel.h"
 
--- a/drivers/misc/ibmasm/r_heartbeat.c
+++ b/drivers/misc/ibmasm/r_heartbeat.c
@@ -20,6 +20,7 @@
  *
  */
 
+#include <linux/sched.h>
 #include "ibmasm.h"
 #include "dot_command.h"
 
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -22,6 +22,7 @@
 #include <linux/interrupt.h>
 #include <linux/cdev.h>
 #include <linux/phantom.h>
+#include <linux/sched.h>
 #include <linux/smp_lock.h>
 
 #include <asm/atomic.h>
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
 #include <linux/math64.h>
+#include <linux/sched.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
--- a/drivers/mtd/devices/sst25l.c
+++ b/drivers/mtd/devices/sst25l.c
@@ -20,6 +20,7 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/sched.h>
 #include <linux/sysdev.h>
 #include <linux/fs.h>
 #include <linux/types.h>
--- a/drivers/net/depca.c
+++ b/drivers/net/depca.c
@@ -237,6 +237,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -151,6 +151,7 @@
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/init.h>
--- a/drivers/net/eql.c
+++ b/drivers/net/eql.c
@@ -111,6 +111,7 @@
  * Sorry, I had to rewrite most of this for 2.5.x -DaveM
  */
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
--- a/drivers/net/ethoc.c
+++ b/drivers/net/ethoc.c
@@ -17,6 +17,7 @@
 #include <linux/mii.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
+#include <linux/sched.h>
 #include <net/ethoc.h>
 
 /* register offsets */
--- a/drivers/net/ewrk3.c
+++ b/drivers/net/ewrk3.c
@@ -145,6 +145,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -49,6 +49,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/ethtool.h>
 #include <linux/timer.h>
--- a/drivers/net/hamachi.c
+++ b/drivers/net/hamachi.c
@@ -145,6 +145,7 @@ static int tx_params[MAX_UNITS] = {-1, -1, -1, -1, -1, -1, -1, -1};
 /* Time in jiffies before concluding the transmitter is hung. */
 #define TX_TIMEOUT  (5*HZ)
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -44,6 +44,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/workqueue.h>
 #include <linux/fs.h>
--- a/drivers/net/hamradio/baycom_ser_fdx.c
+++ b/drivers/net/hamradio/baycom_ser_fdx.c
@@ -71,6 +71,7 @@
 
 /*****************************************************************************/
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
 #include <linux/string.h>
--- a/drivers/net/hamradio/baycom_ser_hdx.c
+++ b/drivers/net/hamradio/baycom_ser_hdx.c
@@ -61,6 +61,7 @@
 
 /*****************************************************************************/
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
 #include <linux/string.h>
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -42,6 +42,7 @@
 
 /*****************************************************************************/
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/net.h>
--- a/drivers/net/hp100.c
+++ b/drivers/net/hp100.c
@@ -98,6 +98,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
--- a/drivers/net/igb/igb_ethtool.c
+++ b/drivers/net/igb/igb_ethtool.c
@@ -34,6 +34,7 @@
 #include <linux/interrupt.h>
 #include <linux/if_ether.h>
 #include <linux/ethtool.h>
+#include <linux/sched.h>
 
 #include "igb.h"
 
--- a/drivers/net/irda/toim3232-sir.c
+++ b/drivers/net/irda/toim3232-sir.c
@@ -120,6 +120,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 
 #include <net/irda/irda.h>
 
--- a/drivers/net/ns83820.c
+++ b/drivers/net/ns83820.c
@@ -111,6 +111,7 @@
 #include <linux/compiler.h>
 #include <linux/prefetch.h>
 #include <linux/ethtool.h>
+#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/if_vlan.h>
 #include <linux/rtnetlink.h>
--- a/drivers/net/pcnet32.c
+++ b/drivers/net/pcnet32.c
@@ -31,6 +31,7 @@ static const char *const version =
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
--- a/drivers/net/sb1000.c
+++ b/drivers/net/sb1000.c
@@ -36,6 +36,7 @@ static char version[] = "sb1000.c:v1.1.2 6/01/98 (fventuri@mediaone.net)\n";
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -52,6 +52,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/errno.h>
--- a/drivers/net/skfp/skfddi.c
+++ b/drivers/net/skfp/skfddi.c
@@ -73,6 +73,7 @@ static const char * const boot_msg =
 
 /* Include files */
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
--- a/drivers/net/skge.c
+++ b/drivers/net/skge.c
@@ -37,6 +37,7 @@
 #include <linux/crc32.h>
 #include <linux/dma-mapping.h>
 #include <linux/debugfs.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/mii.h>
 #include <asm/irq.h>
--- a/drivers/net/slip.c
+++ b/drivers/net/slip.c
@@ -67,6 +67,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/bitops.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -38,6 +38,7 @@
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/in.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/delay.h>
--- a/drivers/net/tokenring/ibmtr.c
+++ b/drivers/net/tokenring/ibmtr.c
@@ -108,6 +108,7 @@ in the event that chatty debug messages are desired - jjs 12/30/98 */
 #define IBMTR_DEBUG_MESSAGES 0
 
 #include <linux/module.h>
+#include <linux/sched.h>
 
 #ifdef PCMCIA		/* required for ibmtr_cs.c to build */
 #undef MODULE		/* yes, really */
--- a/drivers/net/typhoon.c
+++ b/drivers/net/typhoon.c
@@ -108,6 +108,7 @@ static const int multicast_filter_limit = 32;
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/errno.h>
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -76,6 +76,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/fs.h>
--- a/drivers/net/wan/cycx_x25.c
+++ b/drivers/net/wan/cycx_x25.c
@@ -84,6 +84,7 @@
 #include <linux/kernel.h>	/* printk(), and other useful stuff */
 #include <linux/module.h>
 #include <linux/string.h>	/* inline memset(), etc. */
+#include <linux/sched.h>
 #include <linux/slab.h>		/* kmalloc(), kfree() */
 #include <linux/stddef.h>	/* offsetof(), etc. */
 #include <linux/wanrouter.h>	/* WAN router definitions */
--- a/drivers/net/wan/dscc4.c
+++ b/drivers/net/wan/dscc4.c
@@ -81,6 +81,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/list.h>
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/version.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/if.h>
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -30,6 +30,7 @@
 #include "xmit.h"
 
 #include <linux/delay.h>
+#include <linux/sched.h>
 
 
 static u16 generate_cookie(struct b43_pio_txqueue *q,
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -37,6 +37,7 @@
 #include <linux/firmware.h>
 #include <linux/wireless.h>
 #include <linux/workqueue.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/dma-mapping.h>
 #include <net/dst.h>
--- a/drivers/net/wireless/b43legacy/phy.c
+++ b/drivers/net/wireless/b43legacy/phy.c
@@ -31,6 +31,7 @@
 
 #include <linux/delay.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/types.h>
 
 #include "b43legacy.h"
--- a/drivers/net/wireless/hostap/hostap_info.c
+++ b/drivers/net/wireless/hostap/hostap_info.c
@@ -1,6 +1,7 @@
 /* Host AP driver Info Frame processing (part of hostap.o module) */
 
 #include <linux/if_arp.h>
+#include <linux/sched.h>
 #include "hostap_wlan.h"
 #include "hostap.h"
 #include "hostap_ap.h"
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -1,6 +1,7 @@
 /* ioctl() (mostly Linux Wireless Extensions) routines for Host AP driver */
 
 #include <linux/types.h>
+#include <linux/sched.h>
 #include <linux/ethtool.h>
 #include <linux/if_arp.h>
 #include <net/lib80211.h>
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -30,6 +30,7 @@
 
 ******************************************************************************/
 
+#include <linux/sched.h>
 #include "ipw2200.h"
 
 
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -30,6 +30,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -30,6 +30,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -29,6 +29,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -33,6 +33,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -29,6 +29,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/etherdevice.h>
+#include <linux/sched.h>
 #include <net/mac80211.h>
 
 #include "iwl-eeprom.h"
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -28,6 +28,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <net/mac80211.h>
 
 #include "iwl-dev.h" /* FIXME: remove */
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -28,6 +28,7 @@
  *****************************************************************************/
 
 #include <linux/etherdevice.h>
+#include <linux/sched.h>
 #include <net/mac80211.h>
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -33,6 +33,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -23,6 +23,7 @@
 
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/sched.h>
 #include <linux/etherdevice.h>
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -40,6 +40,7 @@
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
 #include <linux/ieee80211.h>
+#include <linux/sched.h>
 
 #include "iwm.h"
 #include "bus.h"
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -38,6 +38,7 @@
 
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/sched.h>
 #include <linux/ieee80211.h>
 #include <linux/wireless.h>
 
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -38,6 +38,7 @@
 
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/sched.h>
 #include <linux/etherdevice.h>
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -6,6 +6,7 @@
 #include <net/iw_handler.h>
 #include <net/lib80211.h>
 #include <linux/kfifo.h>
+#include <linux/sched.h>
 #include "host.h"
 #include "hostcmd.h"
 #include "decl.h"
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -3,6 +3,7 @@
   */
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/sched.h>
 
 #include "hostcmd.h"
 #include "radiotap.h"
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/if_arp.h>
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -23,6 +23,7 @@
 #include <linux/netdevice.h>
 #include <linux/ethtool.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
 #include <linux/if_arp.h>
--- a/drivers/net/wireless/prism54/islpci_mgt.c
+++ b/drivers/net/wireless/prism54/islpci_mgt.c
@@ -20,6 +20,7 @@
 #include <linux/netdevice.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/poll.h>
+#include <linux/sched.h>
 #include <linux/uaccess.h>
 
 #include "rt2x00.h"
--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -17,6 +17,7 @@
 
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/pm.h>
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -12,6 +12,7 @@
 */
 
 #include <linux/rtc.h>
+#include <linux/sched.h>
 #include <linux/log2.h>
 
 int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm)
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/rtc.h>
+#include <linux/sched.h>
 #include "rtc-core.h"
 
 static dev_t rtc_devt;
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -19,6 +19,7 @@
 #include <linux/device.h>
 #include <linux/mm.h>
 #include <linux/idr.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/kobject.h>
 #include <linux/uio_driver.h>
--- a/drivers/uwb/whc-rc.c
+++ b/drivers/uwb/whc-rc.c
@@ -42,6 +42,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
--- a/fs/file.c
+++ b/fs/file.c
@@ -10,6 +10,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/time.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/file.h>
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -10,7 +10,6 @@
 #include <linux/irqreturn.h>
 #include <linux/irqnr.h>
 #include <linux/hardirq.h>
-#include <linux/sched.h>
 #include <linux/irqflags.h>
 #include <linux/smp.h>
 #include <linux/percpu.h>
@@ -610,6 +609,7 @@ extern void debug_poll_all_shared_irqs(void);
 static inline void debug_poll_all_shared_irqs(void) { }
 #endif
 
+struct seq_file;
 int show_interrupts(struct seq_file *p, void *v);
 
 struct irq_desc;
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -11,6 +11,7 @@
 #define LINUX_MMC_HOST_H
 
 #include <linux/leds.h>
+#include <linux/sched.h>
 
 #include <linux/mmc/core.h>
 
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/irq.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/random.h>
--- a/kernel/mutex-debug.c
+++ b/kernel/mutex-debug.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/poison.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/kallsyms.h>
 #include <linux/interrupt.h>
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -13,6 +13,7 @@
 #include <linux/percpu.h>
 #include <linux/init.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/sysdev.h>
 #include <linux/clocksource.h>
 #include <linux/jiffies.h>
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -9,6 +9,7 @@
  */
 #include <linux/debugobjects.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/hash.h>
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/random.h>
+#include <linux/sched.h>
 #include <linux/stat.h>
 #include <linux/types.h>
 #include <linux/fs.h>
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/highmem.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
--- a/net/irda/ircomm/ircomm_tty_attach.c
+++ b/net/irda/ircomm/ircomm_tty_attach.c
@@ -30,6 +30,7 @@
  ********************************************************************/
 
 #include <linux/init.h>
+#include <linux/sched.h>
 
 #include <net/irda/irda.h>
 #include <net/irda/irlmp.h>
--- a/net/irda/irlan/irlan_common.c
+++ b/net/irda/irlan/irlan_common.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/proc_fs.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/random.h>
 #include <linux/netdevice.h>
--- a/net/irda/irlan/irlan_eth.c
+++ b/net/irda/irlan/irlan_eth.c
@@ -30,6 +30,7 @@
 #include <linux/inetdevice.h>
 #include <linux/if_arp.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <net/arp.h>
 
 #include <net/irda/irda.h>
--- a/net/irda/irnet/irnet_irda.c
+++ b/net/irda/irnet/irnet_irda.c
@@ -9,6 +9,7 @@
  */
 
 #include "irnet_irda.h"		/* Private header */
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <asm/unaligned.h>
 
--- a/net/irda/irnet/irnet_ppp.c
+++ b/net/irda/irnet/irnet_ppp.c
@@ -13,6 +13,7 @@
  *	2) as a control channel (write commands, read events)
  */
 
+#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include "irnet_ppp.h"		/* Private header */
 /* Please put other headers in irnet.h - Thanks */
--- a/net/mac80211/rc80211_pid_debugfs.c
+++ b/net/mac80211/rc80211_pid_debugfs.c
@@ -6,6 +6,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/poll.h>
 #include <linux/netdevice.h>
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/netfilter.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -42,6 +42,7 @@
 #include <linux/sunrpc/svc_xprt.h>
 #include <linux/sunrpc/debug.h>
 #include <linux/sunrpc/rpc_rdma.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/rdma_cm.h>
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -14,6 +14,7 @@
 #include <linux/device.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
+#include <linux/sched.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include "nl80211.h"
