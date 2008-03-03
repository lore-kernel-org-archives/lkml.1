Return-Path: <linux-kernel-owner+w=401wt.eu-S1760504AbYCCTOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504AbYCCTOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbYCCTO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:14:26 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:24328 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbYCCTOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:14:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bgVzefcKe6kZ+MfoJVeFz6JUe0TK8G/ljVSvlh6IIF2bBdtMUjAvo+B/Lh2nuoJCSRtqCW1zCVzmfFYE89lf8bb5GfuMjfHSCrcZJgk9WbKGKF9afK/9eVTOuv2e4vg9WdnqAKEneFK7M+yAH3NYXJHeqKI9hLgLyGzhscIAeqw=
Subject: [PATCH] powerpc: replace remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 11:14:12 -0800
Message-Id: <1204571652.3266.36.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
This was a straight sed replacement, have not reviewed as fully as the
others, this arch is going away anyway I believe.
 arch/powerpc/boot/libfdt-wrapper.c                |    2 +-
 arch/powerpc/kernel/ibmebus.c                     |   12 ++++----
 arch/powerpc/kernel/iommu.c                       |    4 +-
 arch/powerpc/kernel/isa-bridge.c                  |    2 +-
 arch/powerpc/kernel/lparcfg.c                     |   12 ++++----
 arch/powerpc/kernel/rtas.c                        |    2 +-
 arch/powerpc/kernel/rtas_flash.c                  |    2 +-
 arch/powerpc/kernel/rtas_pci.c                    |   10 +++---
 arch/powerpc/kernel/vio.c                         |   10 +++---
 arch/powerpc/math-emu/fabs.c                      |    2 +-
 arch/powerpc/math-emu/fadd.c                      |    2 +-
 arch/powerpc/math-emu/fadds.c                     |    2 +-
 arch/powerpc/math-emu/fcmpo.c                     |    2 +-
 arch/powerpc/math-emu/fcmpu.c                     |    2 +-
 arch/powerpc/math-emu/fctiw.c                     |    2 +-
 arch/powerpc/math-emu/fctiwz.c                    |    2 +-
 arch/powerpc/math-emu/fdiv.c                      |    6 ++--
 arch/powerpc/math-emu/fdivs.c                     |    6 ++--
 arch/powerpc/math-emu/fmadd.c                     |    2 +-
 arch/powerpc/math-emu/fmadds.c                    |    2 +-
 arch/powerpc/math-emu/fmr.c                       |    2 +-
 arch/powerpc/math-emu/fmsub.c                     |    2 +-
 arch/powerpc/math-emu/fmsubs.c                    |    2 +-
 arch/powerpc/math-emu/fmul.c                      |    2 +-
 arch/powerpc/math-emu/fmuls.c                     |    2 +-
 arch/powerpc/math-emu/fnabs.c                     |    2 +-
 arch/powerpc/math-emu/fneg.c                      |    2 +-
 arch/powerpc/math-emu/fnmadd.c                    |    2 +-
 arch/powerpc/math-emu/fnmadds.c                   |    2 +-
 arch/powerpc/math-emu/fnmsub.c                    |    2 +-
 arch/powerpc/math-emu/fnmsubs.c                   |    2 +-
 arch/powerpc/math-emu/fres.c                      |    2 +-
 arch/powerpc/math-emu/frsp.c                      |    2 +-
 arch/powerpc/math-emu/frsqrte.c                   |    2 +-
 arch/powerpc/math-emu/fsel.c                      |    2 +-
 arch/powerpc/math-emu/fsqrt.c                     |    2 +-
 arch/powerpc/math-emu/fsqrts.c                    |    2 +-
 arch/powerpc/math-emu/fsub.c                      |    2 +-
 arch/powerpc/math-emu/fsubs.c                     |    2 +-
 arch/powerpc/math-emu/lfd.c                       |    2 +-
 arch/powerpc/math-emu/lfs.c                       |    2 +-
 arch/powerpc/math-emu/mcrfs.c                     |    4 +-
 arch/powerpc/math-emu/mffs.c                      |    2 +-
 arch/powerpc/math-emu/mtfsb0.c                    |    2 +-
 arch/powerpc/math-emu/mtfsb1.c                    |    2 +-
 arch/powerpc/math-emu/mtfsf.c                     |    2 +-
 arch/powerpc/math-emu/mtfsfi.c                    |    2 +-
 arch/powerpc/math-emu/stfd.c                      |    2 +-
 arch/powerpc/math-emu/stfiwx.c                    |    2 +-
 arch/powerpc/math-emu/stfs.c                      |    2 +-
 arch/powerpc/mm/init_32.c                         |    2 +-
 arch/powerpc/mm/init_64.c                         |    2 +-
 arch/powerpc/oprofile/cell/spu_task_sync.c        |   12 ++++----
 arch/powerpc/oprofile/cell/vma_map.c              |   10 +++---
 arch/powerpc/oprofile/op_model_cell.c             |   14 ++++----
 arch/powerpc/platforms/52xx/lite5200.c            |    4 +-
 arch/powerpc/platforms/85xx/mpc85xx_ds.c          |    2 +-
 arch/powerpc/platforms/cell/iommu.c               |    8 ++--
 arch/powerpc/platforms/cell/pervasive.c           |    2 +-
 arch/powerpc/platforms/cell/ras.c                 |   10 +++---
 arch/powerpc/platforms/cell/spu_base.c            |    8 ++--
 arch/powerpc/platforms/cell/spu_callbacks.c       |    2 +-
 arch/powerpc/platforms/cell/spu_manage.c          |    8 ++--
 arch/powerpc/platforms/cell/spufs/file.c          |    4 +-
 arch/powerpc/platforms/cell/spufs/run.c           |   10 +++---
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c |   10 +++---
 arch/powerpc/platforms/ps3/setup.c                |    2 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c        |    2 +-
 arch/powerpc/platforms/pseries/reconfig.c         |   12 ++++----
 arch/powerpc/sysdev/cpm1.c                        |    2 +-
 arch/powerpc/sysdev/cpm2.c                        |    2 +-
 arch/powerpc/sysdev/qe_lib/qe_io.c                |    2 +-
 arch/powerpc/sysdev/qe_lib/ucc_fast.c             |   32 ++++++++++----------
 arch/powerpc/sysdev/qe_lib/ucc_slow.c             |   18 ++++++------
 arch/powerpc/sysdev/tsi108_dev.c                  |    4 +-
 arch/powerpc/sysdev/tsi108_pci.c                  |    4 +-
 76 files changed, 168 insertions(+), 168 deletions(-)

diff --git a/arch/powerpc/boot/libfdt-wrapper.c b/arch/powerpc/boot/libfdt-wrapper.c
index 59016be..c541fd8 100644
--- a/arch/powerpc/boot/libfdt-wrapper.c
+++ b/arch/powerpc/boot/libfdt-wrapper.c
@@ -35,7 +35,7 @@
 #define check_err(err) \
 	({ \
 		if (BAD_ERROR(err) || ((err < 0) && DEBUG)) \
-			printf("%s():%d  %s\n\r", __FUNCTION__, __LINE__, \
+			printf("%s():%d  %s\n\r", __func__, __LINE__, \
 			       fdt_strerror(err)); \
 		if (BAD_ERROR(err)) \
 			exit(); \
diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index 2f50bb5..9971159 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -183,7 +183,7 @@ static int ibmebus_create_devices(const struct of_device_id *matches)
 		ret = ibmebus_create_device(child);
 		if (ret) {
 			printk(KERN_ERR "%s: failed to create device (%i)",
-			       __FUNCTION__, ret);
+			       __func__, ret);
 			of_node_put(child);
 			break;
 		}
@@ -269,7 +269,7 @@ static ssize_t ibmebus_store_probe(struct bus_type *bus,
 	if (bus_find_device(&ibmebus_bus_type, NULL, path,
 			    ibmebus_match_path)) {
 		printk(KERN_WARNING "%s: %s has already been probed\n",
-		       __FUNCTION__, path);
+		       __func__, path);
 		rc = -EEXIST;
 		goto out;
 	}
@@ -279,7 +279,7 @@ static ssize_t ibmebus_store_probe(struct bus_type *bus,
 		of_node_put(dn);
 	} else {
 		printk(KERN_WARNING "%s: no such device node: %s\n",
-		       __FUNCTION__, path);
+		       __func__, path);
 		rc = -ENODEV;
 	}
 
@@ -308,7 +308,7 @@ static ssize_t ibmebus_store_remove(struct bus_type *bus,
 		return count;
 	} else {
 		printk(KERN_WARNING "%s: %s not on the bus\n",
-		       __FUNCTION__, path);
+		       __func__, path);
 
 		kfree(path);
 		return -ENODEV;
@@ -337,14 +337,14 @@ static int __init ibmebus_bus_init(void)
 	err = of_bus_type_init(&ibmebus_bus_type, "ibmebus");
 	if (err) {
 		printk(KERN_ERR "%s: failed to register IBM eBus.\n",
-		       __FUNCTION__);
+		       __func__);
 		return err;
 	}
 
 	err = device_register(&ibmebus_bus_device);
 	if (err) {
 		printk(KERN_WARNING "%s: device_register returned %i\n",
-		       __FUNCTION__, err);
+		       __func__, err);
 		bus_unregister(&ibmebus_bus_type);
 
 		return err;
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 8f1f4e5..0c66366 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -520,7 +520,7 @@ void iommu_free_table(struct iommu_table *tbl, const char *node_name)
 	unsigned int order;
 
 	if (!tbl || !tbl->it_map) {
-		printk(KERN_ERR "%s: expected TCE map for %s\n", __FUNCTION__,
+		printk(KERN_ERR "%s: expected TCE map for %s\n", __func__,
 				node_name);
 		return;
 	}
@@ -530,7 +530,7 @@ void iommu_free_table(struct iommu_table *tbl, const char *node_name)
 	for (i = 0; i < (tbl->it_size/64); i++) {
 		if (tbl->it_map[i] != 0) {
 			printk(KERN_WARNING "%s: Unexpected TCEs for %s\n",
-				__FUNCTION__, node_name);
+				__func__, node_name);
 			break;
 		}
 	}
diff --git a/arch/powerpc/kernel/isa-bridge.c b/arch/powerpc/kernel/isa-bridge.c
index ee172aa..d73551d 100644
--- a/arch/powerpc/kernel/isa-bridge.c
+++ b/arch/powerpc/kernel/isa-bridge.c
@@ -99,7 +99,7 @@ static void __devinit pci_process_ISA_OF_ranges(struct device_node *isa_node,
 	 */
 	if ((pci_addr != 0) || (isa_addr != 0)) {
 		printk(KERN_ERR "unexpected isa to pci mapping: %s\n",
-		       __FUNCTION__);
+		       __func__);
 		return;
 	}
 
diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
index dcb89a8..1ffacc6 100644
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -226,7 +226,7 @@ static void parse_system_parameter_string(struct seq_file *m)
 	unsigned char *local_buffer = kmalloc(SPLPAR_MAXLENGTH, GFP_KERNEL);
 	if (!local_buffer) {
 		printk(KERN_ERR "%s %s kmalloc failure at line %d \n",
-		       __FILE__, __FUNCTION__, __LINE__);
+		       __FILE__, __func__, __LINE__);
 		return;
 	}
 
@@ -243,14 +243,14 @@ static void parse_system_parameter_string(struct seq_file *m)
 	if (call_status != 0) {
 		printk(KERN_INFO
 		       "%s %s Error calling get-system-parameter (0x%x)\n",
-		       __FILE__, __FUNCTION__, call_status);
+		       __FILE__, __func__, call_status);
 	} else {
 		int splpar_strlen;
 		int idx, w_idx;
 		char *workbuffer = kzalloc(SPLPAR_MAXLENGTH, GFP_KERNEL);
 		if (!workbuffer) {
 			printk(KERN_ERR "%s %s kmalloc failure at line %d \n",
-			       __FILE__, __FUNCTION__, __LINE__);
+			       __FILE__, __func__, __LINE__);
 			kfree(local_buffer);
 			return;
 		}
@@ -484,10 +484,10 @@ static ssize_t lparcfg_write(struct file *file, const char __user * buf,
 	current_weight = (resource >> 5 * 8) & 0xFF;
 
 	pr_debug("%s: current_entitled = %lu, current_weight = %u\n",
-		 __FUNCTION__, current_entitled, current_weight);
+		 __func__, current_entitled, current_weight);
 
 	pr_debug("%s: new_entitled = %lu, new_weight = %u\n",
-		 __FUNCTION__, *new_entitled_ptr, *new_weight_ptr);
+		 __func__, *new_entitled_ptr, *new_weight_ptr);
 
 	retval = plpar_hcall_norets(H_SET_PPP, *new_entitled_ptr,
 				    *new_weight_ptr);
@@ -502,7 +502,7 @@ static ssize_t lparcfg_write(struct file *file, const char __user * buf,
 		retval = -EINVAL;
 	} else {
 		printk(KERN_WARNING "%s: received unknown hv return code %ld",
-		       __FUNCTION__, retval);
+		       __func__, retval);
 		retval = -EIO;
 	}
 
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 52e95c2..2aed5a9 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -507,7 +507,7 @@ int rtas_error_rc(int rtas_rc)
 			break;
 		default:
 			printk(KERN_ERR "%s: unexpected RTAS error %d\n",
-					__FUNCTION__, rtas_rc);
+					__func__, rtas_rc);
 			rc = -ERANGE;
 			break;
 	}
diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
index f227659..e1756e1 100644
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -807,7 +807,7 @@ int __init rtas_flash_init(void)
 				rtas_block_ctor);
 	if (!flash_block_cache) {
 		printk(KERN_ERR "%s: failed to create block cache\n",
-				__FUNCTION__);
+				__func__);
 		rc = -ENOMEM;
 		goto cleanup;
 	}
diff --git a/arch/powerpc/kernel/rtas_pci.c b/arch/powerpc/kernel/rtas_pci.c
index 433a0a0..945e8f4 100644
--- a/arch/powerpc/kernel/rtas_pci.c
+++ b/arch/powerpc/kernel/rtas_pci.c
@@ -326,7 +326,7 @@ int pcibios_remove_root_bus(struct pci_controller *phb)
 
 	res = b->resource[0];
 	if (!res->flags) {
-		printk(KERN_ERR "%s: no IO resource for PHB %s\n", __FUNCTION__,
+		printk(KERN_ERR "%s: no IO resource for PHB %s\n", __func__,
 				b->name);
 		return 1;
 	}
@@ -334,13 +334,13 @@ int pcibios_remove_root_bus(struct pci_controller *phb)
 	rc = pcibios_unmap_io_space(b);
 	if (rc) {
 		printk(KERN_ERR "%s: failed to unmap IO on bus %s\n",
-			__FUNCTION__, b->name);
+			__func__, b->name);
 		return 1;
 	}
 
 	if (release_resource(res)) {
 		printk(KERN_ERR "%s: failed to release IO on bus %s\n",
-				__FUNCTION__, b->name);
+				__func__, b->name);
 		return 1;
 	}
 
@@ -348,13 +348,13 @@ int pcibios_remove_root_bus(struct pci_controller *phb)
 		res = b->resource[i];
 		if (!res->flags && i == 0) {
 			printk(KERN_ERR "%s: no MEM resource for PHB %s\n",
-				__FUNCTION__, b->name);
+				__func__, b->name);
 			return 1;
 		}
 		if (res->flags && release_resource(res)) {
 			printk(KERN_ERR
 			       "%s: failed to release IO %d on bus %s\n",
-				__FUNCTION__, i, b->name);
+				__func__, i, b->name);
 			return 1;
 		}
 	}
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index f988672..b77f8af 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -139,7 +139,7 @@ static int vio_bus_remove(struct device *dev)
  */
 int vio_register_driver(struct vio_driver *viodrv)
 {
-	printk(KERN_DEBUG "%s: driver %s registering\n", __FUNCTION__,
+	printk(KERN_DEBUG "%s: driver %s registering\n", __func__,
 		viodrv->driver.name);
 
 	/* fill in 'struct driver' fields */
@@ -184,7 +184,7 @@ struct vio_dev *vio_register_device_node(struct device_node *of_node)
 	/* we need the 'device_type' property, in order to match with drivers */
 	if (of_node->type == NULL) {
 		printk(KERN_WARNING "%s: node %s missing 'device_type'\n",
-				__FUNCTION__,
+				__func__,
 				of_node->name ? of_node->name : "<unknown>");
 		return NULL;
 	}
@@ -192,7 +192,7 @@ struct vio_dev *vio_register_device_node(struct device_node *of_node)
 	unit_address = of_get_property(of_node, "reg", NULL);
 	if (unit_address == NULL) {
 		printk(KERN_WARNING "%s: node %s missing 'reg'\n",
-				__FUNCTION__,
+				__func__,
 				of_node->name ? of_node->name : "<unknown>");
 		return NULL;
 	}
@@ -227,7 +227,7 @@ struct vio_dev *vio_register_device_node(struct device_node *of_node)
 	/* register with generic device framework */
 	if (device_register(&viodev->dev)) {
 		printk(KERN_ERR "%s: failed to register device %s\n",
-				__FUNCTION__, viodev->dev.bus_id);
+				__func__, viodev->dev.bus_id);
 		/* XXX free TCE table */
 		kfree(viodev);
 		return NULL;
@@ -258,7 +258,7 @@ static int __init vio_bus_init(void)
 	err = device_register(&vio_bus_device.dev);
 	if (err) {
 		printk(KERN_WARNING "%s: device_register returned %i\n",
-				__FUNCTION__, err);
+				__func__, err);
 		return err;
 	}
 
diff --git a/arch/powerpc/math-emu/fabs.c b/arch/powerpc/math-emu/fabs.c
index 41f0617..549baba 100644
--- a/arch/powerpc/math-emu/fabs.c
+++ b/arch/powerpc/math-emu/fabs.c
@@ -9,7 +9,7 @@ fabs(u32 *frD, u32 *frB)
 	frD[1] = frB[1];
 
 #ifdef DEBUG
-	printk("%s: D %p, B %p: ", __FUNCTION__, frD, frB);
+	printk("%s: D %p, B %p: ", __func__, frD, frB);
 	dump_double(frD);
 	printk("\n");
 #endif
diff --git a/arch/powerpc/math-emu/fadd.c b/arch/powerpc/math-emu/fadd.c
index fc88364..7befbbf 100644
--- a/arch/powerpc/math-emu/fadd.c
+++ b/arch/powerpc/math-emu/fadd.c
@@ -14,7 +14,7 @@ fadd(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fadds.c b/arch/powerpc/math-emu/fadds.c
index 93025b6..2b346b3 100644
--- a/arch/powerpc/math-emu/fadds.c
+++ b/arch/powerpc/math-emu/fadds.c
@@ -15,7 +15,7 @@ fadds(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fcmpo.c b/arch/powerpc/math-emu/fcmpo.c
index 4efac39..36d6890 100644
--- a/arch/powerpc/math-emu/fcmpo.c
+++ b/arch/powerpc/math-emu/fcmpo.c
@@ -15,7 +15,7 @@ fcmpo(u32 *ccr, int crfD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p (%08x) %d %p %p\n", __FUNCTION__, ccr, *ccr, crfD, frA, frB);
+	printk("%s: %p (%08x) %d %p %p\n", __func__, ccr, *ccr, crfD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fcmpu.c b/arch/powerpc/math-emu/fcmpu.c
index b7e3317..53d9389 100644
--- a/arch/powerpc/math-emu/fcmpu.c
+++ b/arch/powerpc/math-emu/fcmpu.c
@@ -14,7 +14,7 @@ fcmpu(u32 *ccr, int crfD, void *frA, void *frB)
 	long cmp;
 
 #ifdef DEBUG
-	printk("%s: %p (%08x) %d %p %p\n", __FUNCTION__, ccr, *ccr, crfD, frA, frB);
+	printk("%s: %p (%08x) %d %p %p\n", __func__, ccr, *ccr, crfD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fctiw.c b/arch/powerpc/math-emu/fctiw.c
index 3b3c98b..fcd7a95 100644
--- a/arch/powerpc/math-emu/fctiw.c
+++ b/arch/powerpc/math-emu/fctiw.c
@@ -16,7 +16,7 @@ fctiw(u32 *frD, void *frB)
 	frD[1] = r;
 
 #ifdef DEBUG
-	printk("%s: D %p, B %p: ", __FUNCTION__, frD, frB);
+	printk("%s: D %p, B %p: ", __func__, frD, frB);
 	dump_double(frD);
 	printk("\n");
 #endif
diff --git a/arch/powerpc/math-emu/fctiwz.c b/arch/powerpc/math-emu/fctiwz.c
index 7717eb6..1514d59 100644
--- a/arch/powerpc/math-emu/fctiwz.c
+++ b/arch/powerpc/math-emu/fctiwz.c
@@ -23,7 +23,7 @@ fctiwz(u32 *frD, void *frB)
 	__FPU_FPSCR = fpscr;
 
 #ifdef DEBUG
-	printk("%s: D %p, B %p: ", __FUNCTION__, frD, frB);
+	printk("%s: D %p, B %p: ", __func__, frD, frB);
 	dump_double(frD);
 	printk("\n");
 #endif
diff --git a/arch/powerpc/math-emu/fdiv.c b/arch/powerpc/math-emu/fdiv.c
index f2fba82..18a20fe 100644
--- a/arch/powerpc/math-emu/fdiv.c
+++ b/arch/powerpc/math-emu/fdiv.c
@@ -14,7 +14,7 @@ fdiv(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
@@ -28,13 +28,13 @@ fdiv(void *frD, void *frA, void *frB)
 	if (A_c == FP_CLS_ZERO && B_c == FP_CLS_ZERO) {
 		ret |= EFLAG_VXZDZ;
 #ifdef DEBUG
-		printk("%s: FPSCR_VXZDZ raised\n", __FUNCTION__);
+		printk("%s: FPSCR_VXZDZ raised\n", __func__);
 #endif
 	}
 	if (A_c == FP_CLS_INF && B_c == FP_CLS_INF) {
 		ret |= EFLAG_VXIDI;
 #ifdef DEBUG
-		printk("%s: FPSCR_VXIDI raised\n", __FUNCTION__);
+		printk("%s: FPSCR_VXIDI raised\n", __func__);
 #endif
 	}
 
diff --git a/arch/powerpc/math-emu/fdivs.c b/arch/powerpc/math-emu/fdivs.c
index b971196..24feed6 100644
--- a/arch/powerpc/math-emu/fdivs.c
+++ b/arch/powerpc/math-emu/fdivs.c
@@ -15,7 +15,7 @@ fdivs(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
@@ -29,13 +29,13 @@ fdivs(void *frD, void *frA, void *frB)
 	if (A_c == FP_CLS_ZERO && B_c == FP_CLS_ZERO) {
 		ret |= EFLAG_VXZDZ;
 #ifdef DEBUG
-		printk("%s: FPSCR_VXZDZ raised\n", __FUNCTION__);
+		printk("%s: FPSCR_VXZDZ raised\n", __func__);
 #endif
 	}
 	if (A_c == FP_CLS_INF && B_c == FP_CLS_INF) {
 		ret |= EFLAG_VXIDI;
 #ifdef DEBUG
-		printk("%s: FPSCR_VXIDI raised\n", __FUNCTION__);
+		printk("%s: FPSCR_VXIDI raised\n", __func__);
 #endif
 	}
 
diff --git a/arch/powerpc/math-emu/fmadd.c b/arch/powerpc/math-emu/fmadd.c
index 0a1dbce..dedb465 100644
--- a/arch/powerpc/math-emu/fmadd.c
+++ b/arch/powerpc/math-emu/fmadd.c
@@ -16,7 +16,7 @@ fmadd(void *frD, void *frA, void *frB, void *frC)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fmadds.c b/arch/powerpc/math-emu/fmadds.c
index 0f70bba..6bbb56d 100644
--- a/arch/powerpc/math-emu/fmadds.c
+++ b/arch/powerpc/math-emu/fmadds.c
@@ -17,7 +17,7 @@ fmadds(void *frD, void *frA, void *frB, void *frC)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fmr.c b/arch/powerpc/math-emu/fmr.c
index 28df700..bd55384 100644
--- a/arch/powerpc/math-emu/fmr.c
+++ b/arch/powerpc/math-emu/fmr.c
@@ -9,7 +9,7 @@ fmr(u32 *frD, u32 *frB)
 	frD[1] = frB[1];
 
 #ifdef DEBUG
-	printk("%s: D %p, B %p: ", __FUNCTION__, frD, frB);
+	printk("%s: D %p, B %p: ", __func__, frD, frB);
 	dump_double(frD);
 	printk("\n");
 #endif
diff --git a/arch/powerpc/math-emu/fmsub.c b/arch/powerpc/math-emu/fmsub.c
index 203fd48..f311e2c 100644
--- a/arch/powerpc/math-emu/fmsub.c
+++ b/arch/powerpc/math-emu/fmsub.c
@@ -16,7 +16,7 @@ fmsub(void *frD, void *frA, void *frB, void *frC)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fmsubs.c b/arch/powerpc/math-emu/fmsubs.c
index 8ce6862..81a716d 100644
--- a/arch/powerpc/math-emu/fmsubs.c
+++ b/arch/powerpc/math-emu/fmsubs.c
@@ -17,7 +17,7 @@ fmsubs(void *frD, void *frA, void *frB, void *frC)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fmul.c b/arch/powerpc/math-emu/fmul.c
index 66c7e79..2f3d327 100644
--- a/arch/powerpc/math-emu/fmul.c
+++ b/arch/powerpc/math-emu/fmul.c
@@ -14,7 +14,7 @@ fmul(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fmuls.c b/arch/powerpc/math-emu/fmuls.c
index 26bc427..962b588 100644
--- a/arch/powerpc/math-emu/fmuls.c
+++ b/arch/powerpc/math-emu/fmuls.c
@@ -15,7 +15,7 @@ fmuls(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fnabs.c b/arch/powerpc/math-emu/fnabs.c
index c6b913d..a7d34f3 100644
--- a/arch/powerpc/math-emu/fnabs.c
+++ b/arch/powerpc/math-emu/fnabs.c
@@ -9,7 +9,7 @@ fnabs(u32 *frD, u32 *frB)
 	frD[1] = frB[1];
 
 #ifdef DEBUG
-	printk("%s: D %p, B %p: ", __FUNCTION__, frD, frB);
+	printk("%s: D %p, B %p: ", __func__, frD, frB);
 	dump_double(frD);
 	printk("\n");
 #endif
diff --git a/arch/powerpc/math-emu/fneg.c b/arch/powerpc/math-emu/fneg.c
index fe9a98d..1e988cd 100644
--- a/arch/powerpc/math-emu/fneg.c
+++ b/arch/powerpc/math-emu/fneg.c
@@ -9,7 +9,7 @@ fneg(u32 *frD, u32 *frB)
 	frD[1] = frB[1];
 
 #ifdef DEBUG
-	printk("%s: D %p, B %p: ", __FUNCTION__, frD, frB);
+	printk("%s: D %p, B %p: ", __func__, frD, frB);
 	dump_double(frD);
 	printk("\n");
 #endif
diff --git a/arch/powerpc/math-emu/fnmadd.c b/arch/powerpc/math-emu/fnmadd.c
index 7f31227..8cf7827 100644
--- a/arch/powerpc/math-emu/fnmadd.c
+++ b/arch/powerpc/math-emu/fnmadd.c
@@ -16,7 +16,7 @@ fnmadd(void *frD, void *frA, void *frB, void *frC)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fnmadds.c b/arch/powerpc/math-emu/fnmadds.c
index 65454c9..f1c4f0f 100644
--- a/arch/powerpc/math-emu/fnmadds.c
+++ b/arch/powerpc/math-emu/fnmadds.c
@@ -17,7 +17,7 @@ fnmadds(void *frD, void *frA, void *frB, void *frC)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fnmsub.c b/arch/powerpc/math-emu/fnmsub.c
index f1ca748..98944e6 100644
--- a/arch/powerpc/math-emu/fnmsub.c
+++ b/arch/powerpc/math-emu/fnmsub.c
@@ -16,7 +16,7 @@ fnmsub(void *frD, void *frA, void *frB, void *frC)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fnmsubs.c b/arch/powerpc/math-emu/fnmsubs.c
index 5c9a09a..b20f4eb 100644
--- a/arch/powerpc/math-emu/fnmsubs.c
+++ b/arch/powerpc/math-emu/fnmsubs.c
@@ -17,7 +17,7 @@ fnmsubs(void *frD, void *frA, void *frB, void *frC)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fres.c b/arch/powerpc/math-emu/fres.c
index ec11e46..10ecbd0 100644
--- a/arch/powerpc/math-emu/fres.c
+++ b/arch/powerpc/math-emu/fres.c
@@ -6,7 +6,7 @@ int
 fres(void *frD, void *frB)
 {
 #ifdef DEBUG
-	printk("%s: %p %p\n", __FUNCTION__, frD, frB);
+	printk("%s: %p %p\n", __func__, frD, frB);
 #endif
 	return -ENOSYS;
 }
diff --git a/arch/powerpc/math-emu/frsp.c b/arch/powerpc/math-emu/frsp.c
index d879b2a..724ccbc 100644
--- a/arch/powerpc/math-emu/frsp.c
+++ b/arch/powerpc/math-emu/frsp.c
@@ -12,7 +12,7 @@ frsp(void *frD, void *frB)
 	FP_DECL_D(B);
 
 #ifdef DEBUG
-	printk("%s: D %p, B %p\n", __FUNCTION__, frD, frB);
+	printk("%s: D %p, B %p\n", __func__, frD, frB);
 #endif
 
 	__FP_UNPACK_D(B, frB);
diff --git a/arch/powerpc/math-emu/frsqrte.c b/arch/powerpc/math-emu/frsqrte.c
index a11ae18..1d0a3a0 100644
--- a/arch/powerpc/math-emu/frsqrte.c
+++ b/arch/powerpc/math-emu/frsqrte.c
@@ -6,7 +6,7 @@ int
 frsqrte(void *frD, void *frB)
 {
 #ifdef DEBUG
-	printk("%s: %p %p\n", __FUNCTION__, frD, frB);
+	printk("%s: %p %p\n", __func__, frD, frB);
 #endif
 	return 0;
 }
diff --git a/arch/powerpc/math-emu/fsel.c b/arch/powerpc/math-emu/fsel.c
index e36e6e7..ecb5f28 100644
--- a/arch/powerpc/math-emu/fsel.c
+++ b/arch/powerpc/math-emu/fsel.c
@@ -11,7 +11,7 @@ fsel(u32 *frD, void *frA, u32 *frB, u32 *frC)
 	FP_DECL_D(A);
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fsqrt.c b/arch/powerpc/math-emu/fsqrt.c
index 6f8319f..38ec2b7 100644
--- a/arch/powerpc/math-emu/fsqrt.c
+++ b/arch/powerpc/math-emu/fsqrt.c
@@ -13,7 +13,7 @@ fsqrt(void *frD, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frB);
+	printk("%s: %p %p %p %p\n", __func__, frD, frB);
 #endif
 
 	__FP_UNPACK_D(B, frB);
diff --git a/arch/powerpc/math-emu/fsqrts.c b/arch/powerpc/math-emu/fsqrts.c
index 3b2b1cf..335263e 100644
--- a/arch/powerpc/math-emu/fsqrts.c
+++ b/arch/powerpc/math-emu/fsqrts.c
@@ -14,7 +14,7 @@ fsqrts(void *frD, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frB);
+	printk("%s: %p %p %p %p\n", __func__, frD, frB);
 #endif
 
 	__FP_UNPACK_D(B, frB);
diff --git a/arch/powerpc/math-emu/fsub.c b/arch/powerpc/math-emu/fsub.c
index 9566790..208d20f 100644
--- a/arch/powerpc/math-emu/fsub.c
+++ b/arch/powerpc/math-emu/fsub.c
@@ -14,7 +14,7 @@ fsub(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/fsubs.c b/arch/powerpc/math-emu/fsubs.c
index 3428117..0e61b80 100644
--- a/arch/powerpc/math-emu/fsubs.c
+++ b/arch/powerpc/math-emu/fsubs.c
@@ -15,7 +15,7 @@ fsubs(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff --git a/arch/powerpc/math-emu/lfd.c b/arch/powerpc/math-emu/lfd.c
index 7d38101..6ec90b5 100644
--- a/arch/powerpc/math-emu/lfd.c
+++ b/arch/powerpc/math-emu/lfd.c
@@ -11,7 +11,7 @@ lfd(void *frD, void *ea)
 	if (copy_from_user(frD, ea, sizeof(double)))
 		return -EFAULT;
 #ifdef DEBUG
-	printk("%s: D %p, ea %p: ", __FUNCTION__, frD, ea);
+	printk("%s: D %p, ea %p: ", __func__, frD, ea);
 	dump_double(frD);
 	printk("\n");
 #endif
diff --git a/arch/powerpc/math-emu/lfs.c b/arch/powerpc/math-emu/lfs.c
index c86dee3..6f18ebe 100644
--- a/arch/powerpc/math-emu/lfs.c
+++ b/arch/powerpc/math-emu/lfs.c
@@ -14,7 +14,7 @@ lfs(void *frD, void *ea)
 	float f;
 
 #ifdef DEBUG
-	printk("%s: D %p, ea %p\n", __FUNCTION__, frD, ea);
+	printk("%s: D %p, ea %p\n", __func__, frD, ea);
 #endif
 
 	if (copy_from_user(&f, ea, sizeof(float)))
diff --git a/arch/powerpc/math-emu/mcrfs.c b/arch/powerpc/math-emu/mcrfs.c
index 106dd91..41ba247 100644
--- a/arch/powerpc/math-emu/mcrfs.c
+++ b/arch/powerpc/math-emu/mcrfs.c
@@ -10,7 +10,7 @@ mcrfs(u32 *ccr, u32 crfD, u32 crfS)
 	u32 value, clear;
 
 #ifdef DEBUG
-	printk("%s: %p (%08x) %d %d\n", __FUNCTION__, ccr, *ccr, crfD, crfS);
+	printk("%s: %p (%08x) %d %d\n", __func__, ccr, *ccr, crfD, crfS);
 #endif
 
 	clear = 15 << ((7 - crfS) << 2);
@@ -24,7 +24,7 @@ mcrfs(u32 *ccr, u32 crfD, u32 crfS)
 	*ccr |= (value << ((7 - crfD) << 2));
 
 #ifdef DEBUG
-	printk("CR: %08x\n", __FUNCTION__, *ccr);
+	printk("CR: %08x\n", __func__, *ccr);
 #endif
 
 	return 0;
diff --git a/arch/powerpc/math-emu/mffs.c b/arch/powerpc/math-emu/mffs.c
index f477c91..b0e2106 100644
--- a/arch/powerpc/math-emu/mffs.c
+++ b/arch/powerpc/math-emu/mffs.c
@@ -10,7 +10,7 @@ mffs(u32 *frD)
 	frD[1] = __FPU_FPSCR;
 
 #ifdef DEBUG
-	printk("%s: frD %p: %08x.%08x\n", __FUNCTION__, frD, frD[0], frD[1]);
+	printk("%s: frD %p: %08x.%08x\n", __func__, frD, frD[0], frD[1]);
 #endif
 
 	return 0;
diff --git a/arch/powerpc/math-emu/mtfsb0.c b/arch/powerpc/math-emu/mtfsb0.c
index 99bfd80..d306235 100644
--- a/arch/powerpc/math-emu/mtfsb0.c
+++ b/arch/powerpc/math-emu/mtfsb0.c
@@ -11,7 +11,7 @@ mtfsb0(int crbD)
 		__FPU_FPSCR &= ~(1 << (31 - crbD));
 
 #ifdef DEBUG
-	printk("%s: %d %08lx\n", __FUNCTION__, crbD, __FPU_FPSCR);
+	printk("%s: %d %08lx\n", __func__, crbD, __FPU_FPSCR);
 #endif
 
 	return 0;
diff --git a/arch/powerpc/math-emu/mtfsb1.c b/arch/powerpc/math-emu/mtfsb1.c
index 3d9e7ed..2e94870 100644
--- a/arch/powerpc/math-emu/mtfsb1.c
+++ b/arch/powerpc/math-emu/mtfsb1.c
@@ -11,7 +11,7 @@ mtfsb1(int crbD)
 		__FPU_FPSCR |= (1 << (31 - crbD));
 
 #ifdef DEBUG
-	printk("%s: %d %08lx\n", __FUNCTION__, crbD, __FPU_FPSCR);
+	printk("%s: %d %08lx\n", __func__, crbD, __FPU_FPSCR);
 #endif
 
 	return 0;
diff --git a/arch/powerpc/math-emu/mtfsf.c b/arch/powerpc/math-emu/mtfsf.c
index d70cf71..48014d8 100644
--- a/arch/powerpc/math-emu/mtfsf.c
+++ b/arch/powerpc/math-emu/mtfsf.c
@@ -38,7 +38,7 @@ mtfsf(unsigned int FM, u32 *frB)
 	__FPU_FPSCR |= (frB[1] & mask);
 
 #ifdef DEBUG
-	printk("%s: %02x %p: %08lx\n", __FUNCTION__, FM, frB, __FPU_FPSCR);
+	printk("%s: %02x %p: %08lx\n", __func__, FM, frB, __FPU_FPSCR);
 #endif
 
 	return 0;
diff --git a/arch/powerpc/math-emu/mtfsfi.c b/arch/powerpc/math-emu/mtfsfi.c
index 71df854..031e200 100644
--- a/arch/powerpc/math-emu/mtfsfi.c
+++ b/arch/powerpc/math-emu/mtfsfi.c
@@ -16,7 +16,7 @@ mtfsfi(unsigned int crfD, unsigned int IMM)
 	__FPU_FPSCR |= (IMM & 0xf) << ((7 - crfD) << 2);
 
 #ifdef DEBUG
-	printk("%s: %d %x: %08lx\n", __FUNCTION__, crfD, IMM, __FPU_FPSCR);
+	printk("%s: %d %x: %08lx\n", __func__, crfD, IMM, __FPU_FPSCR);
 #endif
 
 	return 0;
diff --git a/arch/powerpc/math-emu/stfd.c b/arch/powerpc/math-emu/stfd.c
index 3f8c255..33a165c 100644
--- a/arch/powerpc/math-emu/stfd.c
+++ b/arch/powerpc/math-emu/stfd.c
@@ -7,7 +7,7 @@ stfd(void *frS, void *ea)
 {
 #if 0
 #ifdef DEBUG
-	printk("%s: S %p, ea %p: ", __FUNCTION__, frS, ea);
+	printk("%s: S %p, ea %p: ", __func__, frS, ea);
 	dump_double(frS);
 	printk("\n");
 #endif
diff --git a/arch/powerpc/math-emu/stfiwx.c b/arch/powerpc/math-emu/stfiwx.c
index 95caaee..f15a35f 100644
--- a/arch/powerpc/math-emu/stfiwx.c
+++ b/arch/powerpc/math-emu/stfiwx.c
@@ -6,7 +6,7 @@ int
 stfiwx(u32 *frS, void *ea)
 {
 #ifdef DEBUG
-	printk("%s: %p %p\n", __FUNCTION__, frS, ea);
+	printk("%s: %p %p\n", __func__, frS, ea);
 #endif
 
 	if (copy_to_user(ea, &frS[1], sizeof(frS[1])))
diff --git a/arch/powerpc/math-emu/stfs.c b/arch/powerpc/math-emu/stfs.c
index e87ca23..8689aa4 100644
--- a/arch/powerpc/math-emu/stfs.c
+++ b/arch/powerpc/math-emu/stfs.c
@@ -15,7 +15,7 @@ stfs(void *frS, void *ea)
 	int err;
 
 #ifdef DEBUG
-	printk("%s: S %p, ea %p\n", __FUNCTION__, frS, ea);
+	printk("%s: S %p, ea %p\n", __func__, frS, ea);
 #endif
 
 	__FP_UNPACK_D(A, frS);
diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index 977cb1e..45d67e8 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -276,7 +276,7 @@ static int __init setup_kcore(void)
 
 		kcore_mem = kmalloc(sizeof(struct kcore_list), GFP_ATOMIC);
 		if (!kcore_mem)
-			panic("%s: kmalloc failed\n", __FUNCTION__);
+			panic("%s: kmalloc failed\n", __func__);
 
 		/* must stay under 32 bits */
 		if ( 0xfffffffful - (unsigned long)__va(base) < size) {
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index c0f5cff..08194d8 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -122,7 +122,7 @@ static int __init setup_kcore(void)
 		/* GFP_ATOMIC to avoid might_sleep warnings during boot */
 		kcore_mem = kmalloc(sizeof(struct kcore_list), GFP_ATOMIC);
 		if (!kcore_mem)
-			panic("%s: kmalloc failed\n", __FUNCTION__);
+			panic("%s: kmalloc failed\n", __func__);
 
 		kclist_add(kcore_mem, __va(base), size);
 	}
diff --git a/arch/powerpc/oprofile/cell/spu_task_sync.c b/arch/powerpc/oprofile/cell/spu_task_sync.c
index 257b13c..2a9b4a0 100644
--- a/arch/powerpc/oprofile/cell/spu_task_sync.c
+++ b/arch/powerpc/oprofile/cell/spu_task_sync.c
@@ -68,7 +68,7 @@ static struct cached_info *get_cached_info(struct spu *the_spu, int spu_num)
 	if (spu_num >= num_spu_nodes) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: Invalid index %d into spu info cache\n",
-		       __FUNCTION__, __LINE__, spu_num);
+		       __func__, __LINE__, spu_num);
 		ret_info = NULL;
 		goto out;
 	}
@@ -115,7 +115,7 @@ prepare_cached_spu_info(struct spu *spu, unsigned long objectId)
 	if (!info) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: create vma_map failed\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		retval = -ENOMEM;
 		goto err_alloc;
 	}
@@ -123,7 +123,7 @@ prepare_cached_spu_info(struct spu *spu, unsigned long objectId)
 	if (!new_map) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: create vma_map failed\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		retval = -ENOMEM;
 		goto err_alloc;
 	}
@@ -171,7 +171,7 @@ static int release_cached_info(int spu_index)
 			printk(KERN_ERR "SPU_PROF: "
 				"%s, line %d: "
 				"Invalid index %d into spu info cache\n",
-				__FUNCTION__, __LINE__, spu_index);
+				__func__, __LINE__, spu_index);
 			goto out;
 		}
 		end = spu_index + 1;
@@ -273,7 +273,7 @@ fail_no_image_cookie:
 
 	printk(KERN_ERR "SPU_PROF: "
 		"%s, line %d: Cannot find dcookie for SPU binary\n",
-		__FUNCTION__, __LINE__);
+		__func__, __LINE__);
 	goto out;
 }
 
@@ -467,7 +467,7 @@ int spu_sync_stop(void)
 	if (ret) {
 		printk(KERN_ERR "SPU_PROF: "
 			"%s, line %d: spu_switch_event_unregister returned %d\n",
-			__FUNCTION__, __LINE__, ret);
+			__func__, __LINE__, ret);
 		goto out;
 	}
 
diff --git a/arch/powerpc/oprofile/cell/vma_map.c b/arch/powerpc/oprofile/cell/vma_map.c
index 76ec1d1..5cf5368 100644
--- a/arch/powerpc/oprofile/cell/vma_map.c
+++ b/arch/powerpc/oprofile/cell/vma_map.c
@@ -72,7 +72,7 @@ vma_map_add(struct vma_to_fileoffset_map *map, unsigned int vma,
 		kzalloc(sizeof(struct vma_to_fileoffset_map), GFP_KERNEL);
 	if (!new) {
 		printk(KERN_ERR "SPU_PROF: %s, line %d: malloc failed\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		vma_map_free(map);
 		return NULL;
 	}
@@ -132,19 +132,19 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
 	if (memcmp(ehdr.e_ident, expected, EI_PAD) != 0) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: Unexpected e_ident parsing SPU ELF\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		goto fail;
 	}
 	if (ehdr.e_machine != EM_SPU) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: Unexpected e_machine parsing SPU ELF\n",
-		       __FUNCTION__,  __LINE__);
+		       __func__,  __LINE__);
 		goto fail;
 	}
 	if (ehdr.e_type != ET_EXEC) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: Unexpected e_type parsing SPU ELF\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		goto fail;
 	}
 	phdr_start = spu_elf_start + ehdr.e_phoff;
@@ -235,7 +235,7 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
 	if (overlay_tbl_offset < 0) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: Error finding SPU overlay table\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		goto fail;
 	}
 	ovly_table = spu_elf_start + overlay_tbl_offset;
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index 1392977..e6fef9d 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -216,7 +216,7 @@ static void pm_rtas_reset_signals(u32 node)
 		 * failure to stop OProfile.
 		 */
 		printk(KERN_WARNING "%s: rtas returned: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 }
 
 static int pm_rtas_activate_signals(u32 node, u32 count)
@@ -255,7 +255,7 @@ static int pm_rtas_activate_signals(u32 node, u32 count)
 
 		if (unlikely(ret)) {
 			printk(KERN_WARNING "%s: rtas returned: %d\n",
-			       __FUNCTION__, ret);
+			       __func__, ret);
 			return -EIO;
 		}
 	}
@@ -560,7 +560,7 @@ static int cell_reg_setup(struct op_counter_config *ctr,
 		if (unlikely(spu_rtas_token == RTAS_UNKNOWN_SERVICE)) {
 			printk(KERN_ERR
 			       "%s: rtas token ibm,cbe-spu-perftools unknown\n",
-			       __FUNCTION__);
+			       __func__);
 			return -EIO;
 		}
 	}
@@ -576,7 +576,7 @@ static int cell_reg_setup(struct op_counter_config *ctr,
 	if (unlikely(pm_rtas_token == RTAS_UNKNOWN_SERVICE)) {
 		printk(KERN_ERR
 		       "%s: rtas token ibm,cbe-perftools unknown\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EIO;
 	}
 
@@ -853,7 +853,7 @@ static int pm_rtas_activate_spu_profiling(u32 node)
 
 	if (unlikely(ret)) {
 		printk(KERN_WARNING "%s: rtas returned: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 		return -EIO;
 	}
 
@@ -949,7 +949,7 @@ static int cell_global_start_spu(struct op_counter_config *ctr)
 		if (unlikely(ret != 0)) {
 			printk(KERN_ERR
 			       "%s: rtas call ibm,cbe-spu-perftools failed, return = %d\n",
-			       __FUNCTION__, ret);
+			       __func__, ret);
 			rtas_error = -EIO;
 			goto out;
 		}
@@ -1061,7 +1061,7 @@ static void cell_global_stop_spu(void)
 		if (unlikely(rtn_value != 0)) {
 			printk(KERN_ERR
 			       "%s: rtas call ibm,cbe-spu-perftools failed, return = %d\n",
-			       __FUNCTION__, rtn_value);
+			       __func__, rtn_value);
 		}
 
 		/* Deactivate the signals */
diff --git a/arch/powerpc/platforms/52xx/lite5200.c b/arch/powerpc/platforms/52xx/lite5200.c
index 956f459..6d584f4 100644
--- a/arch/powerpc/platforms/52xx/lite5200.c
+++ b/arch/powerpc/platforms/52xx/lite5200.c
@@ -63,7 +63,7 @@ lite5200_fix_clock_config(void)
 	of_node_put(np);
 	if (!cdm) {
 		printk(KERN_ERR "%s() failed; expect abnormal behaviour\n",
-		       __FUNCTION__);
+		       __func__);
 		return;
 	}
 
@@ -98,7 +98,7 @@ lite5200_fix_port_config(void)
 	of_node_put(np);
 	if (!gpio) {
 		printk(KERN_ERR "%s() failed. expect abnormal behavior\n",
-		       __FUNCTION__);
+		       __func__);
 		return;
 	}
 
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
index bdb3d0b..2865d01 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -36,7 +36,7 @@
 #undef DEBUG
 
 #ifdef DEBUG
-#define DBG(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#define DBG(fmt, args...) printk(KERN_ERR "%s: " fmt, __func__, ## args)
 #else
 #define DBG(fmt, args...)
 #endif
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index edab631..ad03a4c 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -324,7 +324,7 @@ static void cell_iommu_setup_page_tables(struct cbe_iommu *iommu,
 	pages_per_segment = 1ull << IO_PAGENO_BITS;
 
 	pr_debug("%s: iommu[%d]: segments: %lu, pages per segment: %lu\n",
-			__FUNCTION__, iommu->nid, segments, pages_per_segment);
+			__func__, iommu->nid, segments, pages_per_segment);
 
 	/* set up the segment table */
 	stab_size = segments * sizeof(unsigned long);
@@ -337,7 +337,7 @@ static void cell_iommu_setup_page_tables(struct cbe_iommu *iommu,
 	 * the page tables as one array of ptes, like pSeries does.
 	 */
 	ptab_size = segments * pages_per_segment * sizeof(unsigned long);
-	pr_debug("%s: iommu[%d]: ptab_size: %lu, order: %d\n", __FUNCTION__,
+	pr_debug("%s: iommu[%d]: ptab_size: %lu, order: %d\n", __func__,
 			iommu->nid, ptab_size, get_order(ptab_size));
 	page = alloc_pages_node(iommu->nid, GFP_KERNEL, get_order(ptab_size));
 	BUG_ON(!page);
@@ -356,7 +356,7 @@ static void cell_iommu_setup_page_tables(struct cbe_iommu *iommu,
 		       sizeof(unsigned long)) >> IOMMU_PAGE_SHIFT;
 
 	pr_debug("%s: iommu[%d]: stab at %p, ptab at %p, n_pte_pages: %lu\n",
-			__FUNCTION__, iommu->nid, iommu->stab, iommu->ptab,
+			__func__, iommu->nid, iommu->stab, iommu->ptab,
 			n_pte_pages);
 
 	/* initialise the STEs */
@@ -387,7 +387,7 @@ static void cell_iommu_enable_hardware(struct cbe_iommu *iommu)
 
 	if (cell_iommu_find_ioc(iommu->nid, &xlate_base))
 		panic("%s: missing IOC register mappings for node %d\n",
-		      __FUNCTION__, iommu->nid);
+		      __func__, iommu->nid);
 
 	iommu->xlate_regs = ioremap(xlate_base, IOC_Reg_Size);
 	iommu->cmd_regs = iommu->xlate_regs + IOC_IOCmd_Offset;
diff --git a/arch/powerpc/platforms/cell/pervasive.c b/arch/powerpc/platforms/cell/pervasive.c
index 0304589..8a3631c 100644
--- a/arch/powerpc/platforms/cell/pervasive.c
+++ b/arch/powerpc/platforms/cell/pervasive.c
@@ -65,7 +65,7 @@ static void cbe_power_save(void)
 		break;
 	default:
 		printk(KERN_WARNING "%s: unknown configuration\n",
-			__FUNCTION__);
+			__func__);
 		break;
 	}
 	mtspr(SPRN_TSC_CELL, thread_switch_control);
diff --git a/arch/powerpc/platforms/cell/ras.c b/arch/powerpc/platforms/cell/ras.c
index e43024c..655704a 100644
--- a/arch/powerpc/platforms/cell/ras.c
+++ b/arch/powerpc/platforms/cell/ras.c
@@ -132,7 +132,7 @@ static int __init cbe_ptcal_enable_on_node(int nid, int order)
 				(unsigned int)(addr >> 32),
 				(unsigned int)(addr & 0xffffffff))) {
 		printk(KERN_ERR "%s: error enabling PTCAL on node %d!\n",
-				__FUNCTION__, nid);
+				__func__, nid);
 		goto out_free_pages;
 	}
 
@@ -162,7 +162,7 @@ static int __init cbe_ptcal_enable(void)
 	if (!size)
 		return -ENODEV;
 
-	pr_debug("%s: enabling PTCAL, size = 0x%x\n", __FUNCTION__, *size);
+	pr_debug("%s: enabling PTCAL, size = 0x%x\n", __func__, *size);
 	order = get_order(*size);
 	of_node_put(np);
 
@@ -180,7 +180,7 @@ static int __init cbe_ptcal_enable(void)
 		const u32 *nid = of_get_property(np, "node-id", NULL);
 		if (!nid) {
 			printk(KERN_ERR "%s: node %s is missing node-id?\n",
-					__FUNCTION__, np->full_name);
+					__func__, np->full_name);
 			continue;
 		}
 		cbe_ptcal_enable_on_node(*nid, order);
@@ -195,13 +195,13 @@ static int cbe_ptcal_disable(void)
 	struct ptcal_area *area, *tmp;
 	int ret = 0;
 
-	pr_debug("%s: disabling PTCAL\n", __FUNCTION__);
+	pr_debug("%s: disabling PTCAL\n", __func__);
 
 	list_for_each_entry_safe(area, tmp, &ptcal_list, list) {
 		/* disable ptcal on this node */
 		if (rtas_call(ptcal_stop_tok, 1, 1, NULL, area->nid)) {
 			printk(KERN_ERR "%s: error disabling PTCAL "
-					"on node %d!\n", __FUNCTION__,
+					"on node %d!\n", __func__,
 					area->nid);
 			ret = -EIO;
 			continue;
diff --git a/arch/powerpc/platforms/cell/spu_base.c b/arch/powerpc/platforms/cell/spu_base.c
index 87eb07f..b898a84 100644
--- a/arch/powerpc/platforms/cell/spu_base.c
+++ b/arch/powerpc/platforms/cell/spu_base.c
@@ -158,7 +158,7 @@ static int __spu_trap_data_seg(struct spu *spu, unsigned long ea)
 	struct spu_slb slb;
 	int psize;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	slb.esid = (ea & ESID_MASK) | SLB_ESID_V;
 
@@ -208,7 +208,7 @@ static int __spu_trap_data_seg(struct spu *spu, unsigned long ea)
 extern int hash_page(unsigned long ea, unsigned long access, unsigned long trap); //XXX
 static int __spu_trap_data_map(struct spu *spu, unsigned long ea, u64 dsisr)
 {
-	pr_debug("%s, %lx, %lx\n", __FUNCTION__, dsisr, ea);
+	pr_debug("%s, %lx, %lx\n", __func__, dsisr, ea);
 
 	/* Handle kernel space hash faults immediately.
 	   User hash faults need to be deferred to process context. */
@@ -338,7 +338,7 @@ spu_irq_class_1(int irq, void *data)
 		spu_mfc_dsisr_set(spu, 0ul);
 	spu_int_stat_clear(spu, 1, stat);
 	spin_unlock(&spu->register_lock);
-	pr_debug("%s: %lx %lx %lx %lx\n", __FUNCTION__, mask, stat,
+	pr_debug("%s: %lx %lx %lx %lx\n", __func__, mask, stat,
 			dar, dsisr);
 
 	if (stat & CLASS1_SEGMENT_FAULT_INTR)
@@ -716,7 +716,7 @@ static int __init init_spu_base(void)
 
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: Error initializing spus\n",
-			__FUNCTION__);
+			__func__);
 		goto out_unregister_sysdev_class;
 	}
 
diff --git a/arch/powerpc/platforms/cell/spu_callbacks.c b/arch/powerpc/platforms/cell/spu_callbacks.c
index dceb8b6..19f6bfd 100644
--- a/arch/powerpc/platforms/cell/spu_callbacks.c
+++ b/arch/powerpc/platforms/cell/spu_callbacks.c
@@ -54,7 +54,7 @@ long spu_sys_callback(struct spu_syscall_block *s)
 	long (*syscall)(u64 a1, u64 a2, u64 a3, u64 a4, u64 a5, u64 a6);
 
 	if (s->nr_ret >= ARRAY_SIZE(spu_syscall_table)) {
-		pr_debug("%s: invalid syscall #%ld", __FUNCTION__, s->nr_ret);
+		pr_debug("%s: invalid syscall #%ld", __func__, s->nr_ret);
 		return -ENOSYS;
 	}
 
diff --git a/arch/powerpc/platforms/cell/spu_manage.c b/arch/powerpc/platforms/cell/spu_manage.c
index d351bde..4c506c1 100644
--- a/arch/powerpc/platforms/cell/spu_manage.c
+++ b/arch/powerpc/platforms/cell/spu_manage.c
@@ -92,7 +92,7 @@ static int __init spu_map_interrupts_old(struct spu *spu,
 
 	tmp = of_get_property(np->parent->parent, "node-id", NULL);
 	if (!tmp) {
-		printk(KERN_WARNING "%s: can't find node-id\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: can't find node-id\n", __func__);
 		nid = spu->node;
 	} else
 		nid = tmp[0];
@@ -296,7 +296,7 @@ static int __init of_enumerate_spus(int (*fn)(void *data))
 		ret = fn(node);
 		if (ret) {
 			printk(KERN_WARNING "%s: Error initializing %s\n",
-				__FUNCTION__, node->name);
+				__func__, node->name);
 			break;
 		}
 		n++;
@@ -327,7 +327,7 @@ static int __init of_create_spu(struct spu *spu, void *data)
 		if (!legacy_map) {
 			legacy_map = 1;
 			printk(KERN_WARNING "%s: Legacy device tree found, "
-				"trying to map old style\n", __FUNCTION__);
+				"trying to map old style\n", __func__);
 		}
 		ret = spu_map_device_old(spu);
 		if (ret) {
@@ -342,7 +342,7 @@ static int __init of_create_spu(struct spu *spu, void *data)
 		if (!legacy_irq) {
 			legacy_irq = 1;
 			printk(KERN_WARNING "%s: Legacy device tree found, "
-				"trying old style irq\n", __FUNCTION__);
+				"trying old style irq\n", __func__);
 		}
 		ret = spu_map_interrupts_old(spu, spe);
 		if (ret) {
diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index c66c375..149bc66 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -1546,7 +1546,7 @@ void spufs_mfc_callback(struct spu *spu)
 
 	wake_up_all(&ctx->mfc_wq);
 
-	pr_debug("%s %s\n", __FUNCTION__, spu->name);
+	pr_debug("%s %s\n", __func__, spu->name);
 	if (ctx->mfc_fasync) {
 		u32 free_elements, tagstatus;
 		unsigned int mask;
@@ -1780,7 +1780,7 @@ static unsigned int spufs_mfc_poll(struct file *file,poll_table *wait)
 	if (tagstatus & ctx->tagwait)
 		mask |= POLLIN | POLLRDNORM;
 
-	pr_debug("%s: free %d tagstatus %d tagwait %d\n", __FUNCTION__,
+	pr_debug("%s: free %d tagstatus %d tagwait %d\n", __func__,
 		free_elements, tagstatus, ctx->tagwait);
 
 	return mask;
diff --git a/arch/powerpc/platforms/cell/spufs/run.c b/arch/powerpc/platforms/cell/spufs/run.c
index 6221968..4455ef4 100644
--- a/arch/powerpc/platforms/cell/spufs/run.c
+++ b/arch/powerpc/platforms/cell/spufs/run.c
@@ -98,7 +98,7 @@ static int spu_setup_isolated(struct spu_context *ctx)
 			!= MFC_CNTL_PURGE_DMA_COMPLETE) {
 		if (time_after(jiffies, timeout)) {
 			printk(KERN_ERR "%s: timeout flushing MFC DMA queue\n",
-					__FUNCTION__);
+					__func__);
 			ret = -EIO;
 			goto out;
 		}
@@ -124,7 +124,7 @@ static int spu_setup_isolated(struct spu_context *ctx)
 				status_loading) {
 		if (time_after(jiffies, timeout)) {
 			printk(KERN_ERR "%s: timeout waiting for loader\n",
-					__FUNCTION__);
+					__func__);
 			ret = -EIO;
 			goto out_drop_priv;
 		}
@@ -134,7 +134,7 @@ static int spu_setup_isolated(struct spu_context *ctx)
 	if (!(status & SPU_STATUS_RUNNING)) {
 		/* If isolated LOAD has failed: run SPU, we will get a stop-and
 		 * signal later. */
-		pr_debug("%s: isolated LOAD failed\n", __FUNCTION__);
+		pr_debug("%s: isolated LOAD failed\n", __func__);
 		ctx->ops->runcntl_write(ctx, SPU_RUNCNTL_RUNNABLE);
 		ret = -EACCES;
 		goto out_drop_priv;
@@ -142,7 +142,7 @@ static int spu_setup_isolated(struct spu_context *ctx)
 
 	if (!(status & SPU_STATUS_ISOLATED_STATE)) {
 		/* This isn't allowed by the CBEA, but check anyway */
-		pr_debug("%s: SPU fell out of isolated mode?\n", __FUNCTION__);
+		pr_debug("%s: SPU fell out of isolated mode?\n", __func__);
 		ctx->ops->runcntl_write(ctx, SPU_RUNCNTL_STOP);
 		ret = -EINVAL;
 		goto out_drop_priv;
@@ -281,7 +281,7 @@ static int spu_handle_restartsys(struct spu_context *ctx, long *spu_ret,
 		break;
 	default:
 		printk(KERN_WARNING "%s: unexpected return code %ld\n",
-			__FUNCTION__, *spu_ret);
+			__func__, *spu_ret);
 		ret = 0;
 	}
 	return ret;
diff --git a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
index d4f8bf5..84e2d78 100644
--- a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
+++ b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
@@ -117,11 +117,11 @@ static void __init mpc7448_hpc2_init_IRQ(void)
 	}
 
 	if (mpic_paddr == 0) {
-		printk("%s: No tsi108 PIC found !\n", __FUNCTION__);
+		printk("%s: No tsi108 PIC found !\n", __func__);
 		return;
 	}
 
-	DBG("%s: tsi108 pic phys_addr = 0x%x\n", __FUNCTION__,
+	DBG("%s: tsi108 pic phys_addr = 0x%x\n", __func__,
 	    (u32) mpic_paddr);
 
 	mpic = mpic_alloc(tsi_pic, mpic_paddr,
@@ -140,17 +140,17 @@ static void __init mpc7448_hpc2_init_IRQ(void)
 #ifdef CONFIG_PCI
 	tsi_pci = of_find_node_by_type(NULL, "pci");
 	if (tsi_pci == NULL) {
-		printk("%s: No tsi108 pci node found !\n", __FUNCTION__);
+		printk("%s: No tsi108 pci node found !\n", __func__);
 		return;
 	}
 	cascade_node = of_find_node_by_type(NULL, "pic-router");
 	if (cascade_node == NULL) {
-		printk("%s: No tsi108 pci cascade node found !\n", __FUNCTION__);
+		printk("%s: No tsi108 pci cascade node found !\n", __func__);
 		return;
 	}
 
 	cascade_pci_irq = irq_of_parse_and_map(tsi_pci, 0);
-	DBG("%s: tsi108 cascade_pci_irq = 0x%x\n", __FUNCTION__,
+	DBG("%s: tsi108 cascade_pci_irq = 0x%x\n", __func__,
 	    (u32) cascade_pci_irq);
 	tsi108_pci_int_init(cascade_node);
 	set_irq_data(cascade_pci_irq, mpic);
diff --git a/arch/powerpc/platforms/ps3/setup.c b/arch/powerpc/platforms/ps3/setup.c
index 5c2cbb0..542168c 100644
--- a/arch/powerpc/platforms/ps3/setup.c
+++ b/arch/powerpc/platforms/ps3/setup.c
@@ -117,7 +117,7 @@ static void __init prealloc(struct ps3_prealloc *p)
 
 	p->address = __alloc_bootmem(p->size, p->align, __pa(MAX_DMA_ADDRESS));
 	if (!p->address) {
-		printk(KERN_ERR "%s: Cannot allocate %s\n", __FUNCTION__,
+		printk(KERN_ERR "%s: Cannot allocate %s\n", __func__,
 		       p->name);
 		return;
 	}
diff --git a/arch/powerpc/platforms/pseries/pci_dlpar.c b/arch/powerpc/platforms/pseries/pci_dlpar.c
index 5a5a19e..0d7229c 100644
--- a/arch/powerpc/platforms/pseries/pci_dlpar.c
+++ b/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -123,7 +123,7 @@ pcibios_pci_config_bridge(struct pci_dev *dev)
 	/* Add to children of PCI bridge dev->bus */
 	child_bus = pci_add_new_bus(dev->bus, dev, sec_busno);
 	if (!child_bus) {
-		printk (KERN_ERR "%s: could not add second bus\n", __FUNCTION__);
+		printk (KERN_ERR "%s: could not add second bus\n", __func__);
 		return -EIO;
 	}
 	sprintf(child_bus->name, "PCI Bus #%02x", child_bus->number);
diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index 2800fce..ac75c10 100644
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -222,14 +222,14 @@ static char * parse_next_property(char *buf, char *end, char **name, int *length
 	tmp = strchr(buf, ' ');
 	if (!tmp) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		return NULL;
 	}
 	*tmp = '\0';
 
 	if (++tmp >= end) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		return NULL;
 	}
 
@@ -238,12 +238,12 @@ static char * parse_next_property(char *buf, char *end, char **name, int *length
 	*length = simple_strtoul(tmp, &tmp, 10);
 	if (*length == -1) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		return NULL;
 	}
 	if (*tmp != ' ' || ++tmp >= end) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		return NULL;
 	}
 
@@ -252,12 +252,12 @@ static char * parse_next_property(char *buf, char *end, char **name, int *length
 	tmp += *length;
 	if (tmp > end) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		return NULL;
 	}
 	else if (tmp < end && *tmp != ' ' && *tmp != '\0') {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		return NULL;
 	}
 	tmp++;
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index df8bd2b..3eceeb5 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -257,7 +257,7 @@ int cpm_command(u32 command, u8 opcode)
 		if ((in_be16(&cpmp->cp_cpcr) & CPM_CR_FLG) == 0)
 			goto out;
 
-	printk(KERN_ERR "%s(): Not able to issue CPM command\n", __FUNCTION__);
+	printk(KERN_ERR "%s(): Not able to issue CPM command\n", __func__);
 	ret = -EIO;
 out:
 	spin_unlock_irqrestore(&cmd_lock, flags);
diff --git a/arch/powerpc/sysdev/cpm2.c b/arch/powerpc/sysdev/cpm2.c
index 7be7112..803b59c 100644
--- a/arch/powerpc/sysdev/cpm2.c
+++ b/arch/powerpc/sysdev/cpm2.c
@@ -99,7 +99,7 @@ int cpm_command(u32 command, u8 opcode)
 		if ((in_be32(&cpmp->cp_cpcr) & CPM_CR_FLG) == 0)
 			goto out;
 
-	printk(KERN_ERR "%s(): Not able to issue CPM command\n", __FUNCTION__);
+	printk(KERN_ERR "%s(): Not able to issue CPM command\n", __func__);
 	ret = -EIO;
 out:
 	spin_unlock_irqrestore(&cmd_lock, flags);
diff --git a/arch/powerpc/sysdev/qe_lib/qe_io.c b/arch/powerpc/sysdev/qe_lib/qe_io.c
index e53ea4d..736c1fc 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_io.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_io.c
@@ -200,7 +200,7 @@ static void dump_par_io(void)
 {
 	unsigned int i;
 
-	printk(KERN_INFO "%s: par_io=%p\n", __FUNCTION__, par_io);
+	printk(KERN_INFO "%s: par_io=%p\n", __func__, par_io);
 	for (i = 0; i < num_par_io_ports; i++) {
 		printk(KERN_INFO "	cpodr[%u]=%08x\n", i,
 			in_be32(&par_io[i].cpodr));
diff --git a/arch/powerpc/sysdev/qe_lib/ucc_fast.c b/arch/powerpc/sysdev/qe_lib/ucc_fast.c
index 3223acb..bcf88e6 100644
--- a/arch/powerpc/sysdev/qe_lib/ucc_fast.c
+++ b/arch/powerpc/sysdev/qe_lib/ucc_fast.c
@@ -148,57 +148,57 @@ int ucc_fast_init(struct ucc_fast_info * uf_info, struct ucc_fast_private ** ucc
 
 	/* check if the UCC port number is in range. */
 	if ((uf_info->ucc_num < 0) || (uf_info->ucc_num > UCC_MAX_NUM - 1)) {
-		printk(KERN_ERR "%s: illegal UCC number\n", __FUNCTION__);
+		printk(KERN_ERR "%s: illegal UCC number\n", __func__);
 		return -EINVAL;
 	}
 
 	/* Check that 'max_rx_buf_length' is properly aligned (4). */
 	if (uf_info->max_rx_buf_length & (UCC_FAST_MRBLR_ALIGNMENT - 1)) {
 		printk(KERN_ERR "%s: max_rx_buf_length not aligned\n",
-			__FUNCTION__);
+			__func__);
 		return -EINVAL;
 	}
 
 	/* Validate Virtual Fifo register values */
 	if (uf_info->urfs < UCC_FAST_URFS_MIN_VAL) {
-		printk(KERN_ERR "%s: urfs is too small\n", __FUNCTION__);
+		printk(KERN_ERR "%s: urfs is too small\n", __func__);
 		return -EINVAL;
 	}
 
 	if (uf_info->urfs & (UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT - 1)) {
-		printk(KERN_ERR "%s: urfs is not aligned\n", __FUNCTION__);
+		printk(KERN_ERR "%s: urfs is not aligned\n", __func__);
 		return -EINVAL;
 	}
 
 	if (uf_info->urfet & (UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT - 1)) {
-		printk(KERN_ERR "%s: urfet is not aligned.\n", __FUNCTION__);
+		printk(KERN_ERR "%s: urfet is not aligned.\n", __func__);
 		return -EINVAL;
 	}
 
 	if (uf_info->urfset & (UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT - 1)) {
-		printk(KERN_ERR "%s: urfset is not aligned\n", __FUNCTION__);
+		printk(KERN_ERR "%s: urfset is not aligned\n", __func__);
 		return -EINVAL;
 	}
 
 	if (uf_info->utfs & (UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT - 1)) {
-		printk(KERN_ERR "%s: utfs is not aligned\n", __FUNCTION__);
+		printk(KERN_ERR "%s: utfs is not aligned\n", __func__);
 		return -EINVAL;
 	}
 
 	if (uf_info->utfet & (UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT - 1)) {
-		printk(KERN_ERR "%s: utfet is not aligned\n", __FUNCTION__);
+		printk(KERN_ERR "%s: utfet is not aligned\n", __func__);
 		return -EINVAL;
 	}
 
 	if (uf_info->utftt & (UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT - 1)) {
-		printk(KERN_ERR "%s: utftt is not aligned\n", __FUNCTION__);
+		printk(KERN_ERR "%s: utftt is not aligned\n", __func__);
 		return -EINVAL;
 	}
 
 	uccf = kzalloc(sizeof(struct ucc_fast_private), GFP_KERNEL);
 	if (!uccf) {
 		printk(KERN_ERR "%s: Cannot allocate private data\n",
-			__FUNCTION__);
+			__func__);
 		return -ENOMEM;
 	}
 
@@ -207,7 +207,7 @@ int ucc_fast_init(struct ucc_fast_info * uf_info, struct ucc_fast_private ** ucc
 	/* Set the PHY base address */
 	uccf->uf_regs = ioremap(uf_info->regs, sizeof(struct ucc_fast));
 	if (uccf->uf_regs == NULL) {
-		printk(KERN_ERR "%s: Cannot map UCC registers\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Cannot map UCC registers\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -230,7 +230,7 @@ int ucc_fast_init(struct ucc_fast_info * uf_info, struct ucc_fast_private ** ucc
 	/* Set UCC to fast type */
 	ret = ucc_set_type(uf_info->ucc_num, UCC_SPEED_TYPE_FAST);
 	if (ret) {
-		printk(KERN_ERR "%s: cannot set UCC type\n", __FUNCTION__);
+		printk(KERN_ERR "%s: cannot set UCC type\n", __func__);
 		ucc_fast_free(uccf);
 		return ret;
 	}
@@ -270,7 +270,7 @@ int ucc_fast_init(struct ucc_fast_info * uf_info, struct ucc_fast_private ** ucc
 	    qe_muram_alloc(uf_info->utfs, UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT);
 	if (IS_ERR_VALUE(uccf->ucc_fast_tx_virtual_fifo_base_offset)) {
 		printk(KERN_ERR "%s: cannot allocate MURAM for TX FIFO\n",
-			__FUNCTION__);
+			__func__);
 		uccf->ucc_fast_tx_virtual_fifo_base_offset = 0;
 		ucc_fast_free(uccf);
 		return -ENOMEM;
@@ -283,7 +283,7 @@ int ucc_fast_init(struct ucc_fast_info * uf_info, struct ucc_fast_private ** ucc
 			   UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT);
 	if (IS_ERR_VALUE(uccf->ucc_fast_rx_virtual_fifo_base_offset)) {
 		printk(KERN_ERR "%s: cannot allocate MURAM for RX FIFO\n",
-			__FUNCTION__);
+			__func__);
 		uccf->ucc_fast_rx_virtual_fifo_base_offset = 0;
 		ucc_fast_free(uccf);
 		return -ENOMEM;
@@ -314,7 +314,7 @@ int ucc_fast_init(struct ucc_fast_info * uf_info, struct ucc_fast_private ** ucc
 		    ucc_set_qe_mux_rxtx(uf_info->ucc_num, uf_info->rx_clock,
 					COMM_DIR_RX)) {
 			printk(KERN_ERR "%s: illegal value for RX clock\n",
-			       __FUNCTION__);
+			       __func__);
 			ucc_fast_free(uccf);
 			return -EINVAL;
 		}
@@ -323,7 +323,7 @@ int ucc_fast_init(struct ucc_fast_info * uf_info, struct ucc_fast_private ** ucc
 		    ucc_set_qe_mux_rxtx(uf_info->ucc_num, uf_info->tx_clock,
 					COMM_DIR_TX)) {
 			printk(KERN_ERR "%s: illegal value for TX clock\n",
-			       __FUNCTION__);
+			       __func__);
 			ucc_fast_free(uccf);
 			return -EINVAL;
 		}
diff --git a/arch/powerpc/sysdev/qe_lib/ucc_slow.c b/arch/powerpc/sysdev/qe_lib/ucc_slow.c
index b2870b2..a578bc7 100644
--- a/arch/powerpc/sysdev/qe_lib/ucc_slow.c
+++ b/arch/powerpc/sysdev/qe_lib/ucc_slow.c
@@ -142,7 +142,7 @@ int ucc_slow_init(struct ucc_slow_info * us_info, struct ucc_slow_private ** ucc
 
 	/* check if the UCC port number is in range. */
 	if ((us_info->ucc_num < 0) || (us_info->ucc_num > UCC_MAX_NUM - 1)) {
-		printk(KERN_ERR "%s: illegal UCC number\n", __FUNCTION__);
+		printk(KERN_ERR "%s: illegal UCC number\n", __func__);
 		return -EINVAL;
 	}
 
@@ -161,7 +161,7 @@ int ucc_slow_init(struct ucc_slow_info * us_info, struct ucc_slow_private ** ucc
 	uccs = kzalloc(sizeof(struct ucc_slow_private), GFP_KERNEL);
 	if (!uccs) {
 		printk(KERN_ERR "%s: Cannot allocate private data\n",
-			__FUNCTION__);
+			__func__);
 		return -ENOMEM;
 	}
 
@@ -170,7 +170,7 @@ int ucc_slow_init(struct ucc_slow_info * us_info, struct ucc_slow_private ** ucc
 	/* Set the PHY base address */
 	uccs->us_regs = ioremap(us_info->regs, sizeof(struct ucc_slow));
 	if (uccs->us_regs == NULL) {
-		printk(KERN_ERR "%s: Cannot map UCC registers\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Cannot map UCC registers\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -189,7 +189,7 @@ int ucc_slow_init(struct ucc_slow_info * us_info, struct ucc_slow_private ** ucc
 	uccs->us_pram_offset =
 		qe_muram_alloc(UCC_SLOW_PRAM_SIZE, ALIGNMENT_OF_UCC_SLOW_PRAM);
 	if (IS_ERR_VALUE(uccs->us_pram_offset)) {
-		printk(KERN_ERR "%s: cannot allocate MURAM for PRAM", __FUNCTION__);
+		printk(KERN_ERR "%s: cannot allocate MURAM for PRAM", __func__);
 		ucc_slow_free(uccs);
 		return -ENOMEM;
 	}
@@ -202,7 +202,7 @@ int ucc_slow_init(struct ucc_slow_info * us_info, struct ucc_slow_private ** ucc
 	/* Set UCC to slow type */
 	ret = ucc_set_type(us_info->ucc_num, UCC_SPEED_TYPE_SLOW);
 	if (ret) {
-		printk(KERN_ERR "%s: cannot set UCC type", __FUNCTION__);
+		printk(KERN_ERR "%s: cannot set UCC type", __func__);
 		ucc_slow_free(uccs);
 		return ret;
 	}
@@ -216,7 +216,7 @@ int ucc_slow_init(struct ucc_slow_info * us_info, struct ucc_slow_private ** ucc
 		qe_muram_alloc(us_info->rx_bd_ring_len * sizeof(struct qe_bd),
 				QE_ALIGNMENT_OF_BD);
 	if (IS_ERR_VALUE(uccs->rx_base_offset)) {
-		printk(KERN_ERR "%s: cannot allocate %u RX BDs\n", __FUNCTION__,
+		printk(KERN_ERR "%s: cannot allocate %u RX BDs\n", __func__,
 			us_info->rx_bd_ring_len);
 		uccs->rx_base_offset = 0;
 		ucc_slow_free(uccs);
@@ -227,7 +227,7 @@ int ucc_slow_init(struct ucc_slow_info * us_info, struct ucc_slow_private ** ucc
 		qe_muram_alloc(us_info->tx_bd_ring_len * sizeof(struct qe_bd),
 			QE_ALIGNMENT_OF_BD);
 	if (IS_ERR_VALUE(uccs->tx_base_offset)) {
-		printk(KERN_ERR "%s: cannot allocate TX BDs", __FUNCTION__);
+		printk(KERN_ERR "%s: cannot allocate TX BDs", __func__);
 		uccs->tx_base_offset = 0;
 		ucc_slow_free(uccs);
 		return -ENOMEM;
@@ -317,7 +317,7 @@ int ucc_slow_init(struct ucc_slow_info * us_info, struct ucc_slow_private ** ucc
 		if (ucc_set_qe_mux_rxtx(us_info->ucc_num, us_info->rx_clock,
 					COMM_DIR_RX)) {
 			printk(KERN_ERR "%s: illegal value for RX clock\n",
-			       __FUNCTION__);
+			       __func__);
 			ucc_slow_free(uccs);
 			return -EINVAL;
 		}
@@ -325,7 +325,7 @@ int ucc_slow_init(struct ucc_slow_info * us_info, struct ucc_slow_private ** ucc
 		if (ucc_set_qe_mux_rxtx(us_info->ucc_num, us_info->tx_clock,
 					COMM_DIR_TX)) {
 			printk(KERN_ERR "%s: illegal value for TX clock\n",
-			       __FUNCTION__);
+			       __func__);
 			ucc_slow_free(uccs);
 			return -EINVAL;
 		}
diff --git a/arch/powerpc/sysdev/tsi108_dev.c b/arch/powerpc/sysdev/tsi108_dev.c
index be2808a..d4d15aa 100644
--- a/arch/powerpc/sysdev/tsi108_dev.c
+++ b/arch/powerpc/sysdev/tsi108_dev.c
@@ -84,7 +84,7 @@ static int __init tsi108_eth_of_init(void)
 
 		ret = of_address_to_resource(np, 0, &r[0]);
 		DBG("%s: name:start->end = %s:0x%lx-> 0x%lx\n",
-			__FUNCTION__,r[0].name, r[0].start, r[0].end);
+			__func__,r[0].name, r[0].start, r[0].end);
 		if (ret)
 			goto err;
 
@@ -93,7 +93,7 @@ static int __init tsi108_eth_of_init(void)
 		r[1].end = irq_of_parse_and_map(np, 0);
 		r[1].flags = IORESOURCE_IRQ;
 		DBG("%s: name:start->end = %s:0x%lx-> 0x%lx\n",
-			__FUNCTION__,r[1].name, r[1].start, r[1].end);
+			__func__,r[1].name, r[1].start, r[1].end);
 
 		tsi_eth_dev =
 		    platform_device_register_simple("tsi-ethernet", i++, &r[0],
diff --git a/arch/powerpc/sysdev/tsi108_pci.c b/arch/powerpc/sysdev/tsi108_pci.c
index 31d3d33..ac1a72d 100644
--- a/arch/powerpc/sysdev/tsi108_pci.c
+++ b/arch/powerpc/sysdev/tsi108_pci.c
@@ -207,7 +207,7 @@ int __init tsi108_setup_pci(struct device_node *dev, u32 cfg_phys, int primary)
 	/* PCI Config mapping */
 	tsi108_pci_cfg_base = (u32)ioremap(cfg_phys, TSI108_PCI_CFG_SIZE);
 	tsi108_pci_cfg_phys = cfg_phys;
-	DBG("TSI_PCI: %s tsi108_pci_cfg_base=0x%x\n", __FUNCTION__,
+	DBG("TSI_PCI: %s tsi108_pci_cfg_base=0x%x\n", __func__,
 	    tsi108_pci_cfg_base);
 
 	/* Fetch host bridge registers address */
@@ -395,7 +395,7 @@ static int pci_irq_host_xlate(struct irq_host *h, struct device_node *ct,
 static int pci_irq_host_map(struct irq_host *h, unsigned int virq,
 			  irq_hw_number_t hw)
 {	unsigned int irq;
-	DBG("%s(%d, 0x%lx)\n", __FUNCTION__, virq, hw);
+	DBG("%s(%d, 0x%lx)\n", __func__, virq, hw);
 	if ((virq >= 1) && (virq <= 4)){
 		irq = virq + IRQ_PCI_INTAD_BASE - 1;
 		get_irq_desc(irq)->status |= IRQ_LEVEL;
-- 
1.5.4.3.500.g83a2c



