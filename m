Return-Path: <linux-kernel-owner+w=401wt.eu-S1751424AbZGNKzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbZGNKzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbZGNKzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:55:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57233 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbZGNKza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:55:30 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 14 Jul 2009 16:25:16 +0530
Subject: [PATCH v2 2/2] trivial: fix typo "to to" in multiple files
Thread-Topic: [PATCH v2 2/2] trivial: fix typo "to to" in multiple files
Thread-Index: AcoBOfwRSpqSn7A6Qgim+cNofbHONQDN2vFA
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB0305D662B5@dbde02.ent.ti.com>
References: <5A47E75E594F054BAF48C5E4FC4B92AB0305C11456@dbde02.ent.ti.com>
 <alpine.LNX.2.00.0907101038060.27327@wotan.suse.de>
In-Reply-To: <alpine.LNX.2.00.0907101038060.27327@wotan.suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anand Gadiyar <gadiyar@ti.com>

trivial: fix typo "to to" in multiple files

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
---
v2: Rebased on current Linus' tree (commit 6847e154e3)

 Documentation/hwmon/pc87427                  |    2 +-
 Documentation/networking/regulatory.txt      |    2 +-
 Documentation/scsi/scsi_fc_transport.txt     |    2 +-
 arch/ia64/ia32/sys_ia32.c                    |    2 +-
 arch/um/include/shared/ptrace_user.h         |    2 +-
 drivers/char/agp/uninorth-agp.c              |    2 +-
 drivers/gpu/drm/mga/mga_state.c              |    4 ++--
 drivers/lguest/page_tables.c                 |    2 +-
 drivers/media/video/gspca/m5602/m5602_core.c |    2 +-
 drivers/mmc/host/mxcmmc.c                    |    2 +-
 drivers/mtd/maps/ixp2000.c                   |    2 +-
 drivers/mtd/ubi/eba.c                        |    2 +-
 drivers/mtd/ubi/ubi.h                        |    2 +-
 drivers/net/bonding/bond_3ad.c               |    2 +-
 drivers/net/e1000/e1000_hw.c                 |    2 +-
 drivers/net/wireless/zd1211rw/zd_chip.c      |    2 +-
 drivers/scsi/megaraid/megaraid_sas.c         |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c                |    4 ++--
 drivers/staging/rt2860/rtmp.h                |    2 +-
 drivers/usb/serial/cypress_m8.h              |    2 +-
 drivers/usb/serial/io_edgeport.c             |    2 +-
 drivers/usb/serial/kl5kusb105.c              |    2 +-
 fs/ext4/inode.c                              |    2 +-
 fs/gfs2/rgrp.c                               |    2 +-
 fs/ntfs/layout.h                             |    2 +-
 include/acpi/actypes.h                       |    2 +-
 include/acpi/platform/acgcc.h                |    2 +-
 include/rdma/ib_cm.h                         |    2 +-
 kernel/tracepoint.c                          |    2 +-
 lib/zlib_deflate/deflate.c                   |    4 ++--
 net/rxrpc/ar-call.c                          |    2 +-
 net/sched/sch_hfsc.c                         |    2 +-
 32 files changed, 35 insertions(+), 35 deletions(-)

Index: linux-2.6/Documentation/hwmon/pc87427
===================================================================
--- linux-2.6.orig/Documentation/hwmon/pc87427
+++ linux-2.6/Documentation/hwmon/pc87427
@@ -34,5 +34,5 @@ Fan rotation speeds are reported as 14-b
 signal. Speeds down to 83 RPM can be measured.

 An alarm is triggered if the rotation speed drops below a programmable
-limit. Another alarm is triggered if the speed is too low to to be measured
+limit. Another alarm is triggered if the speed is too low to be measured
 (including stalled or missing fan).
Index: linux-2.6/Documentation/networking/regulatory.txt
===================================================================
--- linux-2.6.orig/Documentation/networking/regulatory.txt
+++ linux-2.6/Documentation/networking/regulatory.txt
@@ -96,7 +96,7 @@ Example code - drivers hinting an alpha2

 This example comes from the zd1211rw device driver. You can start
 by having a mapping of your device's EEPROM country/regulatory
-domain value to to a specific alpha2 as follows:
+domain value to a specific alpha2 as follows:

 static struct zd_reg_alpha2_map reg_alpha2_map[] = {
        { ZD_REGDOMAIN_FCC, "US" },
Index: linux-2.6/Documentation/scsi/scsi_fc_transport.txt
===================================================================
--- linux-2.6.orig/Documentation/scsi/scsi_fc_transport.txt
+++ linux-2.6/Documentation/scsi/scsi_fc_transport.txt
@@ -378,7 +378,7 @@ Vport Disable/Enable:
       int vport_disable(struct fc_vport *vport, bool disable)

     where:
-      vport:    Is vport to to be enabled or disabled
+      vport:    Is vport to be enabled or disabled
       disable:  If "true", the vport is to be disabled.
                 If "false", the vport is to be enabled.

Index: linux-2.6/arch/ia64/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/sys_ia32.c
+++ linux-2.6/arch/ia64/ia32/sys_ia32.c
@@ -1270,7 +1270,7 @@ putreg (struct task_struct *child, int r
              case PT_CS:
                if (value != __USER_CS)
                        printk(KERN_ERR
-                              "ia32.putreg: attempt to to set invalid segment register %d = %x\n",
+                              "ia32.putreg: attempt to set invalid segment register %d = %x\n",
                               regno, value);
                break;
              default:
Index: linux-2.6/arch/um/include/shared/ptrace_user.h
===================================================================
--- linux-2.6.orig/arch/um/include/shared/ptrace_user.h
+++ linux-2.6/arch/um/include/shared/ptrace_user.h
@@ -29,7 +29,7 @@ extern int ptrace_setregs(long pid, unsi
  * recompilation. So, we use PTRACE_OLDSETOPTIONS in UML.
  * We also want to be able to build the kernel on 2.4, which doesn't
  * have PTRACE_OLDSETOPTIONS. So, if it is missing, we declare
- * PTRACE_OLDSETOPTIONS to to be the same as PTRACE_SETOPTIONS.
+ * PTRACE_OLDSETOPTIONS to be the same as PTRACE_SETOPTIONS.
  *
  * On architectures, that start to support PTRACE_O_TRACESYSGOOD on
  * linux 2.6, PTRACE_OLDSETOPTIONS never is defined, and also isn't
Index: linux-2.6/drivers/char/agp/uninorth-agp.c
===================================================================
--- linux-2.6.orig/drivers/char/agp/uninorth-agp.c
+++ linux-2.6/drivers/char/agp/uninorth-agp.c
@@ -271,7 +271,7 @@ static void uninorth_agp_enable(struct a

        if ((uninorth_rev >= 0x30) && (uninorth_rev <= 0x33)) {
                /*
-                * We need to to set REQ_DEPTH to 7 for U3 versions 1.0, 2.1,
+                * We need to set REQ_DEPTH to 7 for U3 versions 1.0, 2.1,
                 * 2.2 and 2.3, Darwin do so.
                 */
                if ((command >> AGPSTAT_RQ_DEPTH_SHIFT) > 7)
Index: linux-2.6/drivers/gpu/drm/mga/mga_state.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/mga/mga_state.c
+++ linux-2.6/drivers/gpu/drm/mga/mga_state.c
@@ -239,7 +239,7 @@ static __inline__ void mga_g200_emit_pip
                  MGA_WR34, 0x00000000,
                  MGA_WR42, 0x0000ffff, MGA_WR60, 0x0000ffff);

-       /* Padding required to to hardware bug.
+       /* Padding required due to hardware bug.
         */
        DMA_BLOCK(MGA_DMAPAD, 0xffffffff,
                  MGA_DMAPAD, 0xffffffff,
@@ -317,7 +317,7 @@ static __inline__ void mga_g400_emit_pip
                  MGA_WR52, MGA_G400_WR_MAGIC,  /* tex1 width        */
                  MGA_WR60, MGA_G400_WR_MAGIC); /* tex1 height       */

-       /* Padding required to to hardware bug */
+       /* Padding required due to hardware bug */
        DMA_BLOCK(MGA_DMAPAD, 0xffffffff,
                  MGA_DMAPAD, 0xffffffff,
                  MGA_DMAPAD, 0xffffffff,
Index: linux-2.6/drivers/lguest/page_tables.c
===================================================================
--- linux-2.6.orig/drivers/lguest/page_tables.c
+++ linux-2.6/drivers/lguest/page_tables.c
@@ -780,7 +780,7 @@ void guest_set_pte(struct lg_cpu *cpu,
  * tells us they've changed.  When the Guest tries to use the new entry it will
  * fault and demand_page() will fix it up.
  *
- * So with that in mind here's our code to to update a (top-level) PGD entry:
+ * So with that in mind here's our code to update a (top-level) PGD entry:
  */
 void guest_set_pgd(struct lguest *lg, unsigned long gpgdir, u32 idx)
 {
Index: linux-2.6/drivers/media/video/gspca/m5602/m5602_core.c
===================================================================
--- linux-2.6.orig/drivers/media/video/gspca/m5602/m5602_core.c
+++ linux-2.6/drivers/media/video/gspca/m5602/m5602_core.c
@@ -56,7 +56,7 @@ int m5602_read_bridge(struct sd *sd, con
        return (err < 0) ? err : 0;
 }

-/* Writes a byte to to the m5602 */
+/* Writes a byte to the m5602 */
 int m5602_write_bridge(struct sd *sd, const u8 address, const u8 i2c_data)
 {
        int err;
Index: linux-2.6/drivers/mmc/host/mxcmmc.c
===================================================================
--- linux-2.6.orig/drivers/mmc/host/mxcmmc.c
+++ linux-2.6/drivers/mmc/host/mxcmmc.c
@@ -512,7 +512,7 @@ static void mxcmci_cmd_done(struct mxcmc
        }

        /* For the DMA case the DMA engine handles the data transfer
-        * automatically. For non DMA we have to to it ourselves.
+        * automatically. For non DMA we have to do it ourselves.
         * Don't do it in interrupt context though.
         */
        if (!mxcmci_use_dma(host) && host->data)
Index: linux-2.6/drivers/mtd/maps/ixp2000.c
===================================================================
--- linux-2.6.orig/drivers/mtd/maps/ixp2000.c
+++ linux-2.6/drivers/mtd/maps/ixp2000.c
@@ -184,7 +184,7 @@ static int ixp2000_flash_probe(struct pl
        info->map.bankwidth = 1;

        /*
-        * map_priv_2 is used to store a ptr to to the bank_setup routine
+        * map_priv_2 is used to store a ptr to the bank_setup routine
         */
        info->map.map_priv_2 = (unsigned long) ixp_data->bank_setup;

Index: linux-2.6/drivers/mtd/ubi/eba.c
===================================================================
--- linux-2.6.orig/drivers/mtd/ubi/eba.c
+++ linux-2.6/drivers/mtd/ubi/eba.c
@@ -1065,7 +1065,7 @@ int ubi_eba_copy_leb(struct ubi_device *
        }

        /*
-        * Now we have got to calculate how much data we have to to copy. In
+        * Now we have got to calculate how much data we have to copy. In
         * case of a static volume it is fairly easy - the VID header contains
         * the data size. In case of a dynamic volume it is more difficult - we
         * have to read the contents, cut 0xFF bytes from the end and copy only
Index: linux-2.6/drivers/mtd/ubi/ubi.h
===================================================================
--- linux-2.6.orig/drivers/mtd/ubi/ubi.h
+++ linux-2.6/drivers/mtd/ubi/ubi.h
@@ -570,7 +570,7 @@ void ubi_do_get_volume_info(struct ubi_d

 /*
  * ubi_rb_for_each_entry - walk an RB-tree.
- * @rb: a pointer to type 'struct rb_node' to to use as a loop counter
+ * @rb: a pointer to type 'struct rb_node' to use as a loop counter
  * @pos: a pointer to RB-tree entry type to use as a loop counter
  * @root: RB-tree's root
  * @member: the name of the 'struct rb_node' within the RB-tree entry
Index: linux-2.6/drivers/net/bonding/bond_3ad.c
===================================================================
--- linux-2.6.orig/drivers/net/bonding/bond_3ad.c
+++ linux-2.6/drivers/net/bonding/bond_3ad.c
@@ -1982,7 +1982,7 @@ void bond_3ad_unbind_slave(struct slave
                        // find new aggregator for the related port(s)
                        new_aggregator = __get_first_agg(port);
                        for (; new_aggregator; new_aggregator = __get_next_agg(new_aggregator)) {
-                               // if the new aggregator is empty, or it connected to to our port only
+                               // if the new aggregator is empty, or it is connected to our port only
                                if (!new_aggregator->lag_ports || ((new_aggregator->lag_ports == port) && !new_aggregator->lag_ports->next_port_in_aggregator)) {
                                        break;
                                }
Index: linux-2.6/drivers/net/e1000/e1000_hw.c
===================================================================
--- linux-2.6.orig/drivers/net/e1000/e1000_hw.c
+++ linux-2.6/drivers/net/e1000/e1000_hw.c
@@ -3035,7 +3035,7 @@ s32 e1000_check_for_link(struct e1000_hw
                 /* If TBI compatibility is was previously off, turn it on. For
                  * compatibility with a TBI link partner, we will store bad
                  * packets. Some frames have an additional byte on the end and
-                 * will look like CRC errors to to the hardware.
+                 * will look like CRC errors to the hardware.
                  */
                 if (!hw->tbi_compatibility_on) {
                     hw->tbi_compatibility_on = true;
Index: linux-2.6/drivers/net/wireless/zd1211rw/zd_chip.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/zd1211rw/zd_chip.c
+++ linux-2.6/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -368,7 +368,7 @@ error:
        return r;
 }

-/* MAC address: if custom mac addresses are to to be used CR_MAC_ADDR_P1 and
+/* MAC address: if custom mac addresses are to be used CR_MAC_ADDR_P1 and
  *              CR_MAC_ADDR_P2 must be overwritten
  */
 int zd_write_mac_addr(struct zd_chip *chip, const u8 *mac_addr)
Index: linux-2.6/drivers/scsi/megaraid/megaraid_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.c
+++ linux-2.6/drivers/scsi/megaraid/megaraid_sas.c
@@ -718,7 +718,7 @@ megasas_build_dcdb(struct megasas_instan
  * megasas_build_ldio -        Prepares IOs to logical devices
  * @instance:          Adapter soft state
  * @scp:               SCSI command
- * @cmd:               Command to to be prepared
+ * @cmd:               Command to be prepared
  *
  * Frames (and accompanying SGLs) for regular SCSI IOs use this function.
  */
Index: linux-2.6/drivers/scsi/qla4xxx/ql4_os.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla4xxx/ql4_os.c
+++ linux-2.6/drivers/scsi/qla4xxx/ql4_os.c
@@ -1406,7 +1406,7 @@ static void qla4xxx_slave_destroy(struct
 /**
  * qla4xxx_del_from_active_array - returns an active srb
  * @ha: Pointer to host adapter structure.
- * @index: index into to the active_array
+ * @index: index into the active_array
  *
  * This routine removes and returns the srb at the specified index
  **/
@@ -1484,7 +1484,7 @@ static int qla4xxx_wait_for_hba_online(s

 /**
  * qla4xxx_eh_wait_for_commands - wait for active cmds to finish.
- * @ha: pointer to to HBA
+ * @ha: pointer to HBA
  * @t: target id
  * @l: lun id
  *
Index: linux-2.6/drivers/staging/rt2860/rtmp.h
===================================================================
--- linux-2.6.orig/drivers/staging/rt2860/rtmp.h
+++ linux-2.6/drivers/staging/rt2860/rtmp.h
@@ -2080,7 +2080,7 @@ typedef struct _STA_ADMIN_CONFIG {
     BOOLEAN            AdhocBGJoined;          // Indicate Adhoc B/G Join.
     BOOLEAN            Adhoc20NJoined;         // Indicate Adhoc 20MHz N Join.
 #endif
-       // New for WPA, windows want us to to keep association information and
+       // New for WPA, windows want us to keep association information and
        // Fixed IEs from last association response
        NDIS_802_11_ASSOCIATION_INFORMATION     AssocInfo;
        USHORT       ReqVarIELen;                // Length of next VIE include EID & Length
Index: linux-2.6/drivers/usb/serial/cypress_m8.h
===================================================================
--- linux-2.6.orig/drivers/usb/serial/cypress_m8.h
+++ linux-2.6/drivers/usb/serial/cypress_m8.h
@@ -57,7 +57,7 @@
 #define        UART_RI         0x10    /* ring indicator - modem - device to host */
 #define UART_CD                0x40    /* carrier detect - modem - device to host */
 #define CYP_ERROR      0x08    /* received from input report - device to host */
-/* Note - the below has nothing to to with the "feature report" reset */
+/* Note - the below has nothing to do with the "feature report" reset */
 #define CONTROL_RESET  0x08    /* sent with output report - host to device */

 /* End of RS-232 protocol definitions */
Index: linux-2.6/drivers/usb/serial/io_edgeport.c
===================================================================
--- linux-2.6.orig/drivers/usb/serial/io_edgeport.c
+++ linux-2.6/drivers/usb/serial/io_edgeport.c
@@ -2542,7 +2542,7 @@ static int calc_baud_rate_divisor(int ba

 /*****************************************************************************
  * send_cmd_write_uart_register
- *  this function builds up a uart register message and sends to to the device.
+ *  this function builds up a uart register message and sends to the device.
  *****************************************************************************/
 static int send_cmd_write_uart_register(struct edgeport_port *edge_port,
                                                __u8 regNum, __u8 regValue)
Index: linux-2.6/drivers/usb/serial/kl5kusb105.c
===================================================================
--- linux-2.6.orig/drivers/usb/serial/kl5kusb105.c
+++ linux-2.6/drivers/usb/serial/kl5kusb105.c
@@ -38,7 +38,7 @@
  *   0.3a - implemented pools of write URBs
  *   0.3  - alpha version for public testing
  *   0.2  - TIOCMGET works, so autopilot(1) can be used!
- *   0.1  - can be used to to pilot-xfer -p /dev/ttyUSB0 -l
+ *   0.1  - can be used to do pilot-xfer -p /dev/ttyUSB0 -l
  *
  *   The driver skeleton is mainly based on mct_u232.c and various other
  *   pieces of code shamelessly copied from the drivers/usb/serial/ directory.
Index: linux-2.6/fs/ext4/inode.c
===================================================================
--- linux-2.6.orig/fs/ext4/inode.c
+++ linux-2.6/fs/ext4/inode.c
@@ -2329,7 +2329,7 @@ static int __mpage_da_writepage(struct p
                /*
                 * Rest of the page in the page_vec
                 * redirty then and skip then. We will
-                * try to to write them again after
+                * try to write them again after
                 * starting a new transaction
                 */
                redirty_page_for_writepage(wbc, page);
Index: linux-2.6/fs/gfs2/rgrp.c
===================================================================
--- linux-2.6.orig/fs/gfs2/rgrp.c
+++ linux-2.6/fs/gfs2/rgrp.c
@@ -179,7 +179,7 @@ static inline u64 gfs2_bit_search(const
  * always aligned to a 64 bit boundary.
  *
  * The size of the buffer is in bytes, but is it assumed that it is
- * always ok to to read a complete multiple of 64 bits at the end
+ * always ok to read a complete multiple of 64 bits at the end
  * of the block in case the end is no aligned to a natural boundary.
  *
  * Return: the block number (bitmap buffer scope) that was found
Index: linux-2.6/fs/ntfs/layout.h
===================================================================
--- linux-2.6.orig/fs/ntfs/layout.h
+++ linux-2.6/fs/ntfs/layout.h
@@ -829,7 +829,7 @@ enum {
        /* Note, FILE_ATTR_VALID_SET_FLAGS masks out the old DOS VolId, the
           F_A_DEVICE, F_A_DIRECTORY, F_A_SPARSE_FILE, F_A_REPARSE_POINT,
           F_A_COMPRESSED, and F_A_ENCRYPTED and preserves the rest.  This mask
-          is used to to obtain all flags that are valid for setting. */
+          is used to obtain all flags that are valid for setting. */
        /*
         * The flag FILE_ATTR_DUP_FILENAME_INDEX_PRESENT is present in all
         * FILENAME_ATTR attributes but not in the STANDARD_INFORMATION
Index: linux-2.6/include/acpi/actypes.h
===================================================================
--- linux-2.6.orig/include/acpi/actypes.h
+++ linux-2.6/include/acpi/actypes.h
@@ -288,7 +288,7 @@ typedef u32 acpi_physical_address;
 /*
  * Some compilers complain about unused variables. Sometimes we don't want to
  * use all the variables (for example, _acpi_module_name). This allows us
- * to to tell the compiler in a per-variable manner that a variable
+ * to tell the compiler in a per-variable manner that a variable
  * is unused
  */
 #ifndef ACPI_UNUSED_VAR
Index: linux-2.6/include/acpi/platform/acgcc.h
===================================================================
--- linux-2.6.orig/include/acpi/platform/acgcc.h
+++ linux-2.6/include/acpi/platform/acgcc.h
@@ -57,7 +57,7 @@
 /*
  * Some compilers complain about unused variables. Sometimes we don't want to
  * use all the variables (for example, _acpi_module_name). This allows us
- * to to tell the compiler warning in a per-variable manner that a variable
+ * to tell the compiler warning in a per-variable manner that a variable
  * is unused.
  */
 #define ACPI_UNUSED_VAR __attribute__ ((unused))
Index: linux-2.6/include/rdma/ib_cm.h
===================================================================
--- linux-2.6.orig/include/rdma/ib_cm.h
+++ linux-2.6/include/rdma/ib_cm.h
@@ -482,7 +482,7 @@ int ib_send_cm_rej(struct ib_cm_id *cm_i
  *   message.
  * @cm_id: Connection identifier associated with the connection message.
  * @service_timeout: The lower 5-bits specify the maximum time required for
- *   the sender to reply to to the connection message.  The upper 3-bits
+ *   the sender to reply to the connection message.  The upper 3-bits
  *   specify additional control flags.
  * @private_data: Optional user-defined private data sent with the
  *   message receipt acknowledgement.
Index: linux-2.6/kernel/tracepoint.c
===================================================================
--- linux-2.6.orig/kernel/tracepoint.c
+++ linux-2.6/kernel/tracepoint.c
@@ -47,7 +47,7 @@ static struct hlist_head tracepoint_tabl

 /*
  * Note about RCU :
- * It is used to to delay the free of multiple probes array until a quiescent
+ * It is used to delay the free of multiple probes array until a quiescent
  * state is reached.
  * Tracepoint entries modifications are protected by the tracepoints_mutex.
  */
Index: linux-2.6/lib/zlib_deflate/deflate.c
===================================================================
--- linux-2.6.orig/lib/zlib_deflate/deflate.c
+++ linux-2.6/lib/zlib_deflate/deflate.c
@@ -135,7 +135,7 @@ static const config configuration_table[

 /* ===========================================================================
  * Update a hash value with the given input byte
- * IN  assertion: all calls to to UPDATE_HASH are made with consecutive
+ * IN  assertion: all calls to UPDATE_HASH are made with consecutive
  *    input characters, so that a running hash key can be computed from the
  *    previous key instead of complete recalculation each time.
  */
@@ -146,7 +146,7 @@ static const config configuration_table[
  * Insert string str in the dictionary and set match_head to the previous head
  * of the hash chain (the most recent string with same hash key). Return
  * the previous length of the hash chain.
- * IN  assertion: all calls to to INSERT_STRING are made with consecutive
+ * IN  assertion: all calls to INSERT_STRING are made with consecutive
  *    input characters and the first MIN_MATCH bytes of str are valid
  *    (except for the last MIN_MATCH-1 bytes of the input file).
  */
Index: linux-2.6/net/rxrpc/ar-call.c
===================================================================
--- linux-2.6.orig/net/rxrpc/ar-call.c
+++ linux-2.6/net/rxrpc/ar-call.c
@@ -96,7 +96,7 @@ static struct rxrpc_call *rxrpc_alloc_ca
 }

 /*
- * allocate a new client call and attempt to to get a connection slot for it
+ * allocate a new client call and attempt to get a connection slot for it
  */
 static struct rxrpc_call *rxrpc_alloc_client_call(
        struct rxrpc_sock *rx,
Index: linux-2.6/net/sched/sch_hfsc.c
===================================================================
--- linux-2.6.orig/net/sched/sch_hfsc.c
+++ linux-2.6/net/sched/sch_hfsc.c
@@ -77,7 +77,7 @@
  *   The service curve parameters are converted to the internal
  *   representation. The slope values are scaled to avoid overflow.
  *   the inverse slope values as well as the y-projection of the 1st
- *   segment are kept in order to to avoid 64-bit divide operations
+ *   segment are kept in order to avoid 64-bit divide operations
  *   that are expensive on 32-bit architectures.
  */

