Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbYCDDMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbYCDDMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758850AbYCDDKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:10:11 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:20759 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbYCDDJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:09:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=L/auElQst82W7Gy2inu6bZZ+xTi0IEv1NYqad5V3Sitd21c/zXVRO+EE1x6rxy+TFBqQ1cXHgFgaqEFm6ihy2AQ1BwDyhknju2G9ebu9dIEwGuIosfTU8w8U37GXrX2nt7zDhejtshUsX3RN4ucLfg4oMLtUTvYP32U9j+j/NXs=
Subject: [PATCH 05/14] pci: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 19:09:46 -0800
Message-Id: <1204600186.22933.85.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/pci/hotplug/acpi_pcihp.c        |   24 +++---
 drivers/pci/hotplug/acpiphp_core.c      |   18 ++--
 drivers/pci/hotplug/acpiphp_glue.c      |   38 ++++----
 drivers/pci/hotplug/acpiphp_ibm.c       |   36 ++++----
 drivers/pci/hotplug/cpci_hotplug_core.c |   60 +++++++-------
 drivers/pci/hotplug/cpci_hotplug_pci.c  |   10 +-
 drivers/pci/hotplug/cpqphp.h            |    6 +-
 drivers/pci/hotplug/cpqphp_core.c       |   38 ++++----
 drivers/pci/hotplug/cpqphp_ctrl.c       |   64 +++++++-------
 drivers/pci/hotplug/cpqphp_nvram.c      |    2 +-
 drivers/pci/hotplug/cpqphp_pci.c        |    8 +-
 drivers/pci/hotplug/fakephp.c           |    2 +-
 drivers/pci/hotplug/ibmphp_core.c       |   24 +++---
 drivers/pci/hotplug/ibmphp_ebda.c       |   92 ++++++++++----------
 drivers/pci/hotplug/ibmphp_hpc.c        |   68 +++++++-------
 drivers/pci/hotplug/ibmphp_pci.c        |   18 ++--
 drivers/pci/hotplug/ibmphp_res.c        |   12 ++--
 drivers/pci/hotplug/pci_hotplug_core.c  |    2 +-
 drivers/pci/hotplug/pciehp.h            |    2 +-
 drivers/pci/hotplug/pciehp_core.c       |   32 ++++----
 drivers/pci/hotplug/pciehp_ctrl.c       |   34 ++++----
 drivers/pci/hotplug/pciehp_hpc.c        |  144 +++++++++++++++---------------
 drivers/pci/hotplug/pciehp_pci.c        |    8 +-
 drivers/pci/hotplug/pcihp_skeleton.c    |   18 ++--
 drivers/pci/hotplug/rpadlpar_core.c     |   20 ++--
 drivers/pci/hotplug/rpaphp_core.c       |    6 +-
 drivers/pci/hotplug/rpaphp_pci.c        |   14 ++--
 drivers/pci/hotplug/rpaphp_slot.c       |    6 +-
 drivers/pci/hotplug/sgi_hotplug.c       |    8 +-
 drivers/pci/hotplug/shpchp.h            |    6 +-
 drivers/pci/hotplug/shpchp_core.c       |   26 +++---
 drivers/pci/hotplug/shpchp_ctrl.c       |   46 +++++-----
 drivers/pci/hotplug/shpchp_hpc.c        |   64 +++++++-------
 drivers/pci/hotplug/shpchp_pci.c        |    4 +-
 drivers/pci/pci.c                       |    2 +-
 drivers/pci/pcie/aer/aerdrv.c           |    4 +-
 drivers/pci/pcie/aer/aerdrv_core.c      |    2 +-
 drivers/pci/pcie/portdrv_core.c         |    4 +-
 drivers/pci/pcie/portdrv_pci.c          |    2 +-
 39 files changed, 487 insertions(+), 487 deletions(-)

diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
index 270a33c..f8c187a 100644
--- a/drivers/pci/hotplug/acpi_pcihp.c
+++ b/drivers/pci/hotplug/acpi_pcihp.c
@@ -36,7 +36,7 @@
 
 #define MY_NAME	"acpi_pcihp"
 
-#define dbg(fmt, arg...) do { if (debug_acpi) printk(KERN_DEBUG "%s: %s: " fmt , MY_NAME , __FUNCTION__ , ## arg); } while (0)
+#define dbg(fmt, arg...) do { if (debug_acpi) printk(KERN_DEBUG "%s: %s: " fmt , MY_NAME , __func__ , ## arg); } while (0)
 #define err(format, arg...) printk(KERN_ERR "%s: " format , MY_NAME , ## arg)
 #define info(format, arg...) printk(KERN_INFO "%s: " format , MY_NAME , ## arg)
 #define warn(format, arg...) printk(KERN_WARNING "%s: " format , MY_NAME , ## arg)
@@ -71,7 +71,7 @@ decode_type0_hpx_record(union acpi_object *record, struct hotplug_params *hpx)
 	default:
 		printk(KERN_WARNING
 		       "%s: Type 0 Revision %d record not supported\n",
-		       __FUNCTION__, revision);
+		       __func__, revision);
 		return AE_ERROR;
 	}
 	return AE_OK;
@@ -100,7 +100,7 @@ decode_type1_hpx_record(union acpi_object *record, struct hotplug_params *hpx)
 	default:
 		printk(KERN_WARNING
 		       "%s: Type 1 Revision %d record not supported\n",
-		       __FUNCTION__, revision);
+		       __func__, revision);
 		return AE_ERROR;
 	}
 	return AE_OK;
@@ -142,7 +142,7 @@ decode_type2_hpx_record(union acpi_object *record, struct hotplug_params *hpx)
 	default:
 		printk(KERN_WARNING
 		       "%s: Type 2 Revision %d record not supported\n",
-		       __FUNCTION__, revision);
+		       __func__, revision);
 		return AE_ERROR;
 	}
 	return AE_OK;
@@ -203,7 +203,7 @@ acpi_run_hpx(acpi_handle handle, struct hotplug_params *hpx)
 			break;
 		default:
 			printk(KERN_ERR "%s: Type %d record not supported\n",
-			       __FUNCTION__, type);
+			       __func__, type);
 			status = AE_ERROR;
 			goto exit;
 		}
@@ -235,7 +235,7 @@ acpi_run_hpp(acpi_handle handle, struct hotplug_params *hpp)
 		ret_buf.pointer = kmalloc (ret_buf.length, GFP_KERNEL);
 		if (!ret_buf.pointer) {
 			printk(KERN_ERR "%s:%s alloc for _HPP fail\n",
-				__FUNCTION__, (char *)string.pointer);
+				__func__, (char *)string.pointer);
 			kfree(string.pointer);
 			return AE_NO_MEMORY;
 		}
@@ -245,7 +245,7 @@ acpi_run_hpp(acpi_handle handle, struct hotplug_params *hpp)
 			break;
 	default:
 		if (ACPI_FAILURE(status)) {
-			pr_debug("%s:%s _HPP fail=0x%x\n", __FUNCTION__,
+			pr_debug("%s:%s _HPP fail=0x%x\n", __func__,
 				(char *)string.pointer, status);
 			kfree(string.pointer);
 			return status;
@@ -254,7 +254,7 @@ acpi_run_hpp(acpi_handle handle, struct hotplug_params *hpp)
 
 	ext_obj = (union acpi_object *) ret_buf.pointer;
 	if (ext_obj->type != ACPI_TYPE_PACKAGE) {
-		printk(KERN_ERR "%s:%s _HPP obj not a package\n", __FUNCTION__,
+		printk(KERN_ERR "%s:%s _HPP obj not a package\n", __func__,
 				(char *)string.pointer);
 		status = AE_ERROR;
 		goto free_and_return;
@@ -270,7 +270,7 @@ acpi_run_hpp(acpi_handle handle, struct hotplug_params *hpp)
 			break;
 		default:
 			printk(KERN_ERR "%s:%s _HPP obj type incorrect\n",
-				__FUNCTION__, (char *)string.pointer);
+				__func__, (char *)string.pointer);
 			status = AE_ERROR;
 			goto free_and_return;
 		}
@@ -311,12 +311,12 @@ acpi_status acpi_run_oshp(acpi_handle handle)
 	if (ACPI_FAILURE(status))
 		if (status != AE_NOT_FOUND)
 			printk(KERN_ERR "%s:%s OSHP fails=0x%x\n",
-			       __FUNCTION__, (char *)string.pointer, status);
+			       __func__, (char *)string.pointer, status);
 		else
 			dbg("%s:%s OSHP not found\n",
-			    __FUNCTION__, (char *)string.pointer);
+			    __func__, (char *)string.pointer);
 	else
-		pr_debug("%s:%s OSHP passes\n", __FUNCTION__,
+		pr_debug("%s:%s OSHP passes\n", __func__,
 			(char *)string.pointer);
 
 	kfree(string.pointer);
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index 9279d5b..7af68ba 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -138,7 +138,7 @@ static int enable_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	/* enable the specified slot */
 	return acpiphp_enable_slot(slot->acpi_slot);
@@ -156,7 +156,7 @@ static int disable_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	/* disable the specified slot */
 	retval = acpiphp_disable_slot(slot->acpi_slot);
@@ -179,7 +179,7 @@ static int disable_slot(struct hotplug_slot *hotplug_slot)
  {
 	int retval = -ENODEV;
 
- 	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+ 	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
  
 	if (attention_info && try_module_get(attention_info->owner)) {
 		retval = attention_info->set_attn(hotplug_slot, status);
@@ -202,7 +202,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	*value = acpiphp_get_power_status(slot->acpi_slot);
 
@@ -224,7 +224,7 @@ static int get_attention_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	int retval = -EINVAL;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	if (attention_info && try_module_get(attention_info->owner)) {
 		retval = attention_info->get_attn(hotplug_slot, value);
@@ -247,7 +247,7 @@ static int get_latch_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	*value = acpiphp_get_latch_status(slot->acpi_slot);
 
@@ -267,7 +267,7 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	*value = acpiphp_get_adapter_status(slot->acpi_slot);
 
@@ -284,7 +284,7 @@ static int get_address(struct hotplug_slot *hotplug_slot, u32 *value)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	*value = acpiphp_get_address(slot->acpi_slot);
 
@@ -318,7 +318,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	kfree(slot->hotplug_slot);
 	kfree(slot);
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index cf22f9e..fa801c1 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -352,7 +352,7 @@ static void decode_hpp(struct acpiphp_bridge *bridge)
 		/* use default numbers */
 		printk(KERN_WARNING
 		       "%s: Could not get hotplug parameters. Use defaults\n",
-		       __FUNCTION__);
+		       __func__);
 		bridge->hpp.t0 = &bridge->hpp.type0_data;
 		bridge->hpp.t0->revision = 0;
 		bridge->hpp.t0->cache_line_size = 0x10;
@@ -534,7 +534,7 @@ find_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
 
 	status = acpi_evaluate_integer(handle, "_ADR", NULL, &tmp);
 	if (ACPI_FAILURE(status)) {
-		dbg("%s: _ADR evaluation failure\n", __FUNCTION__);
+		dbg("%s: _ADR evaluation failure\n", __func__);
 		return AE_OK;
 	}
 
@@ -578,7 +578,7 @@ static int add_bridge(acpi_handle handle)
 	if (ACPI_SUCCESS(status)) {
 		status = acpi_evaluate_integer(handle, "_STA", NULL, &tmp);
 		if (ACPI_FAILURE(status)) {
-			dbg("%s: _STA evaluation failure\n", __FUNCTION__);
+			dbg("%s: _STA evaluation failure\n", __func__);
 			return 0;
 		}
 		if ((tmp & ACPI_STA_FUNCTIONING) == 0)
@@ -928,10 +928,10 @@ static int power_on_slot(struct acpiphp_slot *slot)
 		func = list_entry(l, struct acpiphp_func, sibling);
 
 		if (func->flags & FUNC_HAS_PS0) {
-			dbg("%s: executing _PS0\n", __FUNCTION__);
+			dbg("%s: executing _PS0\n", __func__);
 			status = acpi_evaluate_object(func->handle, "_PS0", NULL, NULL);
 			if (ACPI_FAILURE(status)) {
-				warn("%s: _PS0 failed\n", __FUNCTION__);
+				warn("%s: _PS0 failed\n", __func__);
 				retval = -1;
 				goto err_exit;
 			} else
@@ -966,7 +966,7 @@ static int power_off_slot(struct acpiphp_slot *slot)
 		if (func->flags & FUNC_HAS_PS3) {
 			status = acpi_evaluate_object(func->handle, "_PS3", NULL, NULL);
 			if (ACPI_FAILURE(status)) {
-				warn("%s: _PS3 failed\n", __FUNCTION__);
+				warn("%s: _PS3 failed\n", __func__);
 				retval = -1;
 				goto err_exit;
 			} else
@@ -1300,7 +1300,7 @@ int acpiphp_eject_slot(struct acpiphp_slot *slot)
 
 			status = acpi_evaluate_object(func->handle, "_EJ0", &arg_list, NULL);
 			if (ACPI_FAILURE(status)) {
-				warn("%s: _EJ0 failed\n", __FUNCTION__);
+				warn("%s: _EJ0 failed\n", __func__);
 				return -1;
 			} else
 				break;
@@ -1349,7 +1349,7 @@ static int acpiphp_check_bridge(struct acpiphp_bridge *bridge)
 		}
 	}
 
-	dbg("%s: %d enabled, %d disabled\n", __FUNCTION__, enabled, disabled);
+	dbg("%s: %d enabled, %d disabled\n", __func__, enabled, disabled);
 
  err_exit:
 	return retval;
@@ -1527,7 +1527,7 @@ check_sub_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 	if (bridge) {
 		acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 		dbg("%s: re-enumerating slots under %s\n",
-			__FUNCTION__, objname);
+			__func__, objname);
 		acpiphp_check_bridge(bridge);
 	}
 	return AE_OK ;
@@ -1572,10 +1572,10 @@ static void handle_hotplug_event_bridge(acpi_handle handle, u32 type, void *cont
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
 		/* bus re-enumerate */
-		dbg("%s: Bus check notify on %s\n", __FUNCTION__, objname);
+		dbg("%s: Bus check notify on %s\n", __func__, objname);
 		if (bridge) {
 			dbg("%s: re-enumerating slots under %s\n",
-				__FUNCTION__, objname);
+				__func__, objname);
 			acpiphp_check_bridge(bridge);
 		}
 		if (num_sub_bridges)
@@ -1585,18 +1585,18 @@ static void handle_hotplug_event_bridge(acpi_handle handle, u32 type, void *cont
 
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		/* device check */
-		dbg("%s: Device check notify on %s\n", __FUNCTION__, objname);
+		dbg("%s: Device check notify on %s\n", __func__, objname);
 		acpiphp_check_bridge(bridge);
 		break;
 
 	case ACPI_NOTIFY_DEVICE_WAKE:
 		/* wake event */
-		dbg("%s: Device wake notify on %s\n", __FUNCTION__, objname);
+		dbg("%s: Device wake notify on %s\n", __func__, objname);
 		break;
 
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		/* request device eject */
-		dbg("%s: Device eject notify on %s\n", __FUNCTION__, objname);
+		dbg("%s: Device eject notify on %s\n", __func__, objname);
 		if ((bridge->type != BRIDGE_TYPE_HOST) &&
 		    (bridge->flags & BRIDGE_HAS_EJ0)) {
 			struct acpiphp_slot *slot;
@@ -1649,24 +1649,24 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *contex
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
 		/* bus re-enumerate */
-		dbg("%s: Bus check notify on %s\n", __FUNCTION__, objname);
+		dbg("%s: Bus check notify on %s\n", __func__, objname);
 		acpiphp_enable_slot(func->slot);
 		break;
 
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		/* device check : re-enumerate from parent bus */
-		dbg("%s: Device check notify on %s\n", __FUNCTION__, objname);
+		dbg("%s: Device check notify on %s\n", __func__, objname);
 		acpiphp_check_bridge(func->slot->bridge);
 		break;
 
 	case ACPI_NOTIFY_DEVICE_WAKE:
 		/* wake event */
-		dbg("%s: Device wake notify on %s\n", __FUNCTION__, objname);
+		dbg("%s: Device wake notify on %s\n", __func__, objname);
 		break;
 
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		/* request device eject */
-		dbg("%s: Device eject notify on %s\n", __FUNCTION__, objname);
+		dbg("%s: Device eject notify on %s\n", __func__, objname);
 		if (!(acpiphp_disable_slot(func->slot)))
 			acpiphp_eject_slot(func->slot);
 		break;
@@ -1796,7 +1796,7 @@ int acpiphp_enable_slot(struct acpiphp_slot *slot)
 		if (retval)
 			power_off_slot(slot);
 	} else {
-		dbg("%s: Slot status is not ACPI_STA_ALL\n", __FUNCTION__);
+		dbg("%s: Slot status is not ACPI_STA_ALL\n", __func__);
 		power_off_slot(slot);
 	}
 
diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
index b0a22b9..ede9051 100644
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -186,7 +186,7 @@ static int ibm_set_attention_status(struct hotplug_slot *slot, u8 status)
 
 	ibm_slot = ibm_slot_from_id(hpslot_to_sun(slot));
 
-	dbg("%s: set slot %d (%d) attention status to %d\n", __FUNCTION__,
+	dbg("%s: set slot %d (%d) attention status to %d\n", __func__,
 			ibm_slot->slot.slot_num, ibm_slot->slot.slot_id,
 			(status ? 1 : 0));
 
@@ -231,7 +231,7 @@ static int ibm_get_attention_status(struct hotplug_slot *slot, u8 *status)
 	else
 		*status = 0;
 
-	dbg("%s: get slot %d (%d) attention status is %d\n", __FUNCTION__,
+	dbg("%s: get slot %d (%d) attention status is %d\n", __func__,
 			ibm_slot->slot.slot_num, ibm_slot->slot.slot_id,
 			*status);
 
@@ -263,10 +263,10 @@ static void ibm_handle_events(acpi_handle handle, u32 event, void *context)
 	u8 subevent = event & 0xf0;
 	struct notification *note = context;
 
-	dbg("%s: Received notification %02x\n", __FUNCTION__, event);
+	dbg("%s: Received notification %02x\n", __func__, event);
 
 	if (subevent == 0x80) {
-		dbg("%s: generationg bus event\n", __FUNCTION__);
+		dbg("%s: generationg bus event\n", __func__);
 		acpi_bus_generate_proc_event(note->device, note->event, detail);
 		acpi_bus_generate_netlink_event(note->device->pnp.device_class,
 						  note->device->dev.bus_id,
@@ -299,7 +299,7 @@ static int ibm_get_table_from_acpi(char **bufp)
 
 	status = acpi_evaluate_object(ibm_acpi_handle, "APCI", NULL, &buffer);
 	if (ACPI_FAILURE(status)) {
-		err("%s:  APCI evaluation failed\n", __FUNCTION__);
+		err("%s:  APCI evaluation failed\n", __func__);
 		return -ENODEV;
 	}
 
@@ -307,13 +307,13 @@ static int ibm_get_table_from_acpi(char **bufp)
 	if (!(package) ||
 			(package->type != ACPI_TYPE_PACKAGE) ||
 			!(package->package.elements)) {
-		err("%s:  Invalid APCI object\n", __FUNCTION__);
+		err("%s:  Invalid APCI object\n", __func__);
 		goto read_table_done;
 	}
 
 	for(size = 0, i = 0; i < package->package.count; i++) {
 		if (package->package.elements[i].type != ACPI_TYPE_BUFFER) {
-			err("%s:  Invalid APCI element %d\n", __FUNCTION__, i);
+			err("%s:  Invalid APCI element %d\n", __func__, i);
 			goto read_table_done;
 		}
 		size += package->package.elements[i].buffer.length;
@@ -324,7 +324,7 @@ static int ibm_get_table_from_acpi(char **bufp)
 
 	lbuf = kzalloc(size, GFP_KERNEL);
 	dbg("%s: element count: %i, ASL table size: %i, &table = 0x%p\n",
-			__FUNCTION__, package->package.count, size, lbuf);
+			__func__, package->package.count, size, lbuf);
 
 	if (lbuf) {
 		*bufp = lbuf;
@@ -368,7 +368,7 @@ static ssize_t ibm_read_apci_table(struct kobject *kobj,
 	int bytes_read = -EINVAL;
 	char *table = NULL;
 	
-	dbg("%s: pos = %d, size = %zd\n", __FUNCTION__, (int)pos, size);
+	dbg("%s: pos = %d, size = %zd\n", __func__, (int)pos, size);
 
 	if (pos == 0) {
 		bytes_read = ibm_get_table_from_acpi(&table);
@@ -402,7 +402,7 @@ static acpi_status __init ibm_find_acpi_device(acpi_handle handle,
 	status = acpi_get_object_info(handle, &info_buffer);
 	if (ACPI_FAILURE(status)) {
 		err("%s:  Failed to get device information status=0x%x\n",
-			__FUNCTION__, status);
+			__func__, status);
 		return retval;
 	}
 	info = info_buffer.pointer;
@@ -432,18 +432,18 @@ static int __init ibm_acpiphp_init(void)
 	struct acpi_device *device;
 	struct kobject *sysdir = &pci_hotplug_slots_kset->kobj;
 
-	dbg("%s\n", __FUNCTION__);
+	dbg("%s\n", __func__);
 
 	if (acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
 			ACPI_UINT32_MAX, ibm_find_acpi_device,
 			&ibm_acpi_handle, NULL) != FOUND_APCI) {
-		err("%s: acpi_walk_namespace failed\n", __FUNCTION__);
+		err("%s: acpi_walk_namespace failed\n", __func__);
 		retval = -ENODEV;
 		goto init_return;
 	}
-	dbg("%s: found IBM aPCI device\n", __FUNCTION__);
+	dbg("%s: found IBM aPCI device\n", __func__);
 	if (acpi_bus_get_device(ibm_acpi_handle, &device)) {
-		err("%s: acpi_bus_get_device failed\n", __FUNCTION__);
+		err("%s: acpi_bus_get_device failed\n", __func__);
 		retval = -ENODEV;
 		goto init_return;
 	}
@@ -458,7 +458,7 @@ static int __init ibm_acpiphp_init(void)
 			&ibm_note);
 	if (ACPI_FAILURE(status)) {
 		err("%s: Failed to register notification handler\n",
-				__FUNCTION__);
+				__func__);
 		retval = -EBUSY;
 		goto init_cleanup;
 	}
@@ -479,17 +479,17 @@ static void __exit ibm_acpiphp_exit(void)
 	acpi_status status;
 	struct kobject *sysdir = &pci_hotplug_slots_kset->kobj;
 
-	dbg("%s\n", __FUNCTION__);
+	dbg("%s\n", __func__);
 
 	if (acpiphp_unregister_attention(&ibm_attention_info))
-		err("%s: attention info deregistration failed", __FUNCTION__);
+		err("%s: attention info deregistration failed", __func__);
 
 	status = acpi_remove_notify_handler(
 			   ibm_acpi_handle,
 			   ACPI_DEVICE_NOTIFY,
 			   ibm_handle_events);
 	if (ACPI_FAILURE(status))
-		err("%s: Notification handler removal failed\n", __FUNCTION__);
+		err("%s: Notification handler removal failed\n", __func__);
 	/* remove the /sys entries */
 	sysfs_remove_bin_file(sysdir, &ibm_apci_table_attr);
 }
diff --git a/drivers/pci/hotplug/cpci_hotplug_core.c b/drivers/pci/hotplug/cpci_hotplug_core.c
index ed4d44e..d8a6b80 100644
--- a/drivers/pci/hotplug/cpci_hotplug_core.c
+++ b/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -108,7 +108,7 @@ enable_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s", __func__, hotplug_slot->name);
 
 	if (controller->ops->set_power)
 		retval = controller->ops->set_power(slot, 1);
@@ -121,25 +121,25 @@ disable_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s", __func__, hotplug_slot->name);
 
 	down_write(&list_rwsem);
 
 	/* Unconfigure device */
 	dbg("%s - unconfiguring slot %s",
-	    __FUNCTION__, slot->hotplug_slot->name);
+	    __func__, slot->hotplug_slot->name);
 	if ((retval = cpci_unconfigure_slot(slot))) {
 		err("%s - could not unconfigure slot %s",
-		    __FUNCTION__, slot->hotplug_slot->name);
+		    __func__, slot->hotplug_slot->name);
 		goto disable_error;
 	}
 	dbg("%s - finished unconfiguring slot %s",
-	    __FUNCTION__, slot->hotplug_slot->name);
+	    __func__, slot->hotplug_slot->name);
 
 	/* Clear EXT (by setting it) */
 	if (cpci_clear_ext(slot)) {
 		err("%s - could not clear EXT for slot %s",
-		    __FUNCTION__, slot->hotplug_slot->name);
+		    __func__, slot->hotplug_slot->name);
 		retval = -ENODEV;
 		goto disable_error;
 	}
@@ -372,7 +372,7 @@ init_slots(int clear_ins)
 	struct slot *slot;
 	struct pci_dev* dev;
 
-	dbg("%s - enter", __FUNCTION__);
+	dbg("%s - enter", __func__);
 	down_read(&list_rwsem);
 	if (!slots) {
 		up_read(&list_rwsem);
@@ -380,10 +380,10 @@ init_slots(int clear_ins)
 	}
 	list_for_each_entry(slot, &slot_list, slot_list) {
 		dbg("%s - looking at slot %s",
-		    __FUNCTION__, slot->hotplug_slot->name);
+		    __func__, slot->hotplug_slot->name);
 		if (clear_ins && cpci_check_and_clear_ins(slot))
 			dbg("%s - cleared INS for slot %s",
-			    __FUNCTION__, slot->hotplug_slot->name);
+			    __func__, slot->hotplug_slot->name);
 		dev = pci_get_slot(slot->bus, PCI_DEVFN(slot->number, 0));
 		if (dev) {
 			if (update_adapter_status(slot->hotplug_slot, 1))
@@ -394,7 +394,7 @@ init_slots(int clear_ins)
 		}
 	}
 	up_read(&list_rwsem);
-	dbg("%s - exit", __FUNCTION__);
+	dbg("%s - exit", __func__);
 	return 0;
 }
 
@@ -415,7 +415,7 @@ check_slots(void)
 	extracted = inserted = 0;
 	list_for_each_entry(slot, &slot_list, slot_list) {
 		dbg("%s - looking at slot %s",
-		    __FUNCTION__, slot->hotplug_slot->name);
+		    __func__, slot->hotplug_slot->name);
 		if (cpci_check_and_clear_ins(slot)) {
 			/*
 			 * Some broken hardware (e.g. PLX 9054AB) asserts
@@ -430,28 +430,28 @@ check_slots(void)
 
 			/* Process insertion */
 			dbg("%s - slot %s inserted",
-			    __FUNCTION__, slot->hotplug_slot->name);
+			    __func__, slot->hotplug_slot->name);
 
 			/* GSM, debug */
 			hs_csr = cpci_get_hs_csr(slot);
 			dbg("%s - slot %s HS_CSR (1) = %04x",
-			    __FUNCTION__, slot->hotplug_slot->name, hs_csr);
+			    __func__, slot->hotplug_slot->name, hs_csr);
 
 			/* Configure device */
 			dbg("%s - configuring slot %s",
-			    __FUNCTION__, slot->hotplug_slot->name);
+			    __func__, slot->hotplug_slot->name);
 			if (cpci_configure_slot(slot)) {
 				err("%s - could not configure slot %s",
-				    __FUNCTION__, slot->hotplug_slot->name);
+				    __func__, slot->hotplug_slot->name);
 				continue;
 			}
 			dbg("%s - finished configuring slot %s",
-			    __FUNCTION__, slot->hotplug_slot->name);
+			    __func__, slot->hotplug_slot->name);
 
 			/* GSM, debug */
 			hs_csr = cpci_get_hs_csr(slot);
 			dbg("%s - slot %s HS_CSR (2) = %04x",
-			    __FUNCTION__, slot->hotplug_slot->name, hs_csr);
+			    __func__, slot->hotplug_slot->name, hs_csr);
 
 			if (update_latch_status(slot->hotplug_slot, 1))
 				warn("failure to update latch file");
@@ -464,18 +464,18 @@ check_slots(void)
 			/* GSM, debug */
 			hs_csr = cpci_get_hs_csr(slot);
 			dbg("%s - slot %s HS_CSR (3) = %04x",
-			    __FUNCTION__, slot->hotplug_slot->name, hs_csr);
+			    __func__, slot->hotplug_slot->name, hs_csr);
 
 			inserted++;
 		} else if (cpci_check_ext(slot)) {
 			/* Process extraction request */
 			dbg("%s - slot %s extracted",
-			    __FUNCTION__, slot->hotplug_slot->name);
+			    __func__, slot->hotplug_slot->name);
 
 			/* GSM, debug */
 			hs_csr = cpci_get_hs_csr(slot);
 			dbg("%s - slot %s HS_CSR = %04x",
-			    __FUNCTION__, slot->hotplug_slot->name, hs_csr);
+			    __func__, slot->hotplug_slot->name, hs_csr);
 
 			if (!slot->extracting) {
 				if (update_latch_status(slot->hotplug_slot, 0)) {
@@ -519,7 +519,7 @@ event_thread(void *data)
 {
 	int rc;
 
-	dbg("%s - event thread started", __FUNCTION__);
+	dbg("%s - event thread started", __func__);
 	while (1) {
 		dbg("event thread sleeping");
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -532,7 +532,7 @@ event_thread(void *data)
 				/* Give userspace a chance to handle extraction */
 				msleep(500);
 			} else if (rc < 0) {
-				dbg("%s - error checking slots", __FUNCTION__);
+				dbg("%s - error checking slots", __func__);
 				thread_finished = 1;
 				goto out;
 			}
@@ -541,7 +541,7 @@ event_thread(void *data)
 			break;
 
 		/* Re-enable ENUM# interrupt */
-		dbg("%s - re-enabling irq", __FUNCTION__);
+		dbg("%s - re-enabling irq", __func__);
 		controller->ops->enable_irq();
 	}
  out:
@@ -564,7 +564,7 @@ poll_thread(void *data)
 					/* Give userspace a chance to handle extraction */
 					msleep(500);
 				} else if (rc < 0) {
-					dbg("%s - error checking slots", __FUNCTION__);
+					dbg("%s - error checking slots", __func__);
 					thread_finished = 1;
 					goto out;
 				}
@@ -621,7 +621,7 @@ cpci_hp_register_controller(struct cpci_hp_controller *new_controller)
 			status = -ENODEV;
 		}
 		dbg("%s - acquired controller irq %d",
-		    __FUNCTION__, new_controller->irq);
+		    __func__, new_controller->irq);
 	}
 	if (!status)
 		controller = new_controller;
@@ -673,7 +673,7 @@ cpci_hp_start(void)
 	static int first = 1;
 	int status;
 
-	dbg("%s - enter", __FUNCTION__);
+	dbg("%s - enter", __func__);
 	if (!controller)
 		return -ENODEV;
 
@@ -693,14 +693,14 @@ cpci_hp_start(void)
 	status = cpci_start_thread();
 	if (status)
 		return status;
-	dbg("%s - thread started", __FUNCTION__);
+	dbg("%s - thread started", __func__);
 
 	if (controller->irq) {
 		/* Start enum interrupt processing */
-		dbg("%s - enabling irq", __FUNCTION__);
+		dbg("%s - enabling irq", __func__);
 		controller->ops->enable_irq();
 	}
-	dbg("%s - exit", __FUNCTION__);
+	dbg("%s - exit", __func__);
 	return 0;
 }
 
@@ -711,7 +711,7 @@ cpci_hp_stop(void)
 		return -ENODEV;
 	if (controller->irq) {
 		/* Stop enum interrupt processing */
-		dbg("%s - disabling irq", __FUNCTION__);
+		dbg("%s - disabling irq", __func__);
 		controller->ops->disable_irq();
 	}
 	cpci_stop_thread();
diff --git a/drivers/pci/hotplug/cpci_hotplug_pci.c b/drivers/pci/hotplug/cpci_hotplug_pci.c
index 5e9be44..ea72f03 100644
--- a/drivers/pci/hotplug/cpci_hotplug_pci.c
+++ b/drivers/pci/hotplug/cpci_hotplug_pci.c
@@ -255,7 +255,7 @@ int cpci_configure_slot(struct slot* slot)
 	struct pci_bus *parent;
 	int fn;
 
-	dbg("%s - enter", __FUNCTION__);
+	dbg("%s - enter", __func__);
 
 	if (slot->dev == NULL) {
 		dbg("pci_dev null, finding %02x:%02x:%x",
@@ -273,7 +273,7 @@ int cpci_configure_slot(struct slot* slot)
 		 * we will only call this case when lookup fails.
 		 */
 		n = pci_scan_slot(slot->bus, slot->devfn);
-		dbg("%s: pci_scan_slot returned %d", __FUNCTION__, n);
+		dbg("%s: pci_scan_slot returned %d", __func__, n);
 		slot->dev = pci_get_slot(slot->bus, slot->devfn);
 		if (slot->dev == NULL) {
 			err("Could not find PCI device for slot %02x", slot->number);
@@ -322,7 +322,7 @@ int cpci_configure_slot(struct slot* slot)
 	pci_bus_add_devices(parent);
 	pci_enable_bridges(parent);
 
-	dbg("%s - exit", __FUNCTION__);
+	dbg("%s - exit", __func__);
 	return 0;
 }
 
@@ -331,7 +331,7 @@ int cpci_unconfigure_slot(struct slot* slot)
 	int i;
 	struct pci_dev *dev;
 
-	dbg("%s - enter", __FUNCTION__);
+	dbg("%s - enter", __func__);
 	if (!slot->dev) {
 		err("No device for slot %02x\n", slot->number);
 		return -ENODEV;
@@ -348,6 +348,6 @@ int cpci_unconfigure_slot(struct slot* slot)
 	pci_dev_put(slot->dev);
 	slot->dev = NULL;
 
-	dbg("%s - exit", __FUNCTION__);
+	dbg("%s - exit", __func__);
 	return 0;
 }
diff --git a/drivers/pci/hotplug/cpqphp.h b/drivers/pci/hotplug/cpqphp.h
index 298ad7f..b1decfa 100644
--- a/drivers/pci/hotplug/cpqphp.h
+++ b/drivers/pci/hotplug/cpqphp.h
@@ -674,7 +674,7 @@ static inline int cpq_get_latch_status(struct controller *ctrl, struct slot *slo
 
 	hp_slot = slot->device - ctrl->slot_device_offset;
 	dbg("%s: slot->device = %d, ctrl->slot_device_offset = %d \n",
-	    __FUNCTION__, slot->device, ctrl->slot_device_offset);
+	    __func__, slot->device, ctrl->slot_device_offset);
 
 	status = (readl(ctrl->hpc_reg + INT_INPUT_CLEAR) & (0x01L << hp_slot));
 
@@ -709,7 +709,7 @@ static inline int wait_for_ctrl_irq(struct controller *ctrl)
         DECLARE_WAITQUEUE(wait, current);
 	int retval = 0;
 
-	dbg("%s - start\n", __FUNCTION__);
+	dbg("%s - start\n", __func__);
 	add_wait_queue(&ctrl->queue, &wait);
 	/* Sleep for up to 1 second to wait for the LED to change. */
 	msleep_interruptible(1000);
@@ -717,7 +717,7 @@ static inline int wait_for_ctrl_irq(struct controller *ctrl)
 	if (signal_pending(current))
 		retval =  -EINTR;
 
-	dbg("%s - end\n", __FUNCTION__);
+	dbg("%s - end\n", __func__);
 	return retval;
 }
 
diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index 7417887..36b115b 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -315,7 +315,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	kfree(slot->hotplug_slot->info);
 	kfree(slot->hotplug_slot->name);
@@ -338,7 +338,7 @@ static int ctrl_slot_setup(struct controller *ctrl,
 	void __iomem *slot_entry= NULL;
 	int result = -ENOMEM;
 
-	dbg("%s\n", __FUNCTION__);
+	dbg("%s\n", __func__);
 
 	tempdword = readl(ctrl->hpc_reg + INT_INPUT_CLEAR);
 
@@ -513,7 +513,7 @@ get_slot_mapping(struct pci_bus *bus, u8 bus_num, u8 dev_num, u8 *slot)
 
 	u8 tbus, tdevice, tslot, bridgeSlot;
 
-	dbg("%s: %p, %d, %d, %p\n", __FUNCTION__, bus, bus_num, dev_num, slot);
+	dbg("%s: %p, %d, %d, %p\n", __func__, bus, bus_num, dev_num, slot);
 
 	bridgeSlot = 0xFF;
 
@@ -636,7 +636,7 @@ static int set_attention_status (struct hotplug_slot *hotplug_slot, u8 status)
 	u8 device;
 	u8 function;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	if (cpqhp_get_bus_dev(ctrl, &bus, &devfn, slot->number) == -1)
 		return -ENODEV;
@@ -663,7 +663,7 @@ static int process_SI(struct hotplug_slot *hotplug_slot)
 	u8 device;
 	u8 function;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	if (cpqhp_get_bus_dev(ctrl, &bus, &devfn, slot->number) == -1)
 		return -ENODEV;
@@ -695,7 +695,7 @@ static int process_SS(struct hotplug_slot *hotplug_slot)
 	u8 device;
 	u8 function;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	if (cpqhp_get_bus_dev(ctrl, &bus, &devfn, slot->number) == -1)
 		return -ENODEV;
@@ -708,7 +708,7 @@ static int process_SS(struct hotplug_slot *hotplug_slot)
 	if (!slot_func)
 		return -ENODEV;
 
-	dbg("In %s, slot_func = %p, ctrl = %p\n", __FUNCTION__, slot_func, ctrl);
+	dbg("In %s, slot_func = %p, ctrl = %p\n", __func__, slot_func, ctrl);
 	return cpqhp_process_SS(ctrl, slot_func);
 }
 
@@ -718,7 +718,7 @@ static int hardware_test(struct hotplug_slot *hotplug_slot, u32 value)
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	return cpqhp_hardware_test(ctrl, value);	
 }
@@ -729,7 +729,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	*value = get_slot_enabled(ctrl, slot);
 	return 0;
@@ -740,7 +740,7 @@ static int get_attention_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 	
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	*value = cpq_get_attention_status(ctrl, slot);
 	return 0;
@@ -751,7 +751,7 @@ static int get_latch_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	*value = cpq_get_latch_status(ctrl, slot);
 
@@ -763,7 +763,7 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	*value = get_presence_status(ctrl, slot);
 
@@ -775,7 +775,7 @@ static int get_max_bus_speed (struct hotplug_slot *hotplug_slot, enum pci_bus_sp
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	*value = ctrl->speed_capability;
 
@@ -787,7 +787,7 @@ static int get_cur_bus_speed (struct hotplug_slot *hotplug_slot, enum pci_bus_sp
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	*value = ctrl->speed;
 
@@ -841,7 +841,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		// TODO: This code can be made to support non-Compaq or Intel subsystem IDs
 		rc = pci_read_config_word(pdev, PCI_SUBSYSTEM_VENDOR_ID, &subsystem_vid);
 		if (rc) {
-			err("%s : pci_read_config_word failed\n", __FUNCTION__);
+			err("%s : pci_read_config_word failed\n", __func__);
 			goto err_disable_device;
 		}
 		dbg("Subsystem Vendor ID: %x\n", subsystem_vid);
@@ -853,14 +853,14 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		ctrl = kzalloc(sizeof(struct controller), GFP_KERNEL);
 		if (!ctrl) {
-			err("%s : out of memory\n", __FUNCTION__);
+			err("%s : out of memory\n", __func__);
 			rc = -ENOMEM;
 			goto err_disable_device;
 		}
 
 		rc = pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &subsystem_deviceid);
 		if (rc) {
-			err("%s : pci_read_config_word failed\n", __FUNCTION__);
+			err("%s : pci_read_config_word failed\n", __func__);
 			goto err_free_ctrl;
 		}
 
@@ -1142,7 +1142,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	rc = cpqhp_save_config(ctrl, ctrl->bus, readb(ctrl->hpc_reg + SLOT_MASK));
 	if (rc) {
 		err("%s: unable to save PCI configuration data, error %d\n",
-				__FUNCTION__, rc);
+				__func__, rc);
 		goto err_iounmap;
 	}
 
@@ -1180,7 +1180,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc) {
 		err(msg_initialization_err, 6);
 		err("%s: unable to save PCI configuration data, error %d\n",
-			__FUNCTION__, rc);
+			__func__, rc);
 		goto err_iounmap;
 	}
 	
diff --git a/drivers/pci/hotplug/cpqphp_ctrl.c b/drivers/pci/hotplug/cpqphp_ctrl.c
index 4018420..ef041ca 100644
--- a/drivers/pci/hotplug/cpqphp_ctrl.c
+++ b/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -737,12 +737,12 @@ static struct pci_resource *get_resource(struct pci_resource **head, u32 size)
 
 	for (node = *head; node; node = node->next) {
 		dbg("%s: req_size =%x node=%p, base=%x, length=%x\n",
-		    __FUNCTION__, size, node, node->base, node->length);
+		    __func__, size, node, node->base, node->length);
 		if (node->length < size)
 			continue;
 
 		if (node->base & (size - 1)) {
-			dbg("%s: not aligned\n", __FUNCTION__);
+			dbg("%s: not aligned\n", __func__);
 			/* this one isn't base aligned properly
 			 * so we'll make a new entry and split it up */
 			temp_dword = (node->base | (size-1)) + 1;
@@ -767,7 +767,7 @@ static struct pci_resource *get_resource(struct pci_resource **head, u32 size)
 
 		/* Don't need to check if too small since we already did */
 		if (node->length > size) {
-			dbg("%s: too big\n", __FUNCTION__);
+			dbg("%s: too big\n", __func__);
 			/* this one is longer than we need
 			 * so we'll make a new entry and split it up */
 			split_node = kmalloc(sizeof(*split_node), GFP_KERNEL);
@@ -784,7 +784,7 @@ static struct pci_resource *get_resource(struct pci_resource **head, u32 size)
 			node->next = split_node;
 		}  /* End of too big on top end */
 
-		dbg("%s: got one!!!\n", __FUNCTION__);
+		dbg("%s: got one!!!\n", __func__);
 		/* If we got here, then it is the right size
 		 * Now take it out of the list */
 		if (*head == node) {
@@ -819,7 +819,7 @@ int cpqhp_resource_sort_and_combine(struct pci_resource **head)
 	struct pci_resource *node2;
 	int out_of_order = 1;
 
-	dbg("%s: head = %p, *head = %p\n", __FUNCTION__, head, *head);
+	dbg("%s: head = %p, *head = %p\n", __func__, head, *head);
 
 	if (!(*head))
 		return 1;
@@ -907,7 +907,7 @@ irqreturn_t cpqhp_ctrl_intr(int IRQ, void *data)
 		/* Read to clear posted writes */
 		misc = readw(ctrl->hpc_reg + MISC);
 
-		dbg ("%s - waking up\n", __FUNCTION__);
+		dbg ("%s - waking up\n", __func__);
 		wake_up_interruptible(&ctrl->queue);
 	}
 
@@ -1421,7 +1421,7 @@ static u32 board_added(struct pci_func *func, struct controller *ctrl)
 
 	hp_slot = func->device - ctrl->slot_device_offset;
 	dbg("%s: func->device, slot_offset, hp_slot = %d, %d ,%d\n",
-	    __FUNCTION__, func->device, ctrl->slot_device_offset, hp_slot);
+	    __func__, func->device, ctrl->slot_device_offset, hp_slot);
 
 	mutex_lock(&ctrl->crit_sect);
 
@@ -1466,55 +1466,55 @@ static u32 board_added(struct pci_func *func, struct controller *ctrl)
 
 	/* turn on board and blink green LED */
 
-	dbg("%s: before down\n", __FUNCTION__);
+	dbg("%s: before down\n", __func__);
 	mutex_lock(&ctrl->crit_sect);
-	dbg("%s: after down\n", __FUNCTION__);
+	dbg("%s: after down\n", __func__);
 
-	dbg("%s: before slot_enable\n", __FUNCTION__);
+	dbg("%s: before slot_enable\n", __func__);
 	slot_enable (ctrl, hp_slot);
 
-	dbg("%s: before green_LED_blink\n", __FUNCTION__);
+	dbg("%s: before green_LED_blink\n", __func__);
 	green_LED_blink (ctrl, hp_slot);
 
-	dbg("%s: before amber_LED_blink\n", __FUNCTION__);
+	dbg("%s: before amber_LED_blink\n", __func__);
 	amber_LED_off (ctrl, hp_slot);
 
-	dbg("%s: before set_SOGO\n", __FUNCTION__);
+	dbg("%s: before set_SOGO\n", __func__);
 	set_SOGO(ctrl);
 
 	/* Wait for SOBS to be unset */
-	dbg("%s: before wait_for_ctrl_irq\n", __FUNCTION__);
+	dbg("%s: before wait_for_ctrl_irq\n", __func__);
 	wait_for_ctrl_irq (ctrl);
-	dbg("%s: after wait_for_ctrl_irq\n", __FUNCTION__);
+	dbg("%s: after wait_for_ctrl_irq\n", __func__);
 
-	dbg("%s: before up\n", __FUNCTION__);
+	dbg("%s: before up\n", __func__);
 	mutex_unlock(&ctrl->crit_sect);
-	dbg("%s: after up\n", __FUNCTION__);
+	dbg("%s: after up\n", __func__);
 
 	/* Wait for ~1 second because of hot plug spec */
-	dbg("%s: before long_delay\n", __FUNCTION__);
+	dbg("%s: before long_delay\n", __func__);
 	long_delay(1*HZ);
-	dbg("%s: after long_delay\n", __FUNCTION__);
+	dbg("%s: after long_delay\n", __func__);
 
-	dbg("%s: func status = %x\n", __FUNCTION__, func->status);
+	dbg("%s: func status = %x\n", __func__, func->status);
 	/* Check for a power fault */
 	if (func->status == 0xFF) {
 		/* power fault occurred, but it was benign */
 		temp_register = 0xFFFFFFFF;
-		dbg("%s: temp register set to %x by power fault\n", __FUNCTION__, temp_register);
+		dbg("%s: temp register set to %x by power fault\n", __func__, temp_register);
 		rc = POWER_FAILURE;
 		func->status = 0;
 	} else {
 		/* Get vendor/device ID u32 */
 		ctrl->pci_bus->number = func->bus;
 		rc = pci_bus_read_config_dword (ctrl->pci_bus, PCI_DEVFN(func->device, func->function), PCI_VENDOR_ID, &temp_register);
-		dbg("%s: pci_read_config_dword returns %d\n", __FUNCTION__, rc);
-		dbg("%s: temp_register is %x\n", __FUNCTION__, temp_register);
+		dbg("%s: pci_read_config_dword returns %d\n", __func__, rc);
+		dbg("%s: temp_register is %x\n", __func__, temp_register);
 
 		if (rc != 0) {
 			/* Something's wrong here */
 			temp_register = 0xFFFFFFFF;
-			dbg("%s: temp register set to %x by error\n", __FUNCTION__, temp_register);
+			dbg("%s: temp register set to %x by error\n", __func__, temp_register);
 		}
 		/* Preset return code.  It will be changed later if things go okay. */
 		rc = NO_ADAPTER_PRESENT;
@@ -1530,7 +1530,7 @@ static u32 board_added(struct pci_func *func, struct controller *ctrl)
 
 		rc = configure_new_device(ctrl, func, 0, &res_lists);
 
-		dbg("%s: back from configure_new_device\n", __FUNCTION__);
+		dbg("%s: back from configure_new_device\n", __func__);
 		ctrl->io_head = res_lists.io_head;
 		ctrl->mem_head = res_lists.mem_head;
 		ctrl->p_mem_head = res_lists.p_mem_head;
@@ -1566,7 +1566,7 @@ static u32 board_added(struct pci_func *func, struct controller *ctrl)
 
 		/* next, we will instantiate the linux pci_dev structures (with
 		 * appropriate driver notification, if already present) */
-		dbg("%s: configure linux pci_dev structure\n", __FUNCTION__);
+		dbg("%s: configure linux pci_dev structure\n", __func__);
 		index = 0;
 		do {
 			new_slot = cpqhp_slot_find(ctrl->bus, func->device, index++);
@@ -1628,7 +1628,7 @@ static u32 remove_board(struct pci_func * func, u32 replace_flag, struct control
 	device = func->device;
 
 	hp_slot = func->device - ctrl->slot_device_offset;
-	dbg("In %s, hp_slot = %d\n", __FUNCTION__, hp_slot);
+	dbg("In %s, hp_slot = %d\n", __func__, hp_slot);
 
 	/* When we get here, it is safe to change base address registers.
 	 * We will attempt to save the base address register lengths */
@@ -1928,7 +1928,7 @@ void cpqhp_pushbutton_thread(unsigned long slot)
 		func = cpqhp_slot_find(p_slot->bus, p_slot->device, 0);
 		dbg("In power_down_board, func = %p, ctrl = %p\n", func, ctrl);
 		if (!func) {
-			dbg("Error! func NULL in %s\n", __FUNCTION__);
+			dbg("Error! func NULL in %s\n", __func__);
 			return ;
 		}
 
@@ -1950,7 +1950,7 @@ void cpqhp_pushbutton_thread(unsigned long slot)
 		func = cpqhp_slot_find(p_slot->bus, p_slot->device, 0);
 		dbg("In add_board, func = %p, ctrl = %p\n", func, ctrl);
 		if (!func) {
-			dbg("Error! func NULL in %s\n", __FUNCTION__);
+			dbg("Error! func NULL in %s\n", __func__);
 			return ;
 		}
 
@@ -2058,7 +2058,7 @@ int cpqhp_process_SI(struct controller *ctrl, struct pci_func *func)
 	}
 
 	if (rc) {
-		dbg("%s: rc = %d\n", __FUNCTION__, rc);
+		dbg("%s: rc = %d\n", __func__, rc);
 	}
 
 	if (p_slot)
@@ -2269,12 +2269,12 @@ static u32 configure_new_device(struct controller * ctrl, struct pci_func * func
 
 	new_slot = func;
 
-	dbg("%s\n", __FUNCTION__);
+	dbg("%s\n", __func__);
 	/* Check for Multi-function device */
 	ctrl->pci_bus->number = func->bus;
 	rc = pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(func->device, func->function), 0x0E, &temp_byte);
 	if (rc) {
-		dbg("%s: rc = %d\n", __FUNCTION__, rc);
+		dbg("%s: rc = %d\n", __func__, rc);
 		return rc;
 	}
 
diff --git a/drivers/pci/hotplug/cpqphp_nvram.c b/drivers/pci/hotplug/cpqphp_nvram.c
index ae5e974..cb17488 100644
--- a/drivers/pci/hotplug/cpqphp_nvram.c
+++ b/drivers/pci/hotplug/cpqphp_nvram.c
@@ -160,7 +160,7 @@ static int check_for_compaq_ROM (void __iomem *rom_start)
 	    (temp6 == 'Q')) {
 		result = 1;
 	}
-	dbg ("%s - returned %d\n", __FUNCTION__, result);
+	dbg ("%s - returned %d\n", __func__, result);
 	return result;
 }
 
diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index 3f6cd20..0902193 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -120,7 +120,7 @@ int cpqhp_unconfigure_device(struct pci_func* func)
 {
 	int j;
 	
-	dbg("%s: bus/dev/func = %x/%x/%x\n", __FUNCTION__, func->bus, func->device, func->function);
+	dbg("%s: bus/dev/func = %x/%x/%x\n", __func__, func->bus, func->device, func->function);
 
 	for (j=0; j<8 ; j++) {
 		struct pci_dev* temp = pci_find_slot(func->bus, PCI_DEVFN(func->device, j));
@@ -170,11 +170,11 @@ int cpqhp_set_irq (u8 bus_num, u8 dev_num, u8 int_pin, u8 irq_num)
 		fakedev->bus = fakebus;
 		fakebus->number = bus_num;
 		dbg("%s: dev %d, bus %d, pin %d, num %d\n",
-		    __FUNCTION__, dev_num, bus_num, int_pin, irq_num);
+		    __func__, dev_num, bus_num, int_pin, irq_num);
 		rc = pcibios_set_irq_routing(fakedev, int_pin - 0x0a, irq_num);
 		kfree(fakedev);
 		kfree(fakebus);
-		dbg("%s: rc %d\n", __FUNCTION__, rc);
+		dbg("%s: rc %d\n", __func__, rc);
 		if (!rc)
 			return !rc;
 
@@ -1423,7 +1423,7 @@ int cpqhp_return_board_resources(struct pci_func * func, struct resource_lists *
 	int rc = 0;
 	struct pci_resource *node;
 	struct pci_resource *t_node;
-	dbg("%s\n", __FUNCTION__);
+	dbg("%s\n", __func__);
 
 	if (!func)
 		return 1;
diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index 94b6401..984d21b 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -320,7 +320,7 @@ static int disable_slot(struct hotplug_slot *slot)
 		return -ENODEV;
 	dslot = slot->private;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot->name);
 
 	/* don't disable bridged devices just yet, we can't handle them easily... */
 	if (dslot->dev->subordinate) {
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index 87b6b8b..cc5dce2 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -395,7 +395,7 @@ static int get_max_bus_speed(struct hotplug_slot *hotplug_slot, enum pci_bus_spe
 	struct slot *pslot;
 	u8 mode = 0;
 
-	debug("%s - Entry hotplug_slot[%p] pvalue[%p]\n", __FUNCTION__,
+	debug("%s - Entry hotplug_slot[%p] pvalue[%p]\n", __func__,
 		hotplug_slot, value);
 
 	ibmphp_lock_operations();
@@ -425,7 +425,7 @@ static int get_max_bus_speed(struct hotplug_slot *hotplug_slot, enum pci_bus_spe
 	}
 
 	ibmphp_unlock_operations();
-	debug("%s - Exit rc[%d] value[%x]\n", __FUNCTION__, rc, *value);
+	debug("%s - Exit rc[%d] value[%x]\n", __func__, rc, *value);
 	return rc;
 }
 
@@ -435,7 +435,7 @@ static int get_cur_bus_speed(struct hotplug_slot *hotplug_slot, enum pci_bus_spe
 	struct slot *pslot;
 	u8 mode = 0;
 
-	debug("%s - Entry hotplug_slot[%p] pvalue[%p]\n", __FUNCTION__,
+	debug("%s - Entry hotplug_slot[%p] pvalue[%p]\n", __func__,
 		hotplug_slot, value);
 
 	ibmphp_lock_operations();
@@ -471,7 +471,7 @@ static int get_cur_bus_speed(struct hotplug_slot *hotplug_slot, enum pci_bus_spe
 	}
 
 	ibmphp_unlock_operations();
-	debug("%s - Exit rc[%d] value[%x]\n", __FUNCTION__, rc, *value);
+	debug("%s - Exit rc[%d] value[%x]\n", __func__, rc, *value);
 	return rc;
 }
 
@@ -741,13 +741,13 @@ static void free_slots(void)
 	struct list_head * tmp;
 	struct list_head * next;
 
-	debug("%s -- enter\n", __FUNCTION__);
+	debug("%s -- enter\n", __func__);
 
 	list_for_each_safe(tmp, next, &ibmphp_slot_head) {
 		slot_cur = list_entry(tmp, struct slot, ibm_slot_list);
 		pci_hp_deregister(slot_cur->hotplug_slot);
 	}
-	debug("%s -- exit\n", __FUNCTION__);
+	debug("%s -- exit\n", __func__);
 }
 
 static void ibm_unconfigure_device(struct pci_func *func)
@@ -755,7 +755,7 @@ static void ibm_unconfigure_device(struct pci_func *func)
 	struct pci_dev *temp;
 	u8 j;
 
-	debug("inside %s\n", __FUNCTION__);
+	debug("inside %s\n", __func__);
 	debug("func->device = %x, func->function = %x\n",
 					func->device, func->function);
 	debug("func->device << 3 | 0x0  = %x\n", func->device << 3 | 0x0);
@@ -786,13 +786,13 @@ static u8 bus_structure_fixup(u8 busno)
 
 	bus = kmalloc(sizeof(*bus), GFP_KERNEL);
 	if (!bus) {
-		err("%s - out of memory\n", __FUNCTION__);
+		err("%s - out of memory\n", __func__);
 		return 1;
 	}
 	dev = kmalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
 		kfree(bus);
-		err("%s - out of memory\n", __FUNCTION__);
+		err("%s - out of memory\n", __func__);
 		return 1;
 	}
 
@@ -803,7 +803,7 @@ static u8 bus_structure_fixup(u8 busno)
 		if (!pci_read_config_word(dev, PCI_VENDOR_ID, &l) &&
 					(l != 0x0000) && (l != 0xffff)) {
 			debug("%s - Inside bus_struture_fixup()\n",
-							__FUNCTION__);
+							__func__);
 			pci_scan_bus(busno, ibmphp_pci_bus->ops, NULL);
 			break;
 		}
@@ -900,7 +900,7 @@ static int set_bus(struct slot * slot_cur)
 	        { },
 	};	
 
-	debug("%s - entry slot # %d\n", __FUNCTION__, slot_cur->number);
+	debug("%s - entry slot # %d\n", __func__, slot_cur->number);
 	if (SET_BUS_STATUS(slot_cur->ctrl) && is_bus_empty(slot_cur)) {
 		rc = slot_update(&slot_cur);
 		if (rc)
@@ -975,7 +975,7 @@ static int set_bus(struct slot * slot_cur)
 	/* This is for x440, once Brandon fixes the firmware, 
 	will not need this delay */
 	msleep(1000);
-	debug("%s -Exit\n", __FUNCTION__);
+	debug("%s -Exit\n", __func__);
 	return 0;
 }
 
diff --git a/drivers/pci/hotplug/ibmphp_ebda.c b/drivers/pci/hotplug/ibmphp_ebda.c
index 600ed7b..c4eec77 100644
--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -127,18 +127,18 @@ static void __init print_bus_info (void)
 	
 	list_for_each (ptr1, &bus_info_head) {
 		ptr = list_entry (ptr1, struct bus_info, bus_info_list);
-		debug ("%s - slot_min = %x\n", __FUNCTION__, ptr->slot_min);
-		debug ("%s - slot_max = %x\n", __FUNCTION__, ptr->slot_max);
-		debug ("%s - slot_count = %x\n", __FUNCTION__, ptr->slot_count);
-		debug ("%s - bus# = %x\n", __FUNCTION__, ptr->busno);
-		debug ("%s - current_speed = %x\n", __FUNCTION__, ptr->current_speed);
-		debug ("%s - controller_id = %x\n", __FUNCTION__, ptr->controller_id);
+		debug ("%s - slot_min = %x\n", __func__, ptr->slot_min);
+		debug ("%s - slot_max = %x\n", __func__, ptr->slot_max);
+		debug ("%s - slot_count = %x\n", __func__, ptr->slot_count);
+		debug ("%s - bus# = %x\n", __func__, ptr->busno);
+		debug ("%s - current_speed = %x\n", __func__, ptr->current_speed);
+		debug ("%s - controller_id = %x\n", __func__, ptr->controller_id);
 		
-		debug ("%s - slots_at_33_conv = %x\n", __FUNCTION__, ptr->slots_at_33_conv);
-		debug ("%s - slots_at_66_conv = %x\n", __FUNCTION__, ptr->slots_at_66_conv);
-		debug ("%s - slots_at_66_pcix = %x\n", __FUNCTION__, ptr->slots_at_66_pcix);
-		debug ("%s - slots_at_100_pcix = %x\n", __FUNCTION__, ptr->slots_at_100_pcix);
-		debug ("%s - slots_at_133_pcix = %x\n", __FUNCTION__, ptr->slots_at_133_pcix);
+		debug ("%s - slots_at_33_conv = %x\n", __func__, ptr->slots_at_33_conv);
+		debug ("%s - slots_at_66_conv = %x\n", __func__, ptr->slots_at_66_conv);
+		debug ("%s - slots_at_66_pcix = %x\n", __func__, ptr->slots_at_66_pcix);
+		debug ("%s - slots_at_100_pcix = %x\n", __func__, ptr->slots_at_100_pcix);
+		debug ("%s - slots_at_133_pcix = %x\n", __func__, ptr->slots_at_133_pcix);
 
 	}
 }
@@ -150,12 +150,12 @@ static void print_lo_info (void)
 	debug ("print_lo_info ----\n");	
 	list_for_each (ptr1, &rio_lo_head) {
 		ptr = list_entry (ptr1, struct rio_detail, rio_detail_list);
-		debug ("%s - rio_node_id = %x\n", __FUNCTION__, ptr->rio_node_id);
-		debug ("%s - rio_type = %x\n", __FUNCTION__, ptr->rio_type);
-		debug ("%s - owner_id = %x\n", __FUNCTION__, ptr->owner_id);
-		debug ("%s - first_slot_num = %x\n", __FUNCTION__, ptr->first_slot_num);
-		debug ("%s - wpindex = %x\n", __FUNCTION__, ptr->wpindex);
-		debug ("%s - chassis_num = %x\n", __FUNCTION__, ptr->chassis_num);
+		debug ("%s - rio_node_id = %x\n", __func__, ptr->rio_node_id);
+		debug ("%s - rio_type = %x\n", __func__, ptr->rio_type);
+		debug ("%s - owner_id = %x\n", __func__, ptr->owner_id);
+		debug ("%s - first_slot_num = %x\n", __func__, ptr->first_slot_num);
+		debug ("%s - wpindex = %x\n", __func__, ptr->wpindex);
+		debug ("%s - chassis_num = %x\n", __func__, ptr->chassis_num);
 
 	}
 }
@@ -164,15 +164,15 @@ static void print_vg_info (void)
 {
 	struct rio_detail *ptr;
 	struct list_head *ptr1;
-	debug ("%s ---\n", __FUNCTION__);
+	debug ("%s ---\n", __func__);
 	list_for_each (ptr1, &rio_vg_head) {
 		ptr = list_entry (ptr1, struct rio_detail, rio_detail_list);
-		debug ("%s - rio_node_id = %x\n", __FUNCTION__, ptr->rio_node_id);
-		debug ("%s - rio_type = %x\n", __FUNCTION__, ptr->rio_type);
-		debug ("%s - owner_id = %x\n", __FUNCTION__, ptr->owner_id);
-		debug ("%s - first_slot_num = %x\n", __FUNCTION__, ptr->first_slot_num);
-		debug ("%s - wpindex = %x\n", __FUNCTION__, ptr->wpindex);
-		debug ("%s - chassis_num = %x\n", __FUNCTION__, ptr->chassis_num);
+		debug ("%s - rio_node_id = %x\n", __func__, ptr->rio_node_id);
+		debug ("%s - rio_type = %x\n", __func__, ptr->rio_type);
+		debug ("%s - owner_id = %x\n", __func__, ptr->owner_id);
+		debug ("%s - first_slot_num = %x\n", __func__, ptr->first_slot_num);
+		debug ("%s - wpindex = %x\n", __func__, ptr->wpindex);
+		debug ("%s - chassis_num = %x\n", __func__, ptr->chassis_num);
 
 	}
 }
@@ -185,7 +185,7 @@ static void __init print_ebda_pci_rsrc (void)
 	list_for_each (ptr1, &ibmphp_ebda_pci_rsrc_head) {
 		ptr = list_entry (ptr1, struct ebda_pci_rsrc, ebda_pci_rsrc_list);
 		debug ("%s - rsrc type: %x bus#: %x dev_func: %x start addr: %x end addr: %x\n", 
-			__FUNCTION__, ptr->rsrc_type ,ptr->bus_num, ptr->dev_fun,ptr->start_addr, ptr->end_addr);
+			__func__, ptr->rsrc_type ,ptr->bus_num, ptr->dev_fun,ptr->start_addr, ptr->end_addr);
 	}
 }
 
@@ -196,7 +196,7 @@ static void __init print_ibm_slot (void)
 
 	list_for_each (ptr1, &ibmphp_slot_head) {
 		ptr = list_entry (ptr1, struct slot, ibm_slot_list);
-		debug ("%s - slot_number: %x\n", __FUNCTION__, ptr->number); 
+		debug ("%s - slot_number: %x\n", __func__, ptr->number); 
 	}
 }
 
@@ -204,13 +204,13 @@ static void __init print_opt_vg (void)
 {
 	struct opt_rio *ptr;
 	struct list_head *ptr1;
-	debug ("%s ---\n", __FUNCTION__);
+	debug ("%s ---\n", __func__);
 	list_for_each (ptr1, &opt_vg_head) {
 		ptr = list_entry (ptr1, struct opt_rio, opt_rio_list);
-		debug ("%s - rio_type %x\n", __FUNCTION__, ptr->rio_type); 
-		debug ("%s - chassis_num: %x\n", __FUNCTION__, ptr->chassis_num); 
-		debug ("%s - first_slot_num: %x\n", __FUNCTION__, ptr->first_slot_num); 
-		debug ("%s - middle_num: %x\n", __FUNCTION__, ptr->middle_num); 
+		debug ("%s - rio_type %x\n", __func__, ptr->rio_type); 
+		debug ("%s - chassis_num: %x\n", __func__, ptr->chassis_num); 
+		debug ("%s - first_slot_num: %x\n", __func__, ptr->first_slot_num); 
+		debug ("%s - middle_num: %x\n", __func__, ptr->middle_num); 
 	}
 }
 
@@ -225,35 +225,35 @@ static void __init print_ebda_hpc (void)
 		hpc_ptr = list_entry (ptr1, struct controller, ebda_hpc_list); 
 
 		for (index = 0; index < hpc_ptr->slot_count; index++) {
-			debug ("%s - physical slot#: %x\n", __FUNCTION__, hpc_ptr->slots[index].slot_num);
-			debug ("%s - pci bus# of the slot: %x\n", __FUNCTION__, hpc_ptr->slots[index].slot_bus_num);
-			debug ("%s - index into ctlr addr: %x\n", __FUNCTION__, hpc_ptr->slots[index].ctl_index);
-			debug ("%s - cap of the slot: %x\n", __FUNCTION__, hpc_ptr->slots[index].slot_cap);
+			debug ("%s - physical slot#: %x\n", __func__, hpc_ptr->slots[index].slot_num);
+			debug ("%s - pci bus# of the slot: %x\n", __func__, hpc_ptr->slots[index].slot_bus_num);
+			debug ("%s - index into ctlr addr: %x\n", __func__, hpc_ptr->slots[index].ctl_index);
+			debug ("%s - cap of the slot: %x\n", __func__, hpc_ptr->slots[index].slot_cap);
 		}
 
 		for (index = 0; index < hpc_ptr->bus_count; index++) {
-			debug ("%s - bus# of each bus controlled by this ctlr: %x\n", __FUNCTION__, hpc_ptr->buses[index].bus_num);
+			debug ("%s - bus# of each bus controlled by this ctlr: %x\n", __func__, hpc_ptr->buses[index].bus_num);
 		}
 
-		debug ("%s - type of hpc: %x\n", __FUNCTION__, hpc_ptr->ctlr_type);
+		debug ("%s - type of hpc: %x\n", __func__, hpc_ptr->ctlr_type);
 		switch (hpc_ptr->ctlr_type) {
 		case 1:
-			debug ("%s - bus: %x\n", __FUNCTION__, hpc_ptr->u.pci_ctlr.bus);
-			debug ("%s - dev_fun: %x\n", __FUNCTION__, hpc_ptr->u.pci_ctlr.dev_fun);
-			debug ("%s - irq: %x\n", __FUNCTION__, hpc_ptr->irq);
+			debug ("%s - bus: %x\n", __func__, hpc_ptr->u.pci_ctlr.bus);
+			debug ("%s - dev_fun: %x\n", __func__, hpc_ptr->u.pci_ctlr.dev_fun);
+			debug ("%s - irq: %x\n", __func__, hpc_ptr->irq);
 			break;
 
 		case 0:
-			debug ("%s - io_start: %x\n", __FUNCTION__, hpc_ptr->u.isa_ctlr.io_start);
-			debug ("%s - io_end: %x\n", __FUNCTION__, hpc_ptr->u.isa_ctlr.io_end);
-			debug ("%s - irq: %x\n", __FUNCTION__, hpc_ptr->irq);
+			debug ("%s - io_start: %x\n", __func__, hpc_ptr->u.isa_ctlr.io_start);
+			debug ("%s - io_end: %x\n", __func__, hpc_ptr->u.isa_ctlr.io_end);
+			debug ("%s - irq: %x\n", __func__, hpc_ptr->irq);
 			break;
 
 		case 2:
 		case 4:
-			debug ("%s - wpegbbar: %lx\n", __FUNCTION__, hpc_ptr->u.wpeg_ctlr.wpegbbar);
-			debug ("%s - i2c_addr: %x\n", __FUNCTION__, hpc_ptr->u.wpeg_ctlr.i2c_addr);
-			debug ("%s - irq: %x\n", __FUNCTION__, hpc_ptr->irq);
+			debug ("%s - wpegbbar: %lx\n", __func__, hpc_ptr->u.wpeg_ctlr.wpegbbar);
+			debug ("%s - i2c_addr: %x\n", __func__, hpc_ptr->u.wpeg_ctlr.i2c_addr);
+			debug ("%s - irq: %x\n", __func__, hpc_ptr->irq);
 			break;
 		}
 	}
diff --git a/drivers/pci/hotplug/ibmphp_hpc.c b/drivers/pci/hotplug/ibmphp_hpc.c
index c31e7bf..83f337c 100644
--- a/drivers/pci/hotplug/ibmphp_hpc.c
+++ b/drivers/pci/hotplug/ibmphp_hpc.c
@@ -129,14 +129,14 @@ static int hpc_wait_ctlr_notworking (int, struct controller *, void __iomem *, u
 *---------------------------------------------------------------------*/
 void __init ibmphp_hpc_initvars (void)
 {
-	debug ("%s - Entry\n", __FUNCTION__);
+	debug ("%s - Entry\n", __func__);
 
 	mutex_init(&sem_hpcaccess);
 	init_MUTEX (&semOperations);
 	init_MUTEX_LOCKED (&sem_exit);
 	to_debug = 0;
 
-	debug ("%s - Exit\n", __FUNCTION__);
+	debug ("%s - Exit\n", __func__);
 }
 
 /*----------------------------------------------------------------------
@@ -154,7 +154,7 @@ static u8 i2c_ctrl_read (struct controller *ctlr_ptr, void __iomem *WPGBbar, u8
 	unsigned long ultemp;
 	unsigned long data;	// actual data HILO format
 
-	debug_polling ("%s - Entry WPGBbar[%p] index[%x] \n", __FUNCTION__, WPGBbar, index);
+	debug_polling ("%s - Entry WPGBbar[%p] index[%x] \n", __func__, WPGBbar, index);
 
 	//--------------------------------------------------------------------
 	// READ - step 1
@@ -213,7 +213,7 @@ static u8 i2c_ctrl_read (struct controller *ctlr_ptr, void __iomem *WPGBbar, u8
 		i--;
 	}
 	if (i == 0) {
-		debug ("%s - Error : WPG timeout\n", __FUNCTION__);
+		debug ("%s - Error : WPG timeout\n", __func__);
 		return HPC_ERROR;
 	}
 	//--------------------------------------------------------------------
@@ -241,7 +241,7 @@ static u8 i2c_ctrl_read (struct controller *ctlr_ptr, void __iomem *WPGBbar, u8
 
 	status = (u8) data;
 
-	debug_polling ("%s - Exit index[%x] status[%x]\n", __FUNCTION__, index, status);
+	debug_polling ("%s - Exit index[%x] status[%x]\n", __func__, index, status);
 
 	return (status);
 }
@@ -262,7 +262,7 @@ static u8 i2c_ctrl_write (struct controller *ctlr_ptr, void __iomem *WPGBbar, u8
 	unsigned long data;	// actual data HILO format
 	int i;
 
-	debug_polling ("%s - Entry WPGBbar[%p] index[%x] cmd[%x]\n", __FUNCTION__, WPGBbar, index, cmd);
+	debug_polling ("%s - Entry WPGBbar[%p] index[%x] cmd[%x]\n", __func__, WPGBbar, index, cmd);
 
 	rc = 0;
 	//--------------------------------------------------------------------
@@ -324,7 +324,7 @@ static u8 i2c_ctrl_write (struct controller *ctlr_ptr, void __iomem *WPGBbar, u8
 		i--;
 	}
 	if (i == 0) {
-		debug ("%s - Exit Error:WPG timeout\n", __FUNCTION__);
+		debug ("%s - Exit Error:WPG timeout\n", __func__);
 		rc = HPC_ERROR;
 	}
 
@@ -345,7 +345,7 @@ static u8 i2c_ctrl_write (struct controller *ctlr_ptr, void __iomem *WPGBbar, u8
 		rc = HPC_ERROR;
 	}
 
-	debug_polling ("%s Exit rc[%x]\n", __FUNCTION__, rc);
+	debug_polling ("%s Exit rc[%x]\n", __func__, rc);
 	return (rc);
 }
 
@@ -541,12 +541,12 @@ int ibmphp_hpc_readslot (struct slot * pslot, u8 cmd, u8 * pstatus)
 	int rc = 0;
 	int busindex;
 
-	debug_polling ("%s - Entry pslot[%p] cmd[%x] pstatus[%p]\n", __FUNCTION__, pslot, cmd, pstatus);
+	debug_polling ("%s - Entry pslot[%p] cmd[%x] pstatus[%p]\n", __func__, pslot, cmd, pstatus);
 
 	if ((pslot == NULL)
 	    || ((pstatus == NULL) && (cmd != READ_ALLSTAT) && (cmd != READ_BUSSTATUS))) {
 		rc = -EINVAL;
-		err ("%s - Error invalid pointer, rc[%d]\n", __FUNCTION__, rc);
+		err ("%s - Error invalid pointer, rc[%d]\n", __func__, rc);
 		return rc;
 	}
 
@@ -554,7 +554,7 @@ int ibmphp_hpc_readslot (struct slot * pslot, u8 cmd, u8 * pstatus)
 		busindex = ibmphp_get_bus_index (pslot->bus);
 		if (busindex < 0) {
 			rc = -EINVAL;
-			err ("%s - Exit Error:invalid bus, rc[%d]\n", __FUNCTION__, rc);
+			err ("%s - Exit Error:invalid bus, rc[%d]\n", __func__, rc);
 			return rc;
 		} else
 			index = (u8) busindex;
@@ -565,7 +565,7 @@ int ibmphp_hpc_readslot (struct slot * pslot, u8 cmd, u8 * pstatus)
 
 	if (index == HPC_ERROR) {
 		rc = -EINVAL;
-		err ("%s - Exit Error:invalid index, rc[%d]\n", __FUNCTION__, rc);
+		err ("%s - Exit Error:invalid index, rc[%d]\n", __func__, rc);
 		return rc;
 	}
 
@@ -641,7 +641,7 @@ int ibmphp_hpc_readslot (struct slot * pslot, u8 cmd, u8 * pstatus)
 						    ctrl_read (ctlr_ptr, wpg_bbar,
 								index + WPG_1ST_EXTSLOT_INDEX);
 				} else {
-					err ("%s - Error ctrl_read failed\n", __FUNCTION__);
+					err ("%s - Error ctrl_read failed\n", __func__);
 					rc = -EINVAL;
 					break;
 				}
@@ -662,7 +662,7 @@ int ibmphp_hpc_readslot (struct slot * pslot, u8 cmd, u8 * pstatus)
 	
 	free_hpc_access ();
 
-	debug_polling ("%s - Exit rc[%d]\n", __FUNCTION__, rc);
+	debug_polling ("%s - Exit rc[%d]\n", __func__, rc);
 	return rc;
 }
 
@@ -681,10 +681,10 @@ int ibmphp_hpc_writeslot (struct slot * pslot, u8 cmd)
 	int rc = 0;
 	int timeout;
 
-	debug_polling ("%s - Entry pslot[%p] cmd[%x]\n", __FUNCTION__, pslot, cmd);
+	debug_polling ("%s - Entry pslot[%p] cmd[%x]\n", __func__, pslot, cmd);
 	if (pslot == NULL) {
 		rc = -EINVAL;
-		err ("%s - Error Exit rc[%d]\n", __FUNCTION__, rc);
+		err ("%s - Error Exit rc[%d]\n", __func__, rc);
 		return rc;
 	}
 
@@ -694,7 +694,7 @@ int ibmphp_hpc_writeslot (struct slot * pslot, u8 cmd)
 		busindex = ibmphp_get_bus_index (pslot->bus);
 		if (busindex < 0) {
 			rc = -EINVAL;
-			err ("%s - Exit Error:invalid bus, rc[%d]\n", __FUNCTION__, rc);
+			err ("%s - Exit Error:invalid bus, rc[%d]\n", __func__, rc);
 			return rc;
 		} else
 			index = (u8) busindex;
@@ -705,7 +705,7 @@ int ibmphp_hpc_writeslot (struct slot * pslot, u8 cmd)
 
 	if (index == HPC_ERROR) {
 		rc = -EINVAL;
-		err ("%s - Error Exit rc[%d]\n", __FUNCTION__, rc);
+		err ("%s - Error Exit rc[%d]\n", __func__, rc);
 		return rc;
 	}
 
@@ -719,7 +719,7 @@ int ibmphp_hpc_writeslot (struct slot * pslot, u8 cmd)
 	if ((ctlr_ptr->ctlr_type == 2) || (ctlr_ptr->ctlr_type == 4)) {
 		wpg_bbar = ioremap (ctlr_ptr->u.wpeg_ctlr.wpegbbar, WPG_I2C_IOREMAP_SIZE);
 
-		debug ("%s - ctlr id[%x] physical[%lx] logical[%lx] i2c[%x]\n", __FUNCTION__,
+		debug ("%s - ctlr id[%x] physical[%lx] logical[%lx] i2c[%x]\n", __func__,
 		ctlr_ptr->ctlr_id, (ulong) (ctlr_ptr->u.wpeg_ctlr.wpegbbar), (ulong) wpg_bbar,
 		ctlr_ptr->u.wpeg_ctlr.i2c_addr);
 	}
@@ -750,7 +750,7 @@ int ibmphp_hpc_writeslot (struct slot * pslot, u8 cmd)
 				msleep(1000);
 				if (timeout < 1) {
 					done = 1;
-					err ("%s - Error command complete timeout\n", __FUNCTION__);
+					err ("%s - Error command complete timeout\n", __func__);
 					rc = -EFAULT;
 				} else
 					timeout--;
@@ -765,7 +765,7 @@ int ibmphp_hpc_writeslot (struct slot * pslot, u8 cmd)
 		iounmap (wpg_bbar);
 	free_hpc_access ();
 
-	debug_polling ("%s - Exit rc[%d]\n", __FUNCTION__, rc);
+	debug_polling ("%s - Exit rc[%d]\n", __func__, rc);
 	return rc;
 }
 
@@ -803,10 +803,10 @@ void ibmphp_lock_operations (void)
 *---------------------------------------------------------------------*/
 void ibmphp_unlock_operations (void)
 {
-	debug ("%s - Entry\n", __FUNCTION__);
+	debug ("%s - Entry\n", __func__);
 	up (&semOperations);
 	to_debug = 0;
-	debug ("%s - Exit\n", __FUNCTION__);
+	debug ("%s - Exit\n", __func__);
 }
 
 /*----------------------------------------------------------------------
@@ -827,7 +827,7 @@ static int poll_hpc(void *data)
 	int poll_count = 0;
 	u8 ctrl_count = 0x00;
 
-	debug ("%s - Entry\n", __FUNCTION__);
+	debug ("%s - Entry\n", __func__);
 
 	while (!kthread_should_stop()) {
 		/* try to get the lock to do some kind of hardware access */
@@ -907,7 +907,7 @@ static int poll_hpc(void *data)
 		msleep(100);
 	}
 	up (&sem_exit);
-	debug ("%s - Exit\n", __FUNCTION__);
+	debug ("%s - Exit\n", __func__);
 	return 0;
 }
 
@@ -999,7 +999,7 @@ static int process_changeinstatus (struct slot *pslot, struct slot *poldslot)
 		ibmphp_update_slot_info (pslot);
 	}
 
-	debug ("%s - Exit rc[%d] disable[%x] update[%x]\n", __FUNCTION__, rc, disable, update);
+	debug ("%s - Exit rc[%d] disable[%x] update[%x]\n", __func__, rc, disable, update);
 
 	return rc;
 }
@@ -1021,7 +1021,7 @@ static int process_changeinlatch (u8 old, u8 new, struct controller *ctrl)
 	u8 mask;
 	int rc = 0;
 
-	debug ("%s - Entry old[%x], new[%x]\n", __FUNCTION__, old, new);
+	debug ("%s - Entry old[%x], new[%x]\n", __func__, old, new);
 	// bit 0 reserved, 0 is LSB, check bit 1-6 for 6 slots
 
 	for (i = ctrl->starting_slot_num; i <= ctrl->ending_slot_num; i++) {
@@ -1031,15 +1031,15 @@ static int process_changeinlatch (u8 old, u8 new, struct controller *ctrl)
 			if (pslot) {
 				memcpy ((void *) &myslot, (void *) pslot, sizeof (struct slot));
 				rc = ibmphp_hpc_readslot (pslot, READ_ALLSTAT, NULL);
-				debug ("%s - call process_changeinstatus for slot[%d]\n", __FUNCTION__, i);
+				debug ("%s - call process_changeinstatus for slot[%d]\n", __func__, i);
 				process_changeinstatus (pslot, &myslot);
 			} else {
 				rc = -EINVAL;
-				err ("%s - Error bad pointer for slot[%d]\n", __FUNCTION__, i);
+				err ("%s - Error bad pointer for slot[%d]\n", __func__, i);
 			}
 		}
 	}
-	debug ("%s - Exit rc[%d]\n", __FUNCTION__, rc);
+	debug ("%s - Exit rc[%d]\n", __func__, rc);
 	return rc;
 }
 
@@ -1050,11 +1050,11 @@ static int process_changeinlatch (u8 old, u8 new, struct controller *ctrl)
 *---------------------------------------------------------------------*/
 int __init ibmphp_hpc_start_poll_thread (void)
 {
-	debug ("%s - Entry\n", __FUNCTION__);
+	debug ("%s - Entry\n", __func__);
 
 	ibmphp_poll_thread = kthread_run(poll_hpc, NULL, "hpc_poll");
 	if (IS_ERR(ibmphp_poll_thread)) {
-		err ("%s - Error, thread not started\n", __FUNCTION__);
+		err ("%s - Error, thread not started\n", __func__);
 		return PTR_ERR(ibmphp_poll_thread);
 	}
 	return 0;
@@ -1067,7 +1067,7 @@ int __init ibmphp_hpc_start_poll_thread (void)
 *---------------------------------------------------------------------*/
 void __exit ibmphp_hpc_stop_poll_thread (void)
 {
-	debug ("%s - Entry\n", __FUNCTION__);
+	debug ("%s - Entry\n", __func__);
 
 	kthread_stop(ibmphp_poll_thread);
 	debug ("before locking operations \n");
@@ -1088,7 +1088,7 @@ void __exit ibmphp_hpc_stop_poll_thread (void)
 	up (&sem_exit);
 	debug ("after sem exit up\n");
 
-	debug ("%s - Exit\n", __FUNCTION__);
+	debug ("%s - Exit\n", __func__);
 }
 
 /*----------------------------------------------------------------------
diff --git a/drivers/pci/hotplug/ibmphp_pci.c b/drivers/pci/hotplug/ibmphp_pci.c
index d8f05d7..7b09e16 100644
--- a/drivers/pci/hotplug/ibmphp_pci.c
+++ b/drivers/pci/hotplug/ibmphp_pci.c
@@ -364,7 +364,7 @@ static int configure_device (struct pci_func *func)
 	struct resource_node *pfmem[6];
 	unsigned int devfn;
 
-	debug ("%s - inside\n", __FUNCTION__);
+	debug ("%s - inside\n", __func__);
 
 	devfn = PCI_DEVFN(func->device, func->function);
 	ibmphp_pci_bus->number = func->busno;
@@ -595,7 +595,7 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 	u8 irq;
 	int retval;
 
-	debug ("%s - enter\n", __FUNCTION__);
+	debug ("%s - enter\n", __func__);
 
 	devfn = PCI_DEVFN(func->function, func->device);
 	ibmphp_pci_bus->number = func->busno;
@@ -1234,7 +1234,7 @@ static int unconfigure_boot_device (u8 busno, u8 device, u8 function)
 	u32 tmp_address;
 	unsigned int devfn;
 
-	debug ("%s - enter\n", __FUNCTION__);
+	debug ("%s - enter\n", __func__);
 
 	bus = ibmphp_find_res_bus (busno);
 	if (!bus) {
@@ -1351,7 +1351,7 @@ static int unconfigure_boot_bridge (u8 busno, u8 device, u8 function)
 	bus_no = (int) busno;
 	debug ("busno is %x\n", busno);
 	pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_PRIMARY_BUS, &pri_number);
-	debug ("%s - busno = %x, primary_number = %x\n", __FUNCTION__, busno, pri_number);
+	debug ("%s - busno = %x, primary_number = %x\n", __func__, busno, pri_number);
 
 	pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_SECONDARY_BUS, &sec_number);
 	debug ("sec_number is %x\n", sec_number);
@@ -1437,7 +1437,7 @@ static int unconfigure_boot_bridge (u8 busno, u8 device, u8 function)
 			}
 		}	/* end of mem */
 	}	/* end of for */
-	debug ("%s - exiting, returning success\n", __FUNCTION__);
+	debug ("%s - exiting, returning success\n", __func__);
 	return 0;
 }
 
@@ -1453,7 +1453,7 @@ static int unconfigure_boot_card (struct slot *slot_cur)
 	unsigned int devfn;
 	u8 valid_device = 0x00; /* To see if we are ever able to find valid device and read it */
 
-	debug ("%s - enter\n", __FUNCTION__);
+	debug ("%s - enter\n", __func__);
 
 	device = slot_cur->device;
 	busno = slot_cur->bus;
@@ -1470,7 +1470,7 @@ static int unconfigure_boot_card (struct slot *slot_cur)
 			/* found correct device!!! */
 			++valid_device;
 
-			debug ("%s - found correct device\n", __FUNCTION__);
+			debug ("%s - found correct device\n", __func__);
 
 			/* header: x x x x x x x x
 			 *         | |___________|=> 1=PPB bridge, 0=normal device, 2=CardBus Bridge
@@ -1573,7 +1573,7 @@ int ibmphp_unconfigure_card (struct slot **slot_cur, int the_end)
 	struct pci_func *cur_func = NULL;
 	struct pci_func *temp_func;
 
-	debug ("%s - enter\n", __FUNCTION__);
+	debug ("%s - enter\n", __func__);
 
 	if (!the_end) {
 		/* Need to unconfigure the card */
@@ -1624,7 +1624,7 @@ int ibmphp_unconfigure_card (struct slot **slot_cur, int the_end)
 
 	sl->func = NULL;
 	*slot_cur = sl;
-	debug ("%s - exit\n", __FUNCTION__);
+	debug ("%s - exit\n", __func__);
 	return 0;
 }
 
diff --git a/drivers/pci/hotplug/ibmphp_res.c b/drivers/pci/hotplug/ibmphp_res.c
index 5636b1a..ec73294 100644
--- a/drivers/pci/hotplug/ibmphp_res.c
+++ b/drivers/pci/hotplug/ibmphp_res.c
@@ -563,7 +563,7 @@ static void fix_resources (struct bus_node *bus_cur)
 	struct range_node *range;
 	struct resource_node *res;
 
-	debug ("%s - bus_cur->busno = %d\n", __FUNCTION__, bus_cur->busno);
+	debug ("%s - bus_cur->busno = %d\n", __func__, bus_cur->busno);
 
 	if (bus_cur->needIOUpdate) {
 		res = bus_cur->firstIO;
@@ -599,7 +599,7 @@ int ibmphp_add_resource (struct resource_node *res)
 	struct range_node *range_cur = NULL;
 	struct resource_node *res_start = NULL;
 
-	debug ("%s - enter\n", __FUNCTION__);
+	debug ("%s - enter\n", __func__);
 
 	if (!res) {
 		err ("NULL passed to add\n");
@@ -762,7 +762,7 @@ int ibmphp_add_resource (struct resource_node *res)
 		}
 	}
 
-	debug ("%s - exit\n", __FUNCTION__);
+	debug ("%s - exit\n", __func__);
 	return 0;
 }
 
@@ -1001,7 +1001,7 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 		return -EINVAL;
 	}
 
-	debug ("%s - enter\n", __FUNCTION__);
+	debug ("%s - enter\n", __func__);
 	debug ("bus_cur->busno is %d\n", bus_cur->busno);
 
 	/* This is a quick fix to not mess up with the code very much.  i.e.,
@@ -1029,7 +1029,7 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 
 	while (res_cur) {
 		range = find_range (bus_cur, res_cur);
-		debug ("%s - rangeno = %d\n", __FUNCTION__, res_cur->rangeno);
+		debug ("%s - rangeno = %d\n", __func__, res_cur->rangeno);
 
 		if (!range) {
 			err ("no range for the device exists... bailing out...\n");
@@ -1942,7 +1942,7 @@ static int __init update_bridge_ranges (struct bus_node **bus)
 		return -ENODEV;
 	ibmphp_pci_bus->number = bus_cur->busno;
 
-	debug ("inside %s\n", __FUNCTION__);
+	debug ("inside %s\n", __func__);
 	debug ("bus_cur->busno = %x\n", bus_cur->busno);
 
 	for (device = 0; device < 32; device++) {
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index dd59a05..925ba16 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -43,7 +43,7 @@
 
 #define MY_NAME	"pci_hotplug"
 
-#define dbg(fmt, arg...) do { if (debug) printk(KERN_DEBUG "%s: %s: " fmt , MY_NAME , __FUNCTION__ , ## arg); } while (0)
+#define dbg(fmt, arg...) do { if (debug) printk(KERN_DEBUG "%s: %s: " fmt , MY_NAME , __func__ , ## arg); } while (0)
 #define err(format, arg...) printk(KERN_ERR "%s: " format , MY_NAME , ## arg)
 #define info(format, arg...) printk(KERN_INFO "%s: " format , MY_NAME , ## arg)
 #define warn(format, arg...) printk(KERN_WARNING "%s: " format , MY_NAME , ## arg)
diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index ca656b2..f14267e 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -168,7 +168,7 @@ static inline struct slot *pciehp_find_slot(struct controller *ctrl, u8 device)
 			return slot;
 	}
 
-	err("%s: slot (device=0x%x) not found\n", __FUNCTION__, device);
+	err("%s: slot (device=0x%x) not found\n", __func__, device);
 	return NULL;
 }
 
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 7f4836b..b5cfaa3 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -184,7 +184,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	kfree(slot->hotplug_slot->info);
 	kfree(slot->hotplug_slot);
@@ -301,7 +301,7 @@ static int set_attention_status(struct hotplug_slot *hotplug_slot, u8 status)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	hotplug_slot->info->attention_status = status;
 
@@ -316,7 +316,7 @@ static int enable_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	return pciehp_sysfs_enable_slot(slot);
 }
@@ -326,7 +326,7 @@ static int disable_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	return pciehp_sysfs_disable_slot(slot);
 }
@@ -336,7 +336,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	retval = slot->hpc_ops->get_power_status(slot, value);
 	if (retval < 0)
@@ -350,7 +350,7 @@ static int get_attention_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	retval = slot->hpc_ops->get_attention_status(slot, value);
 	if (retval < 0)
@@ -364,7 +364,7 @@ static int get_latch_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	retval = slot->hpc_ops->get_latch_status(slot, value);
 	if (retval < 0)
@@ -378,7 +378,7 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	retval = slot->hpc_ops->get_adapter_status(slot, value);
 	if (retval < 0)
@@ -392,7 +392,7 @@ static int get_address(struct hotplug_slot *hotplug_slot, u32 *value)
 	struct slot *slot = hotplug_slot->private;
 	struct pci_bus *bus = slot->ctrl->pci_dev->subordinate;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	*value = (pci_domain_nr(bus) << 16) | (slot->bus << 8) | slot->device;
 
@@ -404,7 +404,7 @@ static int get_max_bus_speed(struct hotplug_slot *hotplug_slot, enum pci_bus_spe
 	struct slot *slot = hotplug_slot->private;
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	retval = slot->hpc_ops->get_max_bus_speed(slot, value);
 	if (retval < 0)
@@ -418,7 +418,7 @@ static int get_cur_bus_speed(struct hotplug_slot *hotplug_slot, enum pci_bus_spe
 	struct slot *slot = hotplug_slot->private;
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	retval = slot->hpc_ops->get_cur_bus_speed(slot, value);
 	if (retval < 0)
@@ -437,7 +437,7 @@ static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_
 
 	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
 	if (!ctrl) {
-		err("%s : out of memory\n", __FUNCTION__);
+		err("%s : out of memory\n", __func__);
 		goto err_out_none;
 	}
 	INIT_LIST_HEAD(&ctrl->slot_list);
@@ -454,7 +454,7 @@ static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_
 	pci_set_drvdata(pdev, ctrl);
 
 	dbg("%s: ctrl bus=0x%x, device=%x, function=%x, irq=%x\n",
-	    __FUNCTION__, pdev->bus->number, PCI_SLOT(pdev->devfn),
+	    __func__, pdev->bus->number, PCI_SLOT(pdev->devfn),
 	    PCI_FUNC(pdev->devfn), pdev->irq);
 
 	/* Setup the slot information structures */
@@ -503,13 +503,13 @@ static void pciehp_remove (struct pcie_device *dev)
 #ifdef CONFIG_PM
 static int pciehp_suspend (struct pcie_device *dev, pm_message_t state)
 {
-	printk("%s ENTRY\n", __FUNCTION__);
+	printk("%s ENTRY\n", __func__);
 	return 0;
 }
 
 static int pciehp_resume (struct pcie_device *dev)
 {
-	printk("%s ENTRY\n", __FUNCTION__);
+	printk("%s ENTRY\n", __func__);
 	if (pciehp_force) {
 		struct pci_dev *pdev = dev->port;
 		struct controller *ctrl = pci_get_drvdata(pdev);
@@ -563,7 +563,7 @@ static int __init pcied_init(void)
  	dbg("pcie_port_service_register = %d\n", retval);
   	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
  	if (retval)
-		dbg("%s: Failure to register service\n", __FUNCTION__);
+		dbg("%s: Failure to register service\n", __func__);
 	return retval;
 }
 
diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index b23061c..0c481f7 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -181,7 +181,7 @@ static void set_slot_off(struct controller *ctrl, struct slot * pslot)
 	if (POWER_CTRL(ctrl->ctrlcap)) {
 		if (pslot->hpc_ops->power_off_slot(pslot)) {
 			err("%s: Issue of Slot Power Off command failed\n",
-			    __FUNCTION__);
+			    __func__);
 			return;
 		}
 	}
@@ -192,7 +192,7 @@ static void set_slot_off(struct controller *ctrl, struct slot * pslot)
 	if (ATTN_LED(ctrl->ctrlcap)) {
 		if (pslot->hpc_ops->set_attention_status(pslot, 1)) {
 			err("%s: Issue of Set Attention Led command failed\n",
-			    __FUNCTION__);
+			    __func__);
 			return;
 		}
 	}
@@ -211,7 +211,7 @@ static int board_added(struct slot *p_slot)
 	struct controller *ctrl = p_slot->ctrl;
 
 	dbg("%s: slot device, slot offset, hp slot = %d, %d ,%d\n",
-			__FUNCTION__, p_slot->device,
+			__func__, p_slot->device,
 			ctrl->slot_device_offset, p_slot->hp_slot);
 
 	if (POWER_CTRL(ctrl->ctrlcap)) {
@@ -230,14 +230,14 @@ static int board_added(struct slot *p_slot)
 	/* Check link training status */
 	retval = p_slot->hpc_ops->check_lnk_status(ctrl);
 	if (retval) {
-		err("%s: Failed to check link status\n", __FUNCTION__);
+		err("%s: Failed to check link status\n", __func__);
 		set_slot_off(ctrl, p_slot);
 		return retval;
 	}
 
 	/* Check for a power fault */
 	if (p_slot->hpc_ops->query_power_fault(p_slot)) {
-		dbg("%s: power fault detected\n", __FUNCTION__);
+		dbg("%s: power fault detected\n", __func__);
 		retval = POWER_FAILURE;
 		goto err_exit;
 	}
@@ -277,14 +277,14 @@ static int remove_board(struct slot *p_slot)
 	if (retval)
 		return retval;
 
-	dbg("In %s, hp_slot = %d\n", __FUNCTION__, p_slot->hp_slot);
+	dbg("In %s, hp_slot = %d\n", __func__, p_slot->hp_slot);
 
 	if (POWER_CTRL(ctrl->ctrlcap)) {
 		/* power off slot */
 		retval = p_slot->hpc_ops->power_off_slot(p_slot);
 		if (retval) {
 			err("%s: Issue of Slot Disable command failed\n",
-			    __FUNCTION__);
+			    __func__);
 			return retval;
 		}
 	}
@@ -319,7 +319,7 @@ static void pciehp_power_thread(struct work_struct *work)
 	case POWEROFF_STATE:
 		mutex_unlock(&p_slot->lock);
 		dbg("%s: disabling bus:device(%x:%x)\n",
-		    __FUNCTION__, p_slot->bus, p_slot->device);
+		    __func__, p_slot->bus, p_slot->device);
 		pciehp_disable_slot(p_slot);
 		mutex_lock(&p_slot->lock);
 		p_slot->state = STATIC_STATE;
@@ -347,7 +347,7 @@ void pciehp_queue_pushbutton_work(struct work_struct *work)
 
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
-		err("%s: Cannot allocate memory\n", __FUNCTION__);
+		err("%s: Cannot allocate memory\n", __func__);
 		return;
 	}
 	info->p_slot = p_slot;
@@ -424,7 +424,7 @@ static void handle_button_press_event(struct slot *p_slot)
 		 * expires to cancel hot-add or hot-remove
 		 */
 		info("Button cancel on Slot(%s)\n", p_slot->name);
-		dbg("%s: button cancel\n", __FUNCTION__);
+		dbg("%s: button cancel\n", __func__);
 		cancel_delayed_work(&p_slot->work);
 		if (p_slot->state == BLINKINGOFF_STATE) {
 			if (PWR_LED(ctrl->ctrlcap))
@@ -465,7 +465,7 @@ static void handle_surprise_event(struct slot *p_slot)
 
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
-		err("%s: Cannot allocate memory\n", __FUNCTION__);
+		err("%s: Cannot allocate memory\n", __func__);
 		return;
 	}
 	info->p_slot = p_slot;
@@ -526,7 +526,7 @@ int pciehp_enable_slot(struct slot *p_slot)
 
 	rc = p_slot->hpc_ops->get_adapter_status(p_slot, &getstatus);
 	if (rc || !getstatus) {
-		info("%s: no adapter on slot(%s)\n", __FUNCTION__,
+		info("%s: no adapter on slot(%s)\n", __func__,
 		     p_slot->name);
 		mutex_unlock(&p_slot->ctrl->crit_sect);
 		return -ENODEV;
@@ -534,7 +534,7 @@ int pciehp_enable_slot(struct slot *p_slot)
 	if (MRL_SENS(p_slot->ctrl->ctrlcap)) {
 		rc = p_slot->hpc_ops->get_latch_status(p_slot, &getstatus);
 		if (rc || getstatus) {
-			info("%s: latch open on slot(%s)\n", __FUNCTION__,
+			info("%s: latch open on slot(%s)\n", __func__,
 			     p_slot->name);
 			mutex_unlock(&p_slot->ctrl->crit_sect);
 			return -ENODEV;
@@ -544,7 +544,7 @@ int pciehp_enable_slot(struct slot *p_slot)
 	if (POWER_CTRL(p_slot->ctrl->ctrlcap)) {
 		rc = p_slot->hpc_ops->get_power_status(p_slot, &getstatus);
 		if (rc || getstatus) {
-			info("%s: already enabled on slot(%s)\n", __FUNCTION__,
+			info("%s: already enabled on slot(%s)\n", __func__,
 			     p_slot->name);
 			mutex_unlock(&p_slot->ctrl->crit_sect);
 			return -EINVAL;
@@ -579,7 +579,7 @@ int pciehp_disable_slot(struct slot *p_slot)
 	if (!HP_SUPR_RM(p_slot->ctrl->ctrlcap)) {
 		ret = p_slot->hpc_ops->get_adapter_status(p_slot, &getstatus);
 		if (ret || !getstatus) {
-			info("%s: no adapter on slot(%s)\n", __FUNCTION__,
+			info("%s: no adapter on slot(%s)\n", __func__,
 			     p_slot->name);
 			mutex_unlock(&p_slot->ctrl->crit_sect);
 			return -ENODEV;
@@ -589,7 +589,7 @@ int pciehp_disable_slot(struct slot *p_slot)
 	if (MRL_SENS(p_slot->ctrl->ctrlcap)) {
 		ret = p_slot->hpc_ops->get_latch_status(p_slot, &getstatus);
 		if (ret || getstatus) {
-			info("%s: latch open on slot(%s)\n", __FUNCTION__,
+			info("%s: latch open on slot(%s)\n", __func__,
 			     p_slot->name);
 			mutex_unlock(&p_slot->ctrl->crit_sect);
 			return -ENODEV;
@@ -599,7 +599,7 @@ int pciehp_disable_slot(struct slot *p_slot)
 	if (POWER_CTRL(p_slot->ctrl->ctrlcap)) {
 		ret = p_slot->hpc_ops->get_power_status(p_slot, &getstatus);
 		if (ret || !getstatus) {
-			info("%s: already disabled slot(%s)\n", __FUNCTION__,
+			info("%s: already disabled slot(%s)\n", __func__,
 			     p_slot->name);
 			mutex_unlock(&p_slot->ctrl->crit_sect);
 			return -EINVAL;
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 6eba9b2..91304b7 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -258,7 +258,7 @@ static int pcie_write_cmd(struct slot *slot, u16 cmd, u16 mask)
 
 	retval = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 	if (retval) {
-		err("%s: Cannot read SLOTSTATUS register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTSTATUS register\n", __func__);
 		goto out;
 	}
 
@@ -267,13 +267,13 @@ static int pcie_write_cmd(struct slot *slot, u16 cmd, u16 mask)
 		   proceed forward to issue the next command according
 		   to spec.  Just print out the error message */
 		dbg("%s: CMD_COMPLETED not clear after 1 sec.\n",
-		    __FUNCTION__);
+		    __func__);
 	}
 
 	spin_lock_irqsave(&ctrl->lock, flags);
 	retval = pciehp_readw(ctrl, SLOTCTRL, &slot_ctrl);
 	if (retval) {
-		err("%s: Cannot read SLOTCTRL register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTCTRL register\n", __func__);
 		goto out_spin_unlock;
 	}
 
@@ -283,7 +283,7 @@ static int pcie_write_cmd(struct slot *slot, u16 cmd, u16 mask)
 	ctrl->cmd_busy = 1;
 	retval = pciehp_writew(ctrl, SLOTCTRL, slot_ctrl);
 	if (retval)
-		err("%s: Cannot write to SLOTCTRL register\n", __FUNCTION__);
+		err("%s: Cannot write to SLOTCTRL register\n", __func__);
 
  out_spin_unlock:
 	spin_unlock_irqrestore(&ctrl->lock, flags);
@@ -305,14 +305,14 @@ static int hpc_check_lnk_status(struct controller *ctrl)
 
 	retval = pciehp_readw(ctrl, LNKSTATUS, &lnk_status);
 	if (retval) {
-		err("%s: Cannot read LNKSTATUS register\n", __FUNCTION__);
+		err("%s: Cannot read LNKSTATUS register\n", __func__);
 		return retval;
 	}
 
-	dbg("%s: lnk_status = %x\n", __FUNCTION__, lnk_status);
+	dbg("%s: lnk_status = %x\n", __func__, lnk_status);
 	if ( (lnk_status & LNK_TRN) || (lnk_status & LNK_TRN_ERR) ||
 		!(lnk_status & NEG_LINK_WD)) {
-		err("%s : Link Training Error occurs \n", __FUNCTION__);
+		err("%s : Link Training Error occurs \n", __func__);
 		retval = -1;
 		return retval;
 	}
@@ -329,12 +329,12 @@ static int hpc_get_attention_status(struct slot *slot, u8 *status)
 
 	retval = pciehp_readw(ctrl, SLOTCTRL, &slot_ctrl);
 	if (retval) {
-		err("%s: Cannot read SLOTCTRL register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTCTRL register\n", __func__);
 		return retval;
 	}
 
 	dbg("%s: SLOTCTRL %x, value read %x\n",
-	    __FUNCTION__, ctrl->cap_base + SLOTCTRL, slot_ctrl);
+	    __func__, ctrl->cap_base + SLOTCTRL, slot_ctrl);
 
 	atten_led_state = (slot_ctrl & ATTN_LED_CTRL) >> 6;
 
@@ -368,11 +368,11 @@ static int hpc_get_power_status(struct slot *slot, u8 *status)
 
 	retval = pciehp_readw(ctrl, SLOTCTRL, &slot_ctrl);
 	if (retval) {
-		err("%s: Cannot read SLOTCTRL register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTCTRL register\n", __func__);
 		return retval;
 	}
 	dbg("%s: SLOTCTRL %x value read %x\n",
-	    __FUNCTION__, ctrl->cap_base + SLOTCTRL, slot_ctrl);
+	    __func__, ctrl->cap_base + SLOTCTRL, slot_ctrl);
 
 	pwr_state = (slot_ctrl & PWR_CTRL) >> 10;
 
@@ -399,7 +399,7 @@ static int hpc_get_latch_status(struct slot *slot, u8 *status)
 
 	retval = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 	if (retval) {
-		err("%s: Cannot read SLOTSTATUS register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTSTATUS register\n", __func__);
 		return retval;
 	}
 
@@ -417,7 +417,7 @@ static int hpc_get_adapter_status(struct slot *slot, u8 *status)
 
 	retval = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 	if (retval) {
-		err("%s: Cannot read SLOTSTATUS register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTSTATUS register\n", __func__);
 		return retval;
 	}
 	card_state = (u8)((slot_status & PRSN_STATE) >> 6);
@@ -435,7 +435,7 @@ static int hpc_query_power_fault(struct slot *slot)
 
 	retval = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 	if (retval) {
-		err("%s: Cannot check for power fault\n", __FUNCTION__);
+		err("%s: Cannot check for power fault\n", __func__);
 		return retval;
 	}
 	pwr_fault = (u8)((slot_status & PWR_FAULT_DETECTED) >> 1);
@@ -451,7 +451,7 @@ static int hpc_get_emi_status(struct slot *slot, u8 *status)
 
 	retval = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 	if (retval) {
-		err("%s : Cannot check EMI status\n", __FUNCTION__);
+		err("%s : Cannot check EMI status\n", __func__);
 		return retval;
 	}
 	*status = (slot_status & EMI_STATE) >> EMI_STATUS_BIT;
@@ -506,7 +506,7 @@ static int hpc_set_attention_status(struct slot *slot, u8 value)
 
 	rc = pcie_write_cmd(slot, slot_cmd, cmd_mask);
 	dbg("%s: SLOTCTRL %x write cmd %x\n",
-	    __FUNCTION__, ctrl->cap_base + SLOTCTRL, slot_cmd);
+	    __func__, ctrl->cap_base + SLOTCTRL, slot_cmd);
 
 	return rc;
 }
@@ -527,7 +527,7 @@ static void hpc_set_green_led_on(struct slot *slot)
 	pcie_write_cmd(slot, slot_cmd, cmd_mask);
 
 	dbg("%s: SLOTCTRL %x write cmd %x\n",
-	    __FUNCTION__, ctrl->cap_base + SLOTCTRL, slot_cmd);
+	    __func__, ctrl->cap_base + SLOTCTRL, slot_cmd);
 }
 
 static void hpc_set_green_led_off(struct slot *slot)
@@ -545,7 +545,7 @@ static void hpc_set_green_led_off(struct slot *slot)
 
 	pcie_write_cmd(slot, slot_cmd, cmd_mask);
 	dbg("%s: SLOTCTRL %x write cmd %x\n",
-	    __FUNCTION__, ctrl->cap_base + SLOTCTRL, slot_cmd);
+	    __func__, ctrl->cap_base + SLOTCTRL, slot_cmd);
 }
 
 static void hpc_set_green_led_blink(struct slot *slot)
@@ -564,7 +564,7 @@ static void hpc_set_green_led_blink(struct slot *slot)
 	pcie_write_cmd(slot, slot_cmd, cmd_mask);
 
 	dbg("%s: SLOTCTRL %x write cmd %x\n",
-	    __FUNCTION__, ctrl->cap_base + SLOTCTRL, slot_cmd);
+	    __func__, ctrl->cap_base + SLOTCTRL, slot_cmd);
 }
 
 static void hpc_release_ctlr(struct controller *ctrl)
@@ -590,12 +590,12 @@ static int hpc_power_on_slot(struct slot * slot)
 	u16 slot_status;
 	int retval = 0;
 
-	dbg("%s: slot->hp_slot %x\n", __FUNCTION__, slot->hp_slot);
+	dbg("%s: slot->hp_slot %x\n", __func__, slot->hp_slot);
 
 	/* Clear sticky power-fault bit from previous power failures */
 	retval = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 	if (retval) {
-		err("%s: Cannot read SLOTSTATUS register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTSTATUS register\n", __func__);
 		return retval;
 	}
 	slot_status &= PWR_FAULT_DETECTED;
@@ -603,7 +603,7 @@ static int hpc_power_on_slot(struct slot * slot)
 		retval = pciehp_writew(ctrl, SLOTSTATUS, slot_status);
 		if (retval) {
 			err("%s: Cannot write to SLOTSTATUS register\n",
-			    __FUNCTION__);
+			    __func__);
 			return retval;
 		}
 	}
@@ -627,11 +627,11 @@ static int hpc_power_on_slot(struct slot * slot)
 	retval = pcie_write_cmd(slot, slot_cmd, cmd_mask);
 
 	if (retval) {
-		err("%s: Write %x command failed!\n", __FUNCTION__, slot_cmd);
+		err("%s: Write %x command failed!\n", __func__, slot_cmd);
 		return -1;
 	}
 	dbg("%s: SLOTCTRL %x write cmd %x\n",
-	    __FUNCTION__, ctrl->cap_base + SLOTCTRL, slot_cmd);
+	    __func__, ctrl->cap_base + SLOTCTRL, slot_cmd);
 
 	return retval;
 }
@@ -677,7 +677,7 @@ static int hpc_power_off_slot(struct slot * slot)
 	int retval = 0;
 	int changed;
 
-	dbg("%s: slot->hp_slot %x\n", __FUNCTION__, slot->hp_slot);
+	dbg("%s: slot->hp_slot %x\n", __func__, slot->hp_slot);
 
 	/*
 	 * Set Bad DLLP Mask bit in Correctable Error Mask
@@ -710,11 +710,11 @@ static int hpc_power_off_slot(struct slot * slot)
 
 	retval = pcie_write_cmd(slot, slot_cmd, cmd_mask);
 	if (retval) {
-		err("%s: Write command failed!\n", __FUNCTION__);
+		err("%s: Write command failed!\n", __func__);
 		return -1;
 	}
 	dbg("%s: SLOTCTRL %x write cmd %x\n",
-	    __FUNCTION__, ctrl->cap_base + SLOTCTRL, slot_cmd);
+	    __func__, ctrl->cap_base + SLOTCTRL, slot_cmd);
 
 	/*
 	 * After turning power off, we must wait for at least 1 second
@@ -740,7 +740,7 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 
 	rc = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 	if (rc) {
-		err("%s: Cannot read SLOTSTATUS register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTSTATUS register\n", __func__);
 		return IRQ_NONE;
 	}
 
@@ -753,26 +753,26 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 	if ( !intr_loc )
 		return IRQ_NONE;
 
-	dbg("%s: intr_loc %x\n", __FUNCTION__, intr_loc);
+	dbg("%s: intr_loc %x\n", __func__, intr_loc);
 	/* Mask Hot-plug Interrupt Enable */
 	if (!pciehp_poll_mode) {
 		spin_lock_irqsave(&ctrl->lock, flags);
 		rc = pciehp_readw(ctrl, SLOTCTRL, &temp_word);
 		if (rc) {
 			err("%s: Cannot read SLOT_CTRL register\n",
-			    __FUNCTION__);
+			    __func__);
 			spin_unlock_irqrestore(&ctrl->lock, flags);
 			return IRQ_NONE;
 		}
 
 		dbg("%s: pciehp_readw(SLOTCTRL) with value %x\n",
-		    __FUNCTION__, temp_word);
+		    __func__, temp_word);
 		temp_word = (temp_word & ~HP_INTR_ENABLE &
 			     ~CMD_CMPL_INTR_ENABLE) | 0x00;
 		rc = pciehp_writew(ctrl, SLOTCTRL, temp_word);
 		if (rc) {
 			err("%s: Cannot write to SLOTCTRL register\n",
-			    __FUNCTION__);
+			    __func__);
 			spin_unlock_irqrestore(&ctrl->lock, flags);
 			return IRQ_NONE;
 		}
@@ -781,18 +781,18 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 		rc = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 		if (rc) {
 			err("%s: Cannot read SLOT_STATUS register\n",
-			    __FUNCTION__);
+			    __func__);
 			return IRQ_NONE;
 		}
 		dbg("%s: pciehp_readw(SLOTSTATUS) with value %x\n",
-		    __FUNCTION__, slot_status);
+		    __func__, slot_status);
 
 		/* Clear command complete interrupt caused by this write */
 		temp_word = 0x1f;
 		rc = pciehp_writew(ctrl, SLOTSTATUS, temp_word);
 		if (rc) {
 			err("%s: Cannot write to SLOTSTATUS register\n",
-			    __FUNCTION__);
+			    __func__);
 			return IRQ_NONE;
 		}
 	}
@@ -821,7 +821,7 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 	temp_word = 0x1F;
 	rc = pciehp_writew(ctrl, SLOTSTATUS, temp_word);
 	if (rc) {
-		err("%s: Cannot write to SLOTSTATUS register\n", __FUNCTION__);
+		err("%s: Cannot write to SLOTSTATUS register\n", __func__);
 		return IRQ_NONE;
 	}
 	/* Unmask Hot-plug Interrupt Enable */
@@ -830,18 +830,18 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 		rc = pciehp_readw(ctrl, SLOTCTRL, &temp_word);
 		if (rc) {
 			err("%s: Cannot read SLOTCTRL register\n",
-			    __FUNCTION__);
+			    __func__);
 			spin_unlock_irqrestore(&ctrl->lock, flags);
 			return IRQ_NONE;
 		}
 
-		dbg("%s: Unmask Hot-plug Interrupt Enable\n", __FUNCTION__);
+		dbg("%s: Unmask Hot-plug Interrupt Enable\n", __func__);
 		temp_word = (temp_word & ~HP_INTR_ENABLE) | HP_INTR_ENABLE;
 
 		rc = pciehp_writew(ctrl, SLOTCTRL, temp_word);
 		if (rc) {
 			err("%s: Cannot write to SLOTCTRL register\n",
-			    __FUNCTION__);
+			    __func__);
 			spin_unlock_irqrestore(&ctrl->lock, flags);
 			return IRQ_NONE;
 		}
@@ -850,7 +850,7 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 		rc = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 		if (rc) {
 			err("%s: Cannot read SLOT_STATUS register\n",
-			    __FUNCTION__);
+			    __func__);
 			return IRQ_NONE;
 		}
 
@@ -859,11 +859,11 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 		rc = pciehp_writew(ctrl, SLOTSTATUS, temp_word);
 		if (rc) {
 			err("%s: Cannot write to SLOTSTATUS failed\n",
-			    __FUNCTION__);
+			    __func__);
 			return IRQ_NONE;
 		}
 		dbg("%s: pciehp_writew(SLOTSTATUS) with value %x\n",
-		    __FUNCTION__, temp_word);
+		    __func__, temp_word);
 	}
 
 	return IRQ_HANDLED;
@@ -878,7 +878,7 @@ static int hpc_get_max_lnk_speed(struct slot *slot, enum pci_bus_speed *value)
 
 	retval = pciehp_readl(ctrl, LNKCAP, &lnk_cap);
 	if (retval) {
-		err("%s: Cannot read LNKCAP register\n", __FUNCTION__);
+		err("%s: Cannot read LNKCAP register\n", __func__);
 		return retval;
 	}
 
@@ -907,7 +907,7 @@ static int hpc_get_max_lnk_width(struct slot *slot,
 
 	retval = pciehp_readl(ctrl, LNKCAP, &lnk_cap);
 	if (retval) {
-		err("%s: Cannot read LNKCAP register\n", __FUNCTION__);
+		err("%s: Cannot read LNKCAP register\n", __func__);
 		return retval;
 	}
 
@@ -956,7 +956,7 @@ static int hpc_get_cur_lnk_speed(struct slot *slot, enum pci_bus_speed *value)
 
 	retval = pciehp_readw(ctrl, LNKSTATUS, &lnk_status);
 	if (retval) {
-		err("%s: Cannot read LNKSTATUS register\n", __FUNCTION__);
+		err("%s: Cannot read LNKSTATUS register\n", __func__);
 		return retval;
 	}
 
@@ -985,7 +985,7 @@ static int hpc_get_cur_lnk_width(struct slot *slot,
 
 	retval = pciehp_readw(ctrl, LNKSTATUS, &lnk_status);
 	if (retval) {
-		err("%s: Cannot read LNKSTATUS register\n", __FUNCTION__);
+		err("%s: Cannot read LNKSTATUS register\n", __func__);
 		return retval;
 	}
 
@@ -1129,38 +1129,38 @@ static int pcie_init_hardware_part1(struct controller *ctrl,
 
 	rc = pciehp_readl(ctrl, SLOTCAP, &slot_cap);
 	if (rc) {
-		err("%s: Cannot read SLOTCAP register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTCAP register\n", __func__);
 		return -1;
 	}
 
 	/* Mask Hot-plug Interrupt Enable */
 	rc = pciehp_readw(ctrl, SLOTCTRL, &temp_word);
 	if (rc) {
-		err("%s: Cannot read SLOTCTRL register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTCTRL register\n", __func__);
 		return -1;
 	}
 
 	dbg("%s: SLOTCTRL %x value read %x\n",
-	    __FUNCTION__, ctrl->cap_base + SLOTCTRL, temp_word);
+	    __func__, ctrl->cap_base + SLOTCTRL, temp_word);
 	temp_word = (temp_word & ~HP_INTR_ENABLE & ~CMD_CMPL_INTR_ENABLE) |
 		0x00;
 
 	rc = pciehp_writew(ctrl, SLOTCTRL, temp_word);
 	if (rc) {
-		err("%s: Cannot write to SLOTCTRL register\n", __FUNCTION__);
+		err("%s: Cannot write to SLOTCTRL register\n", __func__);
 		return -1;
 	}
 
 	rc = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 	if (rc) {
-		err("%s: Cannot read SLOTSTATUS register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTSTATUS register\n", __func__);
 		return -1;
 	}
 
 	temp_word = 0x1F; /* Clear all events */
 	rc = pciehp_writew(ctrl, SLOTSTATUS, temp_word);
 	if (rc) {
-		err("%s: Cannot write to SLOTSTATUS register\n", __FUNCTION__);
+		err("%s: Cannot write to SLOTSTATUS register\n", __func__);
 		return -1;
 	}
 	return 0;
@@ -1176,7 +1176,7 @@ int pcie_init_hardware_part2(struct controller *ctrl, struct pcie_device *dev)
 
 	rc = pciehp_readw(ctrl, SLOTCTRL, &temp_word);
 	if (rc) {
-		err("%s: Cannot read SLOTCTRL register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTCTRL register\n", __func__);
 		goto abort;
 	}
 
@@ -1184,7 +1184,7 @@ int pcie_init_hardware_part2(struct controller *ctrl, struct pcie_device *dev)
 
 	rc = pciehp_readl(ctrl, SLOTCAP, &slot_cap);
 	if (rc) {
-		err("%s: Cannot read SLOTCAP register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTCAP register\n", __func__);
 		goto abort;
 	}
 
@@ -1211,19 +1211,19 @@ int pcie_init_hardware_part2(struct controller *ctrl, struct pcie_device *dev)
 	 */
 	rc = pciehp_writew(ctrl, SLOTCTRL, temp_word);
 	if (rc) {
-		err("%s: Cannot write to SLOTCTRL register\n", __FUNCTION__);
+		err("%s: Cannot write to SLOTCTRL register\n", __func__);
 		goto abort;
 	}
 	rc = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 	if (rc) {
-		err("%s: Cannot read SLOTSTATUS register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTSTATUS register\n", __func__);
 		goto abort_disable_intr;
 	}
 
 	temp_word =  0x1F; /* Clear all events */
 	rc = pciehp_writew(ctrl, SLOTSTATUS, temp_word);
 	if (rc) {
-		err("%s: Cannot write to SLOTSTATUS register\n", __FUNCTION__);
+		err("%s: Cannot write to SLOTSTATUS register\n", __func__);
 		goto abort_disable_intr;
 	}
 
@@ -1246,7 +1246,7 @@ abort_disable_intr:
 		rc = pciehp_writew(ctrl, SLOTCTRL, temp_word);
 	}
 	if (rc)
-		err("%s : disabling interrupts failed\n", __FUNCTION__);
+		err("%s : disabling interrupts failed\n", __func__);
 abort:
 	return -1;
 }
@@ -1264,62 +1264,62 @@ int pcie_init(struct controller *ctrl, struct pcie_device *dev)
 	ctrl->pci_dev = pdev;	/* save pci_dev in context */
 
 	dbg("%s: hotplug controller vendor id 0x%x device id 0x%x\n",
-			__FUNCTION__, pdev->vendor, pdev->device);
+			__func__, pdev->vendor, pdev->device);
 
 	cap_base = pci_find_capability(pdev, PCI_CAP_ID_EXP);
 	if (cap_base == 0) {
-		dbg("%s: Can't find PCI_CAP_ID_EXP (0x10)\n", __FUNCTION__);
+		dbg("%s: Can't find PCI_CAP_ID_EXP (0x10)\n", __func__);
 		goto abort;
 	}
 
 	ctrl->cap_base = cap_base;
 
-	dbg("%s: pcie_cap_base %x\n", __FUNCTION__, cap_base);
+	dbg("%s: pcie_cap_base %x\n", __func__, cap_base);
 
 	rc = pciehp_readw(ctrl, CAPREG, &cap_reg);
 	if (rc) {
-		err("%s: Cannot read CAPREG register\n", __FUNCTION__);
+		err("%s: Cannot read CAPREG register\n", __func__);
 		goto abort;
 	}
 	dbg("%s: CAPREG offset %x cap_reg %x\n",
-	    __FUNCTION__, ctrl->cap_base + CAPREG, cap_reg);
+	    __func__, ctrl->cap_base + CAPREG, cap_reg);
 
 	if (((cap_reg & SLOT_IMPL) == 0) ||
 	    (((cap_reg & DEV_PORT_TYPE) != 0x0040)
 		&& ((cap_reg & DEV_PORT_TYPE) != 0x0060))) {
 		dbg("%s : This is not a root port or the port is not "
-		    "connected to a slot\n", __FUNCTION__);
+		    "connected to a slot\n", __func__);
 		goto abort;
 	}
 
 	rc = pciehp_readl(ctrl, SLOTCAP, &slot_cap);
 	if (rc) {
-		err("%s: Cannot read SLOTCAP register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTCAP register\n", __func__);
 		goto abort;
 	}
 	dbg("%s: SLOTCAP offset %x slot_cap %x\n",
-	    __FUNCTION__, ctrl->cap_base + SLOTCAP, slot_cap);
+	    __func__, ctrl->cap_base + SLOTCAP, slot_cap);
 
 	if (!(slot_cap & HP_CAP)) {
-		dbg("%s : This slot is not hot-plug capable\n", __FUNCTION__);
+		dbg("%s : This slot is not hot-plug capable\n", __func__);
 		goto abort;
 	}
 	/* For debugging purpose */
 	rc = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 	if (rc) {
-		err("%s: Cannot read SLOTSTATUS register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTSTATUS register\n", __func__);
 		goto abort;
 	}
 	dbg("%s: SLOTSTATUS offset %x slot_status %x\n",
-	    __FUNCTION__, ctrl->cap_base + SLOTSTATUS, slot_status);
+	    __func__, ctrl->cap_base + SLOTSTATUS, slot_status);
 
 	rc = pciehp_readw(ctrl, SLOTCTRL, &slot_ctrl);
 	if (rc) {
-		err("%s: Cannot read SLOTCTRL register\n", __FUNCTION__);
+		err("%s: Cannot read SLOTCTRL register\n", __func__);
 		goto abort;
 	}
 	dbg("%s: SLOTCTRL offset %x slot_ctrl %x\n",
-	    __FUNCTION__, ctrl->cap_base + SLOTCTRL, slot_ctrl);
+	    __func__, ctrl->cap_base + SLOTCTRL, slot_ctrl);
 
 	for (rc = 0; rc < DEVICE_COUNT_RESOURCE; rc++)
 		if (pci_resource_len(pdev, rc) > 0)
@@ -1357,7 +1357,7 @@ int pcie_init(struct controller *ctrl, struct pcie_device *dev)
 		rc = request_irq(ctrl->pci_dev->irq, pcie_isr, IRQF_SHARED,
 				 MY_NAME, (void *)ctrl);
 		dbg("%s: request_irq %d for hpc%d (returns %d)\n",
-		    __FUNCTION__, ctrl->pci_dev->irq,
+		    __func__, ctrl->pci_dev->irq,
 		    atomic_read(&pciehp_num_controllers), rc);
 		if (rc) {
 			err("Can't get irq %d for the hotplug controller\n",
diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
index dd50713..7386a34 100644
--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -40,7 +40,7 @@ static void program_hpp_type0(struct pci_dev *dev, struct hpp_type0 *hpp)
 
 	if (hpp->revision > 1) {
 		printk(KERN_WARNING "%s: Rev.%d type0 record not supported\n",
-		       __FUNCTION__, hpp->revision);
+		       __func__, hpp->revision);
 		return;
 	}
 
@@ -82,7 +82,7 @@ static void program_hpp_type2(struct pci_dev *dev, struct hpp_type2 *hpp)
 
 	if (hpp->revision > 1) {
 		printk(KERN_WARNING "%s: Rev.%d type2 record not supported\n",
-		       __FUNCTION__, hpp->revision);
+		       __func__, hpp->revision);
 		return;
 	}
 
@@ -150,7 +150,7 @@ static void program_fw_provided_values(struct pci_dev *dev)
 
 	if (pciehp_get_hp_params_from_firmware(dev, &hpp)) {
 		printk(KERN_WARNING "%s: Could not get hotplug parameters\n",
-		       __FUNCTION__);
+		       __func__);
 		return;
 	}
 
@@ -245,7 +245,7 @@ int pciehp_unconfigure_device(struct slot *p_slot)
 	struct pci_bus *parent = p_slot->ctrl->pci_dev->subordinate;
 	u16 command;
 
-	dbg("%s: bus/dev = %x/%x\n", __FUNCTION__, p_slot->bus,
+	dbg("%s: bus/dev = %x/%x\n", __func__, p_slot->bus,
 				p_slot->device);
 	ret = p_slot->hpc_ops->get_adapter_status(p_slot, &presence);
 	if (ret)
diff --git a/drivers/pci/hotplug/pcihp_skeleton.c b/drivers/pci/hotplug/pcihp_skeleton.c
index 50bcd3f..e3dd6cf 100644
--- a/drivers/pci/hotplug/pcihp_skeleton.c
+++ b/drivers/pci/hotplug/pcihp_skeleton.c
@@ -98,7 +98,7 @@ static int enable_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	/*
 	 * Fill in code here to enable the specified slot
@@ -112,7 +112,7 @@ static int disable_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	/*
 	 * Fill in code here to disable the specified slot
@@ -126,7 +126,7 @@ static int set_attention_status(struct hotplug_slot *hotplug_slot, u8 status)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	switch (status) {
 		case 0:
@@ -151,7 +151,7 @@ static int hardware_test(struct hotplug_slot *hotplug_slot, u32 value)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	switch (value) {
 		case 0:
@@ -170,7 +170,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	/*
 	 * Fill in logic to get the current power status of the specific
@@ -185,7 +185,7 @@ static int get_attention_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	/*
 	 * Fill in logic to get the current attention status of the specific
@@ -200,7 +200,7 @@ static int get_latch_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	/*
 	 * Fill in logic to get the current latch status of the specific
@@ -215,7 +215,7 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	/*
 	 * Fill in logic to get the current adapter status of the specific
@@ -229,7 +229,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 	kfree(slot->hotplug_slot->info);
 	kfree(slot->hotplug_slot);
 	kfree(slot);
diff --git a/drivers/pci/hotplug/rpadlpar_core.c b/drivers/pci/hotplug/rpadlpar_core.c
index 191954b..9c2a22f 100644
--- a/drivers/pci/hotplug/rpadlpar_core.c
+++ b/drivers/pci/hotplug/rpadlpar_core.c
@@ -147,7 +147,7 @@ static void dlpar_pci_add_bus(struct device_node *dn)
 	dev = of_create_pci_dev(dn, phb->bus, pdn->devfn);
 	if (!dev) {
 		printk(KERN_ERR "%s: failed to create pci dev for %s\n",
-				__FUNCTION__, dn->full_name);
+				__func__, dn->full_name);
 		return;
 	}
 
@@ -183,21 +183,21 @@ static int dlpar_add_pci_slot(char *drc_name, struct device_node *dn)
 	dev = dlpar_find_new_dev(phb->bus, dn);
 
 	if (!dev) {
-		printk(KERN_ERR "%s: unable to add bus %s\n", __FUNCTION__,
+		printk(KERN_ERR "%s: unable to add bus %s\n", __func__,
 			drc_name);
 		return -EIO;
 	}
 
 	if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
 		printk(KERN_ERR "%s: unexpected header type %d, unable to add bus %s\n",
-			__FUNCTION__, dev->hdr_type, drc_name);
+			__func__, dev->hdr_type, drc_name);
 		return -EIO;
 	}
 
 	/* Add hotplug slot */
 	if (rpaphp_add_slot(dn)) {
 		printk(KERN_ERR "%s: unable to add hotplug slot %s\n",
-			__FUNCTION__, drc_name);
+			__func__, drc_name);
 		return -EIO;
 	}
 	return 0;
@@ -239,7 +239,7 @@ static int dlpar_remove_phb(char *drc_name, struct device_node *dn)
 		if (rpaphp_deregister_slot(slot)) {
 			printk(KERN_ERR
 				"%s: unable to remove hotplug slot %s\n",
-				__FUNCTION__, drc_name);
+				__func__, drc_name);
 			return -EIO;
 		}
 	}
@@ -270,7 +270,7 @@ static int dlpar_add_phb(char *drc_name, struct device_node *dn)
 
 	if (rpaphp_add_slot(dn)) {
 		printk(KERN_ERR "%s: unable to add hotplug slot %s\n",
-			__FUNCTION__, drc_name);
+			__func__, drc_name);
 		return -EIO;
 	}
 	return 0;
@@ -284,7 +284,7 @@ static int dlpar_add_vio_slot(char *drc_name, struct device_node *dn)
 	if (!vio_register_device_node(dn)) {
 		printk(KERN_ERR
 			"%s: failed to register vio node %s\n",
-			__FUNCTION__, drc_name);
+			__func__, drc_name);
 		return -EIO;
 	}
 	return 0;
@@ -384,7 +384,7 @@ int dlpar_remove_pci_slot(char *drc_name, struct device_node *dn)
 		if (rpaphp_deregister_slot(slot)) {
 			printk(KERN_ERR
 				"%s: unable to remove hotplug slot %s\n",
-				__FUNCTION__, drc_name);
+				__func__, drc_name);
 			return -EIO;
 		}
 	} else
@@ -392,7 +392,7 @@ int dlpar_remove_pci_slot(char *drc_name, struct device_node *dn)
 
 	if (pcibios_unmap_io_space(bus)) {
 		printk(KERN_ERR "%s: failed to unmap bus range\n",
-			__FUNCTION__);
+			__func__);
 		return -ERANGE;
 	}
 
@@ -458,7 +458,7 @@ int __init rpadlpar_io_init(void)
 
 	if (!is_dlpar_capable()) {
 		printk(KERN_WARNING "%s: partition not DLPAR capable\n",
-			__FUNCTION__);
+			__func__);
 		return -EPERM;
 	}
 
diff --git a/drivers/pci/hotplug/rpaphp_core.c b/drivers/pci/hotplug/rpaphp_core.c
index 58f1a99..1f84f40 100644
--- a/drivers/pci/hotplug/rpaphp_core.c
+++ b/drivers/pci/hotplug/rpaphp_core.c
@@ -317,7 +317,7 @@ int rpaphp_add_slot(struct device_node *dn)
 	if (!is_php_dn(dn, &indexes, &names, &types, &power_domains))
 		return 0;
 
-	dbg("Entry %s: dn->full_name=%s\n", __FUNCTION__, dn->full_name);
+	dbg("Entry %s: dn->full_name=%s\n", __func__, dn->full_name);
 
 	/* register PCI devices */
 	name = (char *) &names[1];
@@ -343,7 +343,7 @@ int rpaphp_add_slot(struct device_node *dn)
 		name += strlen(name) + 1;
 		type += strlen(type) + 1;
 	}
-	dbg("%s - Exit: rc[%d]\n", __FUNCTION__, retval);
+	dbg("%s - Exit: rc[%d]\n", __func__, retval);
 
 	/* XXX FIXME: reports a failure only if last entry in loop failed */
 	return retval;
@@ -404,7 +404,7 @@ static int enable_slot(struct hotplug_slot *hotplug_slot)
 	} else if (state == EMPTY) {
 		slot->state = EMPTY;
 	} else {
-		err("%s: slot[%s] is in invalid state\n", __FUNCTION__, slot->name);
+		err("%s: slot[%s] is in invalid state\n", __func__, slot->name);
 		slot->state = NOT_VALID;
 		return -EINVAL;
 	}
diff --git a/drivers/pci/hotplug/rpaphp_pci.c b/drivers/pci/hotplug/rpaphp_pci.c
index 6571e9b..5acfd4f 100644
--- a/drivers/pci/hotplug/rpaphp_pci.c
+++ b/drivers/pci/hotplug/rpaphp_pci.c
@@ -42,7 +42,7 @@ int rpaphp_get_sensor_state(struct slot *slot, int *state)
 	if (rc < 0) {
 		if (rc == -EFAULT || rc == -EEXIST) {
 			dbg("%s: slot must be power up to get sensor-state\n",
-			    __FUNCTION__);
+			    __func__);
 
 			/* some slots have to be powered up 
 			 * before get-sensor will succeed.
@@ -51,15 +51,15 @@ int rpaphp_get_sensor_state(struct slot *slot, int *state)
 						  &setlevel);
 			if (rc < 0) {
 				dbg("%s: power on slot[%s] failed rc=%d.\n",
-				    __FUNCTION__, slot->name, rc);
+				    __func__, slot->name, rc);
 			} else {
 				rc = rtas_get_sensor(DR_ENTITY_SENSE,
 						     slot->index, state);
 			}
 		} else if (rc == -ENODEV)
-			info("%s: slot is unusable\n", __FUNCTION__);
+			info("%s: slot is unusable\n", __func__);
 		else
-			err("%s failed to get sensor state\n", __FUNCTION__);
+			err("%s failed to get sensor state\n", __func__);
 	}
 	return rc;
 }
@@ -95,7 +95,7 @@ int rpaphp_enable_slot(struct slot *slot)
 
 	bus = pcibios_find_pci_bus(slot->dn);
 	if (!bus) {
-		err("%s: no pci_bus for dn %s\n", __FUNCTION__, slot->dn->full_name);
+		err("%s: no pci_bus for dn %s\n", __func__, slot->dn->full_name);
 		return -EINVAL;
 	}
 
@@ -111,7 +111,7 @@ int rpaphp_enable_slot(struct slot *slot)
 		/* non-empty slot has to have child */
 		if (!slot->dn->child) {
 			err("%s: slot[%s]'s device_node doesn't have child for adapter\n",
-			    __FUNCTION__, slot->name);
+			    __func__, slot->name);
 			return -EINVAL;
 		}
 
@@ -125,7 +125,7 @@ int rpaphp_enable_slot(struct slot *slot)
 
 		if (debug) {
 			struct pci_dev *dev;
-			dbg("%s: pci_devs of slot[%s]\n", __FUNCTION__, slot->dn->full_name);
+			dbg("%s: pci_devs of slot[%s]\n", __func__, slot->dn->full_name);
 			list_for_each_entry (dev, &bus->devices, bus_list)
 				dbg("\t%s\n", pci_name(dev));
 		}
diff --git a/drivers/pci/hotplug/rpaphp_slot.c b/drivers/pci/hotplug/rpaphp_slot.c
index 8ad3deb..eab96f8 100644
--- a/drivers/pci/hotplug/rpaphp_slot.c
+++ b/drivers/pci/hotplug/rpaphp_slot.c
@@ -131,7 +131,7 @@ int rpaphp_deregister_slot(struct slot *slot)
 	struct hotplug_slot *php_slot = slot->hotplug_slot;
 
 	 dbg("%s - Entry: deregistering slot=%s\n",
-		__FUNCTION__, slot->name);
+		__func__, slot->name);
 
 	list_del(&slot->rpaphp_slot_list);
 	
@@ -142,7 +142,7 @@ int rpaphp_deregister_slot(struct slot *slot)
 	if (retval)
 		err("Problem unregistering a slot %s\n", slot->name);
 
-	dbg("%s - Exit: rc[%d]\n", __FUNCTION__, retval);
+	dbg("%s - Exit: rc[%d]\n", __func__, retval);
 	return retval;
 }
 EXPORT_SYMBOL_GPL(rpaphp_deregister_slot);
@@ -153,7 +153,7 @@ int rpaphp_register_slot(struct slot *slot)
 	int retval;
 
 	dbg("%s registering slot:path[%s] index[%x], name[%s] pdomain[%x] type[%d]\n", 
-		__FUNCTION__, slot->dn->full_name, slot->index, slot->name, 
+		__func__, slot->dn->full_name, slot->index, slot->name, 
 		slot->power_domain, slot->type);
 
 	/* should not try to register the same slot twice */
diff --git a/drivers/pci/hotplug/sgi_hotplug.c b/drivers/pci/hotplug/sgi_hotplug.c
index ef07c36..2fe37cd 100644
--- a/drivers/pci/hotplug/sgi_hotplug.c
+++ b/drivers/pci/hotplug/sgi_hotplug.c
@@ -367,7 +367,7 @@ static int enable_slot(struct hotplug_slot *bss_hotplug_slot)
 		ret = acpi_load_table((struct acpi_table_header *)ssdt);
 		if (ACPI_FAILURE(ret)) {
 			printk(KERN_ERR "%s: acpi_load_table failed (0x%x)\n",
-			       __FUNCTION__, ret);
+			       __func__, ret);
 			/* try to continue on */
 		}
 	}
@@ -459,7 +459,7 @@ static int enable_slot(struct hotplug_slot *bss_hotplug_slot)
 				if (ACPI_FAILURE(ret)) {
 					printk(KERN_ERR "%s: acpi_bus_add "
 					       "failed (0x%x) for slot %d "
-					       "func %d\n", __FUNCTION__,
+					       "func %d\n", __func__,
 					       ret, (int)(adr>>16),
 					       (int)(adr&0xffff));
 					/* try to continue on */
@@ -570,7 +570,7 @@ static int disable_slot(struct hotplug_slot *bss_hotplug_slot)
 		if (ACPI_FAILURE(ret)) {
 			printk(KERN_ERR "%s: acpi_unload_table_id "
 			       "failed (0x%x) for id %d\n",
-			       __FUNCTION__, ret, ssdt_id);
+			       __func__, ret, ssdt_id);
 			/* try to continue on */
 		}
 	}
@@ -689,7 +689,7 @@ static int sn_pci_hotplug_init(void)
 
 	if (!sn_prom_feature_available(PRF_HOTPLUG_SUPPORT)) {
 		printk(KERN_ERR "%s: PROM version does not support hotplug.\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EPERM;
 	}
 
diff --git a/drivers/pci/hotplug/shpchp.h b/drivers/pci/hotplug/shpchp.h
index 37ed088..f66e8d6 100644
--- a/drivers/pci/hotplug/shpchp.h
+++ b/drivers/pci/hotplug/shpchp.h
@@ -234,7 +234,7 @@ static inline struct slot *shpchp_find_slot(struct controller *ctrl, u8 device)
 			return slot;
 	}
 
-	err("%s: slot (device=0x%x) not found\n", __FUNCTION__, device);
+	err("%s: slot (device=0x%x) not found\n", __func__, device);
 	return NULL;
 }
 
@@ -268,7 +268,7 @@ static inline void amd_pogo_errata_restore_misc_reg(struct slot *p_slot)
 	pci_read_config_dword(p_slot->ctrl->pci_dev, PCIX_MISC_BRIDGE_ERRORS_OFFSET, &pcix_bridge_errors_reg);
 	perr_set = pcix_bridge_errors_reg & PERR_OBSERVED_MASK;
 	if (perr_set) {
-		dbg ("%s  W1C: Bridge_Errors[ PERR_OBSERVED = %08X]\n",__FUNCTION__ , perr_set);
+		dbg ("%s  W1C: Bridge_Errors[ PERR_OBSERVED = %08X]\n",__func__ , perr_set);
 
 		pci_write_config_dword(p_slot->ctrl->pci_dev, PCIX_MISC_BRIDGE_ERRORS_OFFSET, perr_set);
 	}
@@ -277,7 +277,7 @@ static inline void amd_pogo_errata_restore_misc_reg(struct slot *p_slot)
 	pci_read_config_dword(p_slot->ctrl->pci_dev, PCIX_MEM_BASE_LIMIT_OFFSET, &pcix_mem_base_reg);
 	rse_set = pcix_mem_base_reg & RSE_MASK;
 	if (rse_set) {
-		dbg ("%s  W1C: Memory_Base_Limit[ RSE ]\n",__FUNCTION__ );
+		dbg ("%s  W1C: Memory_Base_Limit[ RSE ]\n",__func__ );
 
 		pci_write_config_dword(p_slot->ctrl->pci_dev, PCIX_MEM_BASE_LIMIT_OFFSET, rse_set);
 	}
diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index 80dec97..43816d4 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -91,7 +91,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	kfree(slot->hotplug_slot->info);
 	kfree(slot->hotplug_slot);
@@ -195,7 +195,7 @@ static int set_attention_status (struct hotplug_slot *hotplug_slot, u8 status)
 {
 	struct slot *slot = get_slot(hotplug_slot);
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	hotplug_slot->info->attention_status = status;
 	slot->hpc_ops->set_attention_status(slot, status);
@@ -207,7 +207,7 @@ static int enable_slot (struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = get_slot(hotplug_slot);
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	return shpchp_sysfs_enable_slot(slot);
 }
@@ -216,7 +216,7 @@ static int disable_slot (struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = get_slot(hotplug_slot);
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	return shpchp_sysfs_disable_slot(slot);
 }
@@ -226,7 +226,7 @@ static int get_power_status (struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = get_slot(hotplug_slot);
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	retval = slot->hpc_ops->get_power_status(slot, value);
 	if (retval < 0)
@@ -240,7 +240,7 @@ static int get_attention_status (struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = get_slot(hotplug_slot);
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	retval = slot->hpc_ops->get_attention_status(slot, value);
 	if (retval < 0)
@@ -254,7 +254,7 @@ static int get_latch_status (struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = get_slot(hotplug_slot);
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	retval = slot->hpc_ops->get_latch_status(slot, value);
 	if (retval < 0)
@@ -268,7 +268,7 @@ static int get_adapter_status (struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = get_slot(hotplug_slot);
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	retval = slot->hpc_ops->get_adapter_status(slot, value);
 	if (retval < 0)
@@ -282,7 +282,7 @@ static int get_address (struct hotplug_slot *hotplug_slot, u32 *value)
 	struct slot *slot = get_slot(hotplug_slot);
 	struct pci_bus *bus = slot->ctrl->pci_dev->subordinate;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	*value = (pci_domain_nr(bus) << 16) | (slot->bus << 8) | slot->device;
 
@@ -294,7 +294,7 @@ static int get_max_bus_speed (struct hotplug_slot *hotplug_slot, enum pci_bus_sp
 	struct slot *slot = get_slot(hotplug_slot);
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	retval = slot->hpc_ops->get_max_bus_speed(slot, value);
 	if (retval < 0)
@@ -308,7 +308,7 @@ static int get_cur_bus_speed (struct hotplug_slot *hotplug_slot, enum pci_bus_sp
 	struct slot *slot = get_slot(hotplug_slot);
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	retval = slot->hpc_ops->get_cur_bus_speed(slot, value);
 	if (retval < 0)
@@ -338,7 +338,7 @@ static int shpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
 	if (!ctrl) {
-		err("%s : out of memory\n", __FUNCTION__);
+		err("%s : out of memory\n", __func__);
 		goto err_out_none;
 	}
 	INIT_LIST_HEAD(&ctrl->slot_list);
@@ -402,7 +402,7 @@ static int __init shpcd_init(void)
 	int retval = 0;
 
 	retval = pci_register_driver(&shpc_driver);
-	dbg("%s: pci_register_driver = %d\n", __FUNCTION__, retval);
+	dbg("%s: pci_register_driver = %d\n", __func__, retval);
 	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	return retval;
 }
diff --git a/drivers/pci/hotplug/shpchp_ctrl.c b/drivers/pci/hotplug/shpchp_ctrl.c
index eb5cac6..dfb5393 100644
--- a/drivers/pci/hotplug/shpchp_ctrl.c
+++ b/drivers/pci/hotplug/shpchp_ctrl.c
@@ -91,7 +91,7 @@ u8 shpchp_handle_switch_change(u8 hp_slot, struct controller *ctrl)
 	p_slot = shpchp_find_slot(ctrl, hp_slot + ctrl->slot_device_offset);
 	p_slot->hpc_ops->get_adapter_status(p_slot, &(p_slot->presence_save));
 	p_slot->hpc_ops->get_latch_status(p_slot, &getstatus);
-	dbg("%s: Card present %x Power status %x\n", __FUNCTION__,
+	dbg("%s: Card present %x Power status %x\n", __func__,
 		p_slot->presence_save, p_slot->pwr_save);
 
 	if (getstatus) {
@@ -191,10 +191,10 @@ static int change_bus_speed(struct controller *ctrl, struct slot *p_slot,
 {
 	int rc = 0;
 
-	dbg("%s: change to speed %d\n", __FUNCTION__, speed);
+	dbg("%s: change to speed %d\n", __func__, speed);
 	if ((rc = p_slot->hpc_ops->set_bus_speed_mode(p_slot, speed))) {
 		err("%s: Issue of set bus speed mode command failed\n",
-		    __FUNCTION__);
+		    __func__);
 		return WRONG_BUS_FREQUENCY;
 	}
 	return rc;
@@ -213,7 +213,7 @@ static int fix_bus_speed(struct controller *ctrl, struct slot *pslot,
 	if (flag) {
 		if (asp < bsp) {
 			err("%s: speed of bus %x and adapter %x mismatch\n",
-			    __FUNCTION__, bsp, asp);
+			    __func__, bsp, asp);
 			rc = WRONG_BUS_FREQUENCY;
 		}
 		return rc;
@@ -247,13 +247,13 @@ static int board_added(struct slot *p_slot)
 	hp_slot = p_slot->device - ctrl->slot_device_offset;
 
 	dbg("%s: p_slot->device, slot_offset, hp_slot = %d, %d ,%d\n",
-			__FUNCTION__, p_slot->device,
+			__func__, p_slot->device,
 			ctrl->slot_device_offset, hp_slot);
 
 	/* Power on slot without connecting to bus */
 	rc = p_slot->hpc_ops->power_on_slot(p_slot);
 	if (rc) {
-		err("%s: Failed to power on slot\n", __FUNCTION__);
+		err("%s: Failed to power on slot\n", __func__);
 		return -1;
 	}
 
@@ -262,13 +262,13 @@ static int board_added(struct slot *p_slot)
 			return WRONG_BUS_FREQUENCY;
 
 		if ((rc = p_slot->hpc_ops->set_bus_speed_mode(p_slot, PCI_SPEED_33MHz))) {
-			err("%s: Issue of set bus speed mode command failed\n", __FUNCTION__);
+			err("%s: Issue of set bus speed mode command failed\n", __func__);
 			return WRONG_BUS_FREQUENCY;
 		}
 
 		/* turn on board, blink green LED, turn off Amber LED */
 		if ((rc = p_slot->hpc_ops->slot_enable(p_slot))) {
-			err("%s: Issue of Slot Enable command failed\n", __FUNCTION__);
+			err("%s: Issue of Slot Enable command failed\n", __func__);
 			return rc;
 		}
 	}
@@ -276,19 +276,19 @@ static int board_added(struct slot *p_slot)
 	rc = p_slot->hpc_ops->get_adapter_speed(p_slot, &asp);
 	if (rc) {
 		err("%s: Can't get adapter speed or bus mode mismatch\n",
-		    __FUNCTION__);
+		    __func__);
 		return WRONG_BUS_FREQUENCY;
 	}
 
 	rc = p_slot->hpc_ops->get_cur_bus_speed(p_slot, &bsp);
 	if (rc) {
-		err("%s: Can't get bus operation speed\n", __FUNCTION__);
+		err("%s: Can't get bus operation speed\n", __func__);
 		return WRONG_BUS_FREQUENCY;
 	}
 
 	rc = p_slot->hpc_ops->get_max_bus_speed(p_slot, &msp);
 	if (rc) {
-		err("%s: Can't get max bus operation speed\n", __FUNCTION__);
+		err("%s: Can't get max bus operation speed\n", __func__);
 		msp = bsp;
 	}
 
@@ -297,7 +297,7 @@ static int board_added(struct slot *p_slot)
 		slots_not_empty = 1;
 
 	dbg("%s: slots_not_empty %d, adapter_speed %d, bus_speed %d, "
-	    "max_bus_speed %d\n", __FUNCTION__, slots_not_empty, asp,
+	    "max_bus_speed %d\n", __func__, slots_not_empty, asp,
 	    bsp, msp);
 
 	rc = fix_bus_speed(ctrl, p_slot, slots_not_empty, asp, bsp, msp);
@@ -306,18 +306,18 @@ static int board_added(struct slot *p_slot)
 
 	/* turn on board, blink green LED, turn off Amber LED */
 	if ((rc = p_slot->hpc_ops->slot_enable(p_slot))) {
-		err("%s: Issue of Slot Enable command failed\n", __FUNCTION__);
+		err("%s: Issue of Slot Enable command failed\n", __func__);
 		return rc;
 	}
 
 	/* Wait for ~1 second */
 	msleep(1000);
 
-	dbg("%s: slot status = %x\n", __FUNCTION__, p_slot->status);
+	dbg("%s: slot status = %x\n", __func__, p_slot->status);
 	/* Check for a power fault */
 	if (p_slot->status == 0xFF) {
 		/* power fault occurred, but it was benign */
-		dbg("%s: power fault\n", __FUNCTION__);
+		dbg("%s: power fault\n", __func__);
 		rc = POWER_FAILURE;
 		p_slot->status = 0;
 		goto err_exit;
@@ -341,7 +341,7 @@ err_exit:
 	/* turn off slot, turn on Amber LED, turn off Green LED */
 	rc = p_slot->hpc_ops->slot_disable(p_slot);
 	if (rc) {
-		err("%s: Issue of Slot Disable command failed\n", __FUNCTION__);
+		err("%s: Issue of Slot Disable command failed\n", __func__);
 		return rc;
 	}
 
@@ -365,7 +365,7 @@ static int remove_board(struct slot *p_slot)
 	hp_slot = p_slot->device - ctrl->slot_device_offset;
 	p_slot = shpchp_find_slot(ctrl, hp_slot + ctrl->slot_device_offset);
 
-	dbg("In %s, hp_slot = %d\n", __FUNCTION__, hp_slot);
+	dbg("In %s, hp_slot = %d\n", __func__, hp_slot);
 
 	/* Change status to shutdown */
 	if (p_slot->is_a_board)
@@ -374,13 +374,13 @@ static int remove_board(struct slot *p_slot)
 	/* turn off slot, turn on Amber LED, turn off Green LED */
 	rc = p_slot->hpc_ops->slot_disable(p_slot);
 	if (rc) {
-		err("%s: Issue of Slot Disable command failed\n", __FUNCTION__);
+		err("%s: Issue of Slot Disable command failed\n", __func__);
 		return rc;
 	}
 
 	rc = p_slot->hpc_ops->set_attention_status(p_slot, 0);
 	if (rc) {
-		err("%s: Issue of Set Attention command failed\n", __FUNCTION__);
+		err("%s: Issue of Set Attention command failed\n", __func__);
 		return rc;
 	}
 
@@ -439,7 +439,7 @@ void shpchp_queue_pushbutton_work(struct work_struct *work)
 
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
-		err("%s: Cannot allocate memory\n", __FUNCTION__);
+		err("%s: Cannot allocate memory\n", __func__);
 		return;
 	}
 	info->p_slot = p_slot;
@@ -513,7 +513,7 @@ static void handle_button_press_event(struct slot *p_slot)
 		 * expires to cancel hot-add or hot-remove
 		 */
 		info("Button cancel on Slot(%s)\n", p_slot->name);
-		dbg("%s: button cancel\n", __FUNCTION__);
+		dbg("%s: button cancel\n", __func__);
 		cancel_delayed_work(&p_slot->work);
 		if (p_slot->state == BLINKINGOFF_STATE)
 			p_slot->hpc_ops->green_led_on(p_slot);
@@ -551,7 +551,7 @@ static void interrupt_event_handler(struct work_struct *work)
 		handle_button_press_event(p_slot);
 		break;
 	case INT_POWER_FAULT:
-		dbg("%s: power fault\n", __FUNCTION__);
+		dbg("%s: power fault\n", __func__);
 		p_slot->hpc_ops->set_attention_status(p_slot, 1);
 		p_slot->hpc_ops->green_led_off(p_slot);
 		break;
@@ -593,7 +593,7 @@ static int shpchp_enable_slot (struct slot *p_slot)
 	/* We have to save the presence info for these slots */
 	p_slot->hpc_ops->get_adapter_status(p_slot, &(p_slot->presence_save));
 	p_slot->hpc_ops->get_power_status(p_slot, &(p_slot->pwr_save));
-	dbg("%s: p_slot->pwr_save %x\n", __FUNCTION__, p_slot->pwr_save);
+	dbg("%s: p_slot->pwr_save %x\n", __func__, p_slot->pwr_save);
 	p_slot->hpc_ops->get_latch_status(p_slot, &getstatus);
 
 	if(((p_slot->ctrl->pci_dev->vendor == PCI_VENDOR_ID_AMD) ||
diff --git a/drivers/pci/hotplug/shpchp_hpc.c b/drivers/pci/hotplug/shpchp_hpc.c
index e8aa138..7d770b2 100644
--- a/drivers/pci/hotplug/shpchp_hpc.c
+++ b/drivers/pci/hotplug/shpchp_hpc.c
@@ -321,14 +321,14 @@ static int shpc_write_cmd(struct slot *slot, u8 t_slot, u8 cmd)
 	if (!shpc_poll_ctrl_busy(ctrl)) {
 		/* After 1 sec and and the controller is still busy */
 		err("%s : Controller is still busy after 1 sec.\n",
-		    __FUNCTION__);
+		    __func__);
 		retval = -EBUSY;
 		goto out;
 	}
 
 	++t_slot;
 	temp_word =  (t_slot << 8) | (cmd & 0xFF);
-	dbg("%s: t_slot %x cmd %x\n", __FUNCTION__, t_slot, cmd);
+	dbg("%s: t_slot %x cmd %x\n", __func__, t_slot, cmd);
 
 	/* To make sure the Controller Busy bit is 0 before we send out the
 	 * command.
@@ -345,7 +345,7 @@ static int shpc_write_cmd(struct slot *slot, u8 t_slot, u8 cmd)
 	cmd_status = hpc_check_cmd_status(slot->ctrl);
 	if (cmd_status) {
 		err("%s: Failed to issued command 0x%x (error code = %d)\n",
-		    __FUNCTION__, cmd, cmd_status);
+		    __func__, cmd, cmd_status);
 		retval = -EIO;
 	}
  out:
@@ -364,15 +364,15 @@ static int hpc_check_cmd_status(struct controller *ctrl)
 		break;
 	case 1:
 		retval = SWITCH_OPEN;
-		err("%s: Switch opened!\n", __FUNCTION__);
+		err("%s: Switch opened!\n", __func__);
 		break;
 	case 2:
 		retval = INVALID_CMD;
-		err("%s: Invalid HPC command!\n", __FUNCTION__);
+		err("%s: Invalid HPC command!\n", __func__);
 		break;
 	case 4:
 		retval = INVALID_SPEED_MODE;
-		err("%s: Invalid bus speed/mode!\n", __FUNCTION__);
+		err("%s: Invalid bus speed/mode!\n", __func__);
 		break;
 	default:
 		retval = cmd_status;
@@ -484,7 +484,7 @@ static int hpc_get_adapter_speed(struct slot *slot, enum pci_bus_speed *value)
 	}
 
 	dbg("%s: slot_reg = %x, pcix_cap = %x, m66_cap = %x\n",
-	    __FUNCTION__, slot_reg, pcix_cap, m66_cap);
+	    __func__, slot_reg, pcix_cap, m66_cap);
 
 	switch (pcix_cap) {
 	case 0x0:
@@ -629,7 +629,7 @@ static int hpc_power_on_slot(struct slot * slot)
 
 	retval = shpc_write_cmd(slot, slot->hp_slot, SET_SLOT_PWR);
 	if (retval)
-		err("%s: Write command failed!\n", __FUNCTION__);
+		err("%s: Write command failed!\n", __func__);
 
 	return retval;
 }
@@ -642,7 +642,7 @@ static int hpc_slot_enable(struct slot * slot)
 	retval = shpc_write_cmd(slot, slot->hp_slot,
 			SET_SLOT_ENABLE | SET_PWR_BLINK | SET_ATTN_OFF);
 	if (retval)
-		err("%s: Write command failed!\n", __FUNCTION__);
+		err("%s: Write command failed!\n", __func__);
 
 	return retval;
 }
@@ -655,7 +655,7 @@ static int hpc_slot_disable(struct slot * slot)
 	retval = shpc_write_cmd(slot, slot->hp_slot,
 			SET_SLOT_DISABLE | SET_PWR_OFF | SET_ATTN_ON);
 	if (retval)
-		err("%s: Write command failed!\n", __FUNCTION__);
+		err("%s: Write command failed!\n", __func__);
 
 	return retval;
 }
@@ -719,7 +719,7 @@ static int hpc_set_bus_speed_mode(struct slot * slot, enum pci_bus_speed value)
 
 	retval = shpc_write_cmd(slot, 0, cmd);
 	if (retval)
-		err("%s: Write command failed!\n", __FUNCTION__);
+		err("%s: Write command failed!\n", __func__);
 
 	return retval;
 }
@@ -735,7 +735,7 @@ static irqreturn_t shpc_isr(int irq, void *dev_id)
 	if (!intr_loc)
 		return IRQ_NONE;
 
-	dbg("%s: intr_loc = %x\n",__FUNCTION__, intr_loc);
+	dbg("%s: intr_loc = %x\n",__func__, intr_loc);
 
 	if(!shpchp_poll_mode) {
 		/*
@@ -748,7 +748,7 @@ static irqreturn_t shpc_isr(int irq, void *dev_id)
 		shpc_writel(ctrl, SERR_INTR_ENABLE, serr_int);
 
 		intr_loc2 = shpc_readl(ctrl, INTR_LOC);
-		dbg("%s: intr_loc2 = %x\n",__FUNCTION__, intr_loc2);
+		dbg("%s: intr_loc2 = %x\n",__func__, intr_loc2);
 	}
 
 	if (intr_loc & CMD_INTR_PENDING) {
@@ -774,7 +774,7 @@ static irqreturn_t shpc_isr(int irq, void *dev_id)
 
 		slot_reg = shpc_readl(ctrl, SLOT_REG(hp_slot));
 		dbg("%s: Slot %x with intr, slot register = %x\n",
-		    __FUNCTION__, hp_slot, slot_reg);
+		    __func__, hp_slot, slot_reg);
 
 		if (slot_reg & MRL_CHANGE_DETECTED)
 			shpchp_handle_switch_change(hp_slot, ctrl);
@@ -958,33 +958,33 @@ int shpc_init(struct controller *ctrl, struct pci_dev *pdev)
 	} else {
 		ctrl->cap_offset = pci_find_capability(pdev, PCI_CAP_ID_SHPC);
 		if (!ctrl->cap_offset) {
-			err("%s : cap_offset == 0\n", __FUNCTION__);
+			err("%s : cap_offset == 0\n", __func__);
 			goto abort;
 		}
-		dbg("%s: cap_offset = %x\n", __FUNCTION__, ctrl->cap_offset);
+		dbg("%s: cap_offset = %x\n", __func__, ctrl->cap_offset);
 
 		rc = shpc_indirect_read(ctrl, 0, &shpc_base_offset);
 		if (rc) {
-			err("%s: cannot read base_offset\n", __FUNCTION__);
+			err("%s: cannot read base_offset\n", __func__);
 			goto abort;
 		}
 
 		rc = shpc_indirect_read(ctrl, 3, &tempdword);
 		if (rc) {
-			err("%s: cannot read slot config\n", __FUNCTION__);
+			err("%s: cannot read slot config\n", __func__);
 			goto abort;
 		}
 		num_slots = tempdword & SLOT_NUM;
-		dbg("%s: num_slots (indirect) %x\n", __FUNCTION__, num_slots);
+		dbg("%s: num_slots (indirect) %x\n", __func__, num_slots);
 
 		for (i = 0; i < 9 + num_slots; i++) {
 			rc = shpc_indirect_read(ctrl, i, &tempdword);
 			if (rc) {
 				err("%s: cannot read creg (index = %d)\n",
-				    __FUNCTION__, i);
+				    __func__, i);
 				goto abort;
 			}
-			dbg("%s: offset %d: value %x\n", __FUNCTION__,i,
+			dbg("%s: offset %d: value %x\n", __func__,i,
 					tempdword);
 		}
 
@@ -998,25 +998,25 @@ int shpc_init(struct controller *ctrl, struct pci_dev *pdev)
 
 	rc = pci_enable_device(pdev);
 	if (rc) {
-		err("%s: pci_enable_device failed\n", __FUNCTION__);
+		err("%s: pci_enable_device failed\n", __func__);
 		goto abort;
 	}
 
 	if (!request_mem_region(ctrl->mmio_base, ctrl->mmio_size, MY_NAME)) {
-		err("%s: cannot reserve MMIO region\n", __FUNCTION__);
+		err("%s: cannot reserve MMIO region\n", __func__);
 		rc = -1;
 		goto abort;
 	}
 
 	ctrl->creg = ioremap(ctrl->mmio_base, ctrl->mmio_size);
 	if (!ctrl->creg) {
-		err("%s: cannot remap MMIO region %lx @ %lx\n", __FUNCTION__,
+		err("%s: cannot remap MMIO region %lx @ %lx\n", __func__,
 		    ctrl->mmio_size, ctrl->mmio_base);
 		release_mem_region(ctrl->mmio_base, ctrl->mmio_size);
 		rc = -1;
 		goto abort;
 	}
-	dbg("%s: ctrl->creg %p\n", __FUNCTION__, ctrl->creg);
+	dbg("%s: ctrl->creg %p\n", __func__, ctrl->creg);
 
 	mutex_init(&ctrl->crit_sect);
 	mutex_init(&ctrl->cmd_lock);
@@ -1035,20 +1035,20 @@ int shpc_init(struct controller *ctrl, struct pci_dev *pdev)
 
 	/* Mask Global Interrupt Mask & Command Complete Interrupt Mask */
 	tempdword = shpc_readl(ctrl, SERR_INTR_ENABLE);
-	dbg("%s: SERR_INTR_ENABLE = %x\n", __FUNCTION__, tempdword);
+	dbg("%s: SERR_INTR_ENABLE = %x\n", __func__, tempdword);
 	tempdword |= (GLOBAL_INTR_MASK  | GLOBAL_SERR_MASK |
 		      COMMAND_INTR_MASK | ARBITER_SERR_MASK);
 	tempdword &= ~SERR_INTR_RSVDZ_MASK;
 	shpc_writel(ctrl, SERR_INTR_ENABLE, tempdword);
 	tempdword = shpc_readl(ctrl, SERR_INTR_ENABLE);
-	dbg("%s: SERR_INTR_ENABLE = %x\n", __FUNCTION__, tempdword);
+	dbg("%s: SERR_INTR_ENABLE = %x\n", __func__, tempdword);
 
 	/* Mask the MRL sensor SERR Mask of individual slot in
 	 * Slot SERR-INT Mask & clear all the existing event if any
 	 */
 	for (hp_slot = 0; hp_slot < ctrl->num_slots; hp_slot++) {
 		slot_reg = shpc_readl(ctrl, SLOT_REG(hp_slot));
-		dbg("%s: Default Logical Slot Register %d value %x\n", __FUNCTION__,
+		dbg("%s: Default Logical Slot Register %d value %x\n", __func__,
 			hp_slot, slot_reg);
 		slot_reg |= (PRSNT_CHANGE_INTR_MASK | ISO_PFAULT_INTR_MASK |
 			     BUTTON_PRESS_INTR_MASK | MRL_CHANGE_INTR_MASK |
@@ -1073,7 +1073,7 @@ int shpc_init(struct controller *ctrl, struct pci_dev *pdev)
 		rc = request_irq(ctrl->pci_dev->irq, shpc_isr, IRQF_SHARED,
 				 MY_NAME, (void *)ctrl);
 		dbg("%s: request_irq %d for hpc%d (returns %d)\n",
-		    __FUNCTION__, ctrl->pci_dev->irq,
+		    __func__, ctrl->pci_dev->irq,
 		    atomic_read(&shpchp_num_controllers), rc);
 		if (rc) {
 			err("Can't get irq %d for the hotplug controller\n",
@@ -1081,7 +1081,7 @@ int shpc_init(struct controller *ctrl, struct pci_dev *pdev)
 			goto abort_iounmap;
 		}
 	}
-	dbg("%s: HPC at b:d:f:irq=0x%x:%x:%x:%x\n", __FUNCTION__,
+	dbg("%s: HPC at b:d:f:irq=0x%x:%x:%x:%x\n", __func__,
 			pdev->bus->number, PCI_SLOT(pdev->devfn),
 			PCI_FUNC(pdev->devfn), pdev->irq);
 	get_hp_hw_control_from_firmware(pdev);
@@ -1103,7 +1103,7 @@ int shpc_init(struct controller *ctrl, struct pci_dev *pdev)
 	 */
 	for (hp_slot = 0; hp_slot < ctrl->num_slots; hp_slot++) {
 		slot_reg = shpc_readl(ctrl, SLOT_REG(hp_slot));
-		dbg("%s: Default Logical Slot Register %d value %x\n", __FUNCTION__,
+		dbg("%s: Default Logical Slot Register %d value %x\n", __func__,
 			hp_slot, slot_reg);
 		slot_reg &= ~(PRSNT_CHANGE_INTR_MASK | ISO_PFAULT_INTR_MASK |
 			      BUTTON_PRESS_INTR_MASK | MRL_CHANGE_INTR_MASK |
@@ -1117,7 +1117,7 @@ int shpc_init(struct controller *ctrl, struct pci_dev *pdev)
 			       SERR_INTR_RSVDZ_MASK);
 		shpc_writel(ctrl, SERR_INTR_ENABLE, tempdword);
 		tempdword = shpc_readl(ctrl, SERR_INTR_ENABLE);
-		dbg("%s: SERR_INTR_ENABLE = %x\n", __FUNCTION__, tempdword);
+		dbg("%s: SERR_INTR_ENABLE = %x\n", __func__, tempdword);
 	}
 
 	return 0;
diff --git a/drivers/pci/hotplug/shpchp_pci.c b/drivers/pci/hotplug/shpchp_pci.c
index 0a6b25e..47d7cdf 100644
--- a/drivers/pci/hotplug/shpchp_pci.c
+++ b/drivers/pci/hotplug/shpchp_pci.c
@@ -51,7 +51,7 @@ static void program_fw_provided_values(struct pci_dev *dev)
 	    !hpp.t0 || (hpp.t0->revision > 1)) {
 		printk(KERN_WARNING
 		       "%s: Could not get hotplug parameters. Use defaults\n",
-		       __FUNCTION__);
+		       __func__);
 		hpp.t0 = &hpp.type0_data;
 		hpp.t0->revision = 0;
 		hpp.t0->cache_line_size = 8;
@@ -169,7 +169,7 @@ int shpchp_unconfigure_device(struct slot *p_slot)
 	u8 bctl = 0;
 	struct pci_bus *parent = p_slot->ctrl->pci_dev->subordinate;
 
-	dbg("%s: bus/dev = %x/%x\n", __FUNCTION__, p_slot->bus, p_slot->device);
+	dbg("%s: bus/dev = %x/%x\n", __func__, p_slot->bus, p_slot->device);
 
 	for (j=0; j<8 ; j++) {
 		struct pci_dev* temp = pci_get_slot(parent,
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 183fdda..2de449c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -442,7 +442,7 @@ pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 	 */
 	if (state != PCI_D0 && dev->current_state > state) {
 		printk(KERN_ERR "%s(): %s: state=%d, current state=%d\n",
-			__FUNCTION__, pci_name(dev), state, dev->current_state);
+			__func__, pci_name(dev), state, dev->current_state);
 		return -EINVAL;
 	} else if (dev->current_state == state)
 		return 0;        /* we're already there */
diff --git a/drivers/pci/pcie/aer/aerdrv.c b/drivers/pci/pcie/aer/aerdrv.c
index 7a62f7d..07c3bdb 100644
--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -220,7 +220,7 @@ static int __devinit aer_probe (struct pcie_device *dev,
 	/* Alloc rpc data structure */
 	if (!(rpc = aer_alloc_rpc(dev))) {
 		printk(KERN_DEBUG "%s: Alloc rpc fails on PCIE device[%s]\n",
-			__FUNCTION__, device->bus_id);
+			__func__, device->bus_id);
 		aer_remove(dev);
 		return -ENOMEM;
 	}
@@ -229,7 +229,7 @@ static int __devinit aer_probe (struct pcie_device *dev,
 	if ((status = request_irq(dev->irq, aer_irq, IRQF_SHARED, "aerdrv",
 				dev))) {
 		printk(KERN_DEBUG "%s: Request ISR fails on PCIE device[%s]\n",
-			__FUNCTION__, device->bus_id);
+			__func__, device->bus_id);
 		aer_remove(dev);
 		return status;
 	}
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 3c0d8d1..989df8a 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -689,7 +689,7 @@ static void aer_isr_one_error(struct pcie_device *p_device,
 			e_info.flags |= AER_MULTI_ERROR_VALID_FLAG;
 		if (!(s_device = find_source_device(p_device->port, id))) {
 			printk(KERN_DEBUG "%s->can't find device of ID%04x\n",
-				__FUNCTION__, id);
+				__func__, id);
 			continue;
 		}
 		if (get_device_error_info(to_pci_dev(s_device), &e_info) ==
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 23d9eb0..fb0abfa 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -150,7 +150,7 @@ static int assign_interrupt_mode(struct pci_dev *dev, int *vectors, int mask)
 	if (pos) {
 		struct msix_entry msix_entries[PCIE_PORT_DEVICE_MAXSERVICES] = 
 			{{0, 0}, {0, 1}, {0, 2}, {0, 3}};
-		printk("%s Found MSIX capability\n", __FUNCTION__);
+		printk("%s Found MSIX capability\n", __func__);
 		status = pci_enable_msix(dev, msix_entries, nvec);
 		if (!status) {
 			int j = 0;
@@ -165,7 +165,7 @@ static int assign_interrupt_mode(struct pci_dev *dev, int *vectors, int mask)
 	if (status) {
 		pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
 		if (pos) {
-			printk("%s Found MSI capability\n", __FUNCTION__);
+			printk("%s Found MSI capability\n", __func__);
 			status = pci_enable_msi(dev);
 			if (!status) {
 				interrupt_mode = PCIE_PORT_MSI_MODE;
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 26057f9..51d1632 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -93,7 +93,7 @@ static int __devinit pcie_portdrv_probe (struct pci_dev *dev,
         if (!dev->irq && dev->pin) {
 		printk(KERN_WARNING 
 		"%s->Dev[%04x:%04x] has invalid IRQ. Check vendor BIOS\n", 
-		__FUNCTION__, dev->vendor, dev->device);
+		__func__, dev->vendor, dev->device);
 	}
 	if (pcie_port_device_register(dev)) {
 		pci_disable_device(dev);
-- 
1.5.4.3.500.g83a2c


