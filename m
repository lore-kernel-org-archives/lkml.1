Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab0CJDnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 22:43:40 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:50455 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab0CJDng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 22:43:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wvQtRxg9SfEYWB4GiEMTkNuvWJrnzIV3LH1PEP2izQpYyuFP2cbZS8QGI3o+RbY3En
         pxNcv7i3NEdRgpnOzjL2bvGH7vzt7vCFn1en/8liOyWl46vas4w/J3e3eyy7tixggbw6
         0Zg5IP2pCTCOlPIlGgx2/nG2Gu3PjxF5EZ6Us=
From: Josiah Humphrey <dontdrinkh2so4@gmail.com>
To: airlied@linux.ie, bskeggs@redhat.com, currojerez@riseup.net,
       madman2003@gmail.com, koriakin@0x04.net
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Josiah Humphrey <dontdrinkh2so4@gmail.com>
Subject: [PATCH] Fixed style issues for various nouveau files. Fix some whitespace and brace issues for the various nouveau files. I found the errors using checkpatch.pl Signed-off-by: Josiah Humphrey <dontdrinkh2so4@gmail.com>
Date: Tue,  9 Mar 2010 19:42:58 -0800
Message-Id: <1268192578-28896-1-git-send-email-dontdrinkh2so4@gmail.com>
X-Mailer: git-send-email 1.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/gpu/drm/nouveau/nouveau_acpi.c  |    5 ++---
 drivers/gpu/drm/nouveau/nouveau_bios.c  |   28 +++++++++++++++++-----------
 drivers/gpu/drm/nouveau/nouveau_gem.c   |    2 +-
 drivers/gpu/drm/nouveau/nouveau_grctx.h |   10 +++++-----
 drivers/gpu/drm/nouveau/nouveau_hw.h    |    2 +-
 drivers/gpu/drm/nouveau/nouveau_reg.h   |   12 ++++++------
 6 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index 0e0730a..42b0d3a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -151,11 +151,10 @@ static bool nouveau_dsm_pci_probe(struct pci_dev *pdev)
 	if (!dhandle)
 		return false;
 	status = acpi_get_handle(dhandle, "_DSM", &nvidia_handle);
-	if (ACPI_FAILURE(status)) {
+	if (ACPI_FAILURE(status))
 		return false;
-	}
 
-	ret= nouveau_dsm(nvidia_handle, NOUVEAU_DSM_SUPPORTED,
+	ret = nouveau_dsm(nvidia_handle, NOUVEAU_DSM_SUPPORTED,
 			 NOUVEAU_DSM_SUPPORTED_FUNCTIONS, &result);
 	if (ret < 0)
 		return false;
diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nouveau/nouveau_bios.c
index 71247da..bed83f8 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bios.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
@@ -4447,7 +4447,8 @@ static int parse_bit_display_tbl_entry(struct drm_device *dev, struct nvbios *bi
 	return 0;
 }
 
-static int parse_bit_init_tbl_entry(struct drm_device *dev, struct nvbios *bios, struct bit_entry *bitentry)
+static int parse_bit_init_tbl_entry(struct drm_device *dev,
+		struct nvbios *bios, struct bit_entry *bitentry)
 {
 	/*
 	 * Parses the init table segment that the bit entry points to.
@@ -4470,7 +4471,8 @@ static int parse_bit_init_tbl_entry(struct drm_device *dev, struct nvbios *bios,
 	return 0;
 }
 
-static int parse_bit_i_tbl_entry(struct drm_device *dev, struct nvbios *bios, struct bit_entry *bitentry)
+static int parse_bit_i_tbl_entry(struct drm_device *dev,
+		struct nvbios *bios, struct bit_entry *bitentry)
 {
 	/*
 	 * BIT 'i' (info?) table
@@ -4533,7 +4535,8 @@ static int parse_bit_i_tbl_entry(struct drm_device *dev, struct nvbios *bios, st
 	return 0;
 }
 
-static int parse_bit_lvds_tbl_entry(struct drm_device *dev, struct nvbios *bios, struct bit_entry *bitentry)
+static int parse_bit_lvds_tbl_entry(struct drm_device *dev,
+		struct nvbios *bios, struct bit_entry *bitentry)
 {
 	/*
 	 * Parses the LVDS table segment that the bit entry points to.
@@ -4562,9 +4565,9 @@ parse_bit_M_tbl_entry(struct drm_device *dev, struct nvbios *bios,
 {
 	/*
 	 * offset + 2  (8  bits): number of options in an
-	 * 	INIT_RAM_RESTRICT_ZM_REG_GROUP opcode option set
+	 *	INIT_RAM_RESTRICT_ZM_REG_GROUP opcode option set
 	 * offset + 3  (16 bits): pointer to strap xlate table for RAM
-	 * 	restrict option selection
+	 *	restrict option selection
 	 *
 	 * There's a bunch of bits in this table other than the RAM restrict
 	 * stuff that we don't use - their use currently unknown
@@ -4588,7 +4591,8 @@ parse_bit_M_tbl_entry(struct drm_device *dev, struct nvbios *bios,
 	return 0;
 }
 
-static int parse_bit_tmds_tbl_entry(struct drm_device *dev, struct nvbios *bios, struct bit_entry *bitentry)
+static int parse_bit_tmds_tbl_entry(struct drm_device *dev,
+		struct nvbios *bios, struct bit_entry *bitentry)
 {
 	/*
 	 * Parses the pointer to the TMDS table
@@ -4747,7 +4751,8 @@ parse_bit_structure(struct nvbios *bios, const uint16_t bitoffset)
 	return 0;
 }
 
-static int parse_bmp_structure(struct drm_device *dev, struct nvbios *bios, unsigned int offset)
+static int parse_bmp_structure(struct drm_device *dev,
+		struct nvbios *bios, unsigned int offset)
 {
 	/*
 	 * Parses the BMP structure for useful things, but does not act on them
@@ -4963,7 +4968,8 @@ static uint16_t findstr(uint8_t *data, int n, const uint8_t *str, int len)
 }
 
 static int
-read_dcb_i2c_entry(struct drm_device *dev, int dcb_version, uint8_t *i2ctable, int index, struct dcb_i2c_entry *i2c)
+read_dcb_i2c_entry(struct drm_device *dev, int dcb_version,
+		uint8_t *i2ctable, int index, struct dcb_i2c_entry *i2c)
 {
 	uint8_t dcb_i2c_ver = dcb_version, headerlen = 0, entry_len = 4;
 	int i2c_entries = DCB_MAX_NUM_I2C_ENTRIES;
@@ -5203,9 +5209,8 @@ divine_connector_type(struct nvbios *bios, int index)
 	if (encoders & (1 << OUTPUT_LVDS)) {
 		type = DCB_CONNECTOR_LVDS;
 	} else
-	if (encoders & (1 << OUTPUT_TV)) {
+	if (encoders & (1 << OUTPUT_TV))
 		type = DCB_CONNECTOR_TV_0;
-	}
 
 	return type;
 }
@@ -5818,7 +5823,8 @@ fixup_legacy_i2c(struct nvbios *bios)
 	}
 }
 
-static int load_nv17_hwsq_ucode_entry(struct drm_device *dev, struct nvbios *bios, uint16_t hwsq_offset, int entry)
+static int load_nv17_hwsq_ucode_entry(struct drm_device *dev,
+		struct nvbios *bios, uint16_t hwsq_offset, int entry)
 {
 	/*
 	 * The header following the "HWSQ" signature has the number of entries,
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 0d22f66..c2a1b2c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -717,7 +717,7 @@ nouveau_gem_ioctl_pushbuf(struct drm_device *dev, void *data,
 
 out:
 	validate_fini(&op, fence);
-	nouveau_fence_unref((void**)&fence);
+	nouveau_fence_unref((void **)&fence);
 	mutex_unlock(&dev->struct_mutex);
 	kfree(bo);
 	kfree(push);
diff --git a/drivers/gpu/drm/nouveau/nouveau_grctx.h b/drivers/gpu/drm/nouveau/nouveau_grctx.h
index 5d39c4c..40aca2c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_grctx.h
+++ b/drivers/gpu/drm/nouveau/nouveau_grctx.h
@@ -87,10 +87,10 @@ _cp_bra(struct nouveau_grctx *ctx, u32 mod, int flag, int state, int name)
 	cp_out(ctx, CP_BRA | (mod << 18) | ip | flag |
 		    (state ? 0 : CP_BRA_IF_CLEAR));
 }
-#define cp_bra(c,f,s,n) _cp_bra((c), 0, CP_FLAG_##f, CP_FLAG_##f##_##s, n)
+#define cp_bra(c, f, s, n) _cp_bra((c), 0, CP_FLAG_##f, CP_FLAG_##f##_##s, n)
 #ifdef CP_BRA_MOD
-#define cp_cal(c,f,s,n) _cp_bra((c), 1, CP_FLAG_##f, CP_FLAG_##f##_##s, n)
-#define cp_ret(c,f,s) _cp_bra((c), 2, CP_FLAG_##f, CP_FLAG_##f##_##s, 0)
+#define cp_cal(c, f, s, n) _cp_bra((c), 1, CP_FLAG_##f, CP_FLAG_##f##_##s, n)
+#define cp_ret(c, f, s) _cp_bra((c), 2, CP_FLAG_##f, CP_FLAG_##f##_##s, 0)
 #endif
 
 static inline void
@@ -98,14 +98,14 @@ _cp_wait(struct nouveau_grctx *ctx, int flag, int state)
 {
 	cp_out(ctx, CP_WAIT | flag | (state ? CP_WAIT_SET : 0));
 }
-#define cp_wait(c,f,s) _cp_wait((c), CP_FLAG_##f, CP_FLAG_##f##_##s)
+#define cp_wait(c, f, s) _cp_wait((c), CP_FLAG_##f, CP_FLAG_##f##_##s)
 
 static inline void
 _cp_set(struct nouveau_grctx *ctx, int flag, int state)
 {
 	cp_out(ctx, CP_SET | flag | (state ? CP_SET_1 : 0));
 }
-#define cp_set(c,f,s) _cp_set((c), CP_FLAG_##f, CP_FLAG_##f##_##s)
+#define cp_set(c, f, s) _cp_set((c), CP_FLAG_##f, CP_FLAG_##f##_##s)
 
 static inline void
 cp_pos(struct nouveau_grctx *ctx, int offset)
diff --git a/drivers/gpu/drm/nouveau/nouveau_hw.h b/drivers/gpu/drm/nouveau/nouveau_hw.h
index 869130f..19d0ba9 100644
--- a/drivers/gpu/drm/nouveau/nouveau_hw.h
+++ b/drivers/gpu/drm/nouveau/nouveau_hw.h
@@ -211,7 +211,7 @@ static inline uint8_t NVReadVgaCrtc(struct drm_device *dev,
  * 0x03		bit0 set for dual link (LVDS, possibly elsewhere too)
  * 0x08 or 0x09	pxclk in MHz
  * 0x0f		laptop panel info -	low nibble for PEXTDEV_BOOT_0 strap
- * 					high nibble for xlat strap value
+ *					high nibble for xlat strap value
  */
 
 static inline void
diff --git a/drivers/gpu/drm/nouveau/nouveau_reg.h b/drivers/gpu/drm/nouveau/nouveau_reg.h
index aa9b310..9bfd23f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_reg.h
+++ b/drivers/gpu/drm/nouveau/nouveau_reg.h
@@ -617,9 +617,9 @@
 #    define NV50_PCONNECTOR_I2C_PORT_4                      0x0000e240
 #    define NV50_PCONNECTOR_I2C_PORT_5                      0x0000e258
 
-#define NV50_AUXCH_DATA_OUT(i,n)             ((n) * 4 + (i) * 0x50 + 0x0000e4c0)
+#define NV50_AUXCH_DATA_OUT(i, n)             ((n) * 4 + (i) * 0x50 + 0x0000e4c0)
 #define NV50_AUXCH_DATA_OUT__SIZE                                             4
-#define NV50_AUXCH_DATA_IN(i,n)              ((n) * 4 + (i) * 0x50 + 0x0000e4d0)
+#define NV50_AUXCH_DATA_IN(i, n)              ((n) * 4 + (i) * 0x50 + 0x0000e4d0)
 #define NV50_AUXCH_DATA_IN__SIZE                                              4
 #define NV50_AUXCH_ADDR(i)                             ((i) * 0x50 + 0x0000e4e0)
 #define NV50_AUXCH_CTRL(i)                             ((i) * 0x50 + 0x0000e4e4)
@@ -813,7 +813,7 @@
 #define NV50_PDISPLAY_SOR_BACKLIGHT                                  0x0061c084
 #define NV50_PDISPLAY_SOR_BACKLIGHT_ENABLE                           0x80000000
 #define NV50_PDISPLAY_SOR_BACKLIGHT_LEVEL                            0x00000fff
-#define NV50_SOR_DP_CTRL(i,l)            (0x0061c10c + (i) * 0x800 + (l) * 0x80)
+#define NV50_SOR_DP_CTRL(i, l)            (0x0061c10c + (i) * 0x800 + (l) * 0x80)
 #define NV50_SOR_DP_CTRL_ENHANCED_FRAME_ENABLED                      0x00004000
 #define NV50_SOR_DP_CTRL_LANE_MASK                                   0x001f0000
 #define NV50_SOR_DP_CTRL_LANE_0_ENABLED                              0x00010000
@@ -824,9 +824,9 @@
 #define NV50_SOR_DP_CTRL_TRAINING_PATTERN_DISABLED                   0x00000000
 #define NV50_SOR_DP_CTRL_TRAINING_PATTERN_1                          0x01000000
 #define NV50_SOR_DP_CTRL_TRAINING_PATTERN_2                          0x02000000
-#define NV50_SOR_DP_UNK118(i,l)          (0x0061c118 + (i) * 0x800 + (l) * 0x80)
-#define NV50_SOR_DP_UNK120(i,l)          (0x0061c120 + (i) * 0x800 + (l) * 0x80)
-#define NV50_SOR_DP_UNK130(i,l)          (0x0061c130 + (i) * 0x800 + (l) * 0x80)
+#define NV50_SOR_DP_UNK118(i, l)          (0x0061c118 + (i) * 0x800 + (l) * 0x80)
+#define NV50_SOR_DP_UNK120(i, l)          (0x0061c120 + (i) * 0x800 + (l) * 0x80)
+#define NV50_SOR_DP_UNK130(i, l)          (0x0061c130 + (i) * 0x800 + (l) * 0x80)
 
 #define NV50_PDISPLAY_USER(i)                        ((i) * 0x1000 + 0x00640000)
 #define NV50_PDISPLAY_USER_PUT(i)                    ((i) * 0x1000 + 0x00640000)
-- 
1.6.4

