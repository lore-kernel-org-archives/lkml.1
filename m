Return-Path: <linux-kernel-owner+w=401wt.eu-S1760807AbZCaPXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbZCaPXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762193AbZCaPXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:23:19 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:13990 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762015AbZCaPXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:23:15 -0400
Subject: [PATCH 01/15] PCI Hotplug: cpqphp: stray whitespace cleanups
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:23:11 -0600
Message-ID: <20090331152310.26622.57091.stgit@bob.kio>
In-Reply-To: <20090331150158.26622.45423.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up all stray whitespace issues, such as trailing whitespace,
spaces before tabs, etc. and whatever else vim's c_space_errors
highlights in red.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/cpqphp.h       |   58 ++++++++++++------------
 drivers/pci/hotplug/cpqphp_core.c  |   56 +++++++++--------------
 drivers/pci/hotplug/cpqphp_ctrl.c  |   86 ++++++++++++++++++------------------
 drivers/pci/hotplug/cpqphp_nvram.c |   18 ++++----
 drivers/pci/hotplug/cpqphp_pci.c   |   14 +++---
 5 files changed, 110 insertions(+), 122 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp.h b/drivers/pci/hotplug/cpqphp.h
index afaf8f6..b627dfd 100644
--- a/drivers/pci/hotplug/cpqphp.h
+++ b/drivers/pci/hotplug/cpqphp.h
@@ -150,25 +150,25 @@ struct ctrl_reg {			/* offset */
 
 /* offsets to the controller registers based on the above structure layout */
 enum ctrl_offsets {
-	SLOT_RST = 		offsetof(struct ctrl_reg, slot_RST),
+	SLOT_RST =		offsetof(struct ctrl_reg, slot_RST),
 	SLOT_ENABLE =		offsetof(struct ctrl_reg, slot_enable),
 	MISC =			offsetof(struct ctrl_reg, misc),
 	LED_CONTROL =		offsetof(struct ctrl_reg, led_control),
 	INT_INPUT_CLEAR =	offsetof(struct ctrl_reg, int_input_clear),
-	INT_MASK = 		offsetof(struct ctrl_reg, int_mask),
-	CTRL_RESERVED0 = 	offsetof(struct ctrl_reg, reserved0),
+	INT_MASK =		offsetof(struct ctrl_reg, int_mask),
+	CTRL_RESERVED0 =	offsetof(struct ctrl_reg, reserved0),
 	CTRL_RESERVED1 =	offsetof(struct ctrl_reg, reserved1),
 	CTRL_RESERVED2 =	offsetof(struct ctrl_reg, reserved1),
-	GEN_OUTPUT_AB = 	offsetof(struct ctrl_reg, gen_output_AB),
-	NON_INT_INPUT = 	offsetof(struct ctrl_reg, non_int_input),
+	GEN_OUTPUT_AB =		offsetof(struct ctrl_reg, gen_output_AB),
+	NON_INT_INPUT =		offsetof(struct ctrl_reg, non_int_input),
 	CTRL_RESERVED3 =	offsetof(struct ctrl_reg, reserved3),
 	CTRL_RESERVED4 =	offsetof(struct ctrl_reg, reserved4),
 	CTRL_RESERVED5 =	offsetof(struct ctrl_reg, reserved5),
 	CTRL_RESERVED6 =	offsetof(struct ctrl_reg, reserved6),
 	CTRL_RESERVED7 =	offsetof(struct ctrl_reg, reserved7),
 	CTRL_RESERVED8 =	offsetof(struct ctrl_reg, reserved8),
-	SLOT_MASK = 		offsetof(struct ctrl_reg, slot_mask),
-	CTRL_RESERVED9 = 	offsetof(struct ctrl_reg, reserved9),
+	SLOT_MASK =		offsetof(struct ctrl_reg, slot_mask),
+	CTRL_RESERVED9 =	offsetof(struct ctrl_reg, reserved9),
 	CTRL_RESERVED10 =	offsetof(struct ctrl_reg, reserved10),
 	CTRL_RESERVED11 =	offsetof(struct ctrl_reg, reserved11),
 	SLOT_SERR =		offsetof(struct ctrl_reg, slot_SERR),
@@ -220,15 +220,15 @@ struct slot_rt {
 /* offsets to the hotplug slot resource table registers based on the above structure layout */
 enum slot_rt_offsets {
 	DEV_FUNC =		offsetof(struct slot_rt, dev_func),
-	PRIMARY_BUS = 		offsetof(struct slot_rt, primary_bus),
-	SECONDARY_BUS = 	offsetof(struct slot_rt, secondary_bus),
-	MAX_BUS = 		offsetof(struct slot_rt, max_bus),
-	IO_BASE = 		offsetof(struct slot_rt, io_base),
-	IO_LENGTH = 		offsetof(struct slot_rt, io_length),
-	MEM_BASE = 		offsetof(struct slot_rt, mem_base),
-	MEM_LENGTH = 		offsetof(struct slot_rt, mem_length),
-	PRE_MEM_BASE = 		offsetof(struct slot_rt, pre_mem_base),
-	PRE_MEM_LENGTH = 	offsetof(struct slot_rt, pre_mem_length),
+	PRIMARY_BUS =		offsetof(struct slot_rt, primary_bus),
+	SECONDARY_BUS =		offsetof(struct slot_rt, secondary_bus),
+	MAX_BUS =		offsetof(struct slot_rt, max_bus),
+	IO_BASE =		offsetof(struct slot_rt, io_base),
+	IO_LENGTH =		offsetof(struct slot_rt, io_length),
+	MEM_BASE =		offsetof(struct slot_rt, mem_base),
+	MEM_LENGTH =		offsetof(struct slot_rt, mem_length),
+	PRE_MEM_BASE =		offsetof(struct slot_rt, pre_mem_base),
+	PRE_MEM_LENGTH =	offsetof(struct slot_rt, pre_mem_length),
 };
 
 struct pci_func {
@@ -471,7 +471,7 @@ static inline void return_resource(struct pci_resource **head, struct pci_resour
 static inline void set_SOGO(struct controller *ctrl)
 {
 	u16 misc;
-	
+
 	misc = readw(ctrl->hpc_reg + MISC);
 	misc = (misc | 0x0001) & 0xFFFB;
 	writew(misc, ctrl->hpc_reg + MISC);
@@ -481,7 +481,7 @@ static inline void set_SOGO(struct controller *ctrl)
 static inline void amber_LED_on(struct controller *ctrl, u8 slot)
 {
 	u32 led_control;
-	
+
 	led_control = readl(ctrl->hpc_reg + LED_CONTROL);
 	led_control |= (0x01010000L << slot);
 	writel(led_control, ctrl->hpc_reg + LED_CONTROL);
@@ -491,7 +491,7 @@ static inline void amber_LED_on(struct controller *ctrl, u8 slot)
 static inline void amber_LED_off(struct controller *ctrl, u8 slot)
 {
 	u32 led_control;
-	
+
 	led_control = readl(ctrl->hpc_reg + LED_CONTROL);
 	led_control &= ~(0x01010000L << slot);
 	writel(led_control, ctrl->hpc_reg + LED_CONTROL);
@@ -504,7 +504,7 @@ static inline int read_amber_LED(struct controller *ctrl, u8 slot)
 
 	led_control = readl(ctrl->hpc_reg + LED_CONTROL);
 	led_control &= (0x01010000L << slot);
-	
+
 	return led_control ? 1 : 0;
 }
 
@@ -512,7 +512,7 @@ static inline int read_amber_LED(struct controller *ctrl, u8 slot)
 static inline void green_LED_on(struct controller *ctrl, u8 slot)
 {
 	u32 led_control;
-	
+
 	led_control = readl(ctrl->hpc_reg + LED_CONTROL);
 	led_control |= 0x0101L << slot;
 	writel(led_control, ctrl->hpc_reg + LED_CONTROL);
@@ -521,7 +521,7 @@ static inline void green_LED_on(struct controller *ctrl, u8 slot)
 static inline void green_LED_off(struct controller *ctrl, u8 slot)
 {
 	u32 led_control;
-	
+
 	led_control = readl(ctrl->hpc_reg + LED_CONTROL);
 	led_control &= ~(0x0101L << slot);
 	writel(led_control, ctrl->hpc_reg + LED_CONTROL);
@@ -531,7 +531,7 @@ static inline void green_LED_off(struct controller *ctrl, u8 slot)
 static inline void green_LED_blink(struct controller *ctrl, u8 slot)
 {
 	u32 led_control;
-	
+
 	led_control = readl(ctrl->hpc_reg + LED_CONTROL);
 	led_control &= ~(0x0101L << slot);
 	led_control |= (0x0001L << slot);
@@ -586,11 +586,11 @@ static inline u8 read_slot_enable(struct controller *ctrl)
 static inline u8 get_controller_speed(struct controller *ctrl)
 {
 	u8 curr_freq;
- 	u16 misc;
- 	
+	u16 misc;
+
 	if (ctrl->pcix_support) {
 		curr_freq = readb(ctrl->hpc_reg + NEXT_CURR_FREQ);
-		if ((curr_freq & 0xB0) == 0xB0) 
+		if ((curr_freq & 0xB0) == 0xB0)
 			return PCI_SPEED_133MHz_PCIX;
 		if ((curr_freq & 0xA0) == 0xA0)
 			return PCI_SPEED_100MHz_PCIX;
@@ -602,10 +602,10 @@ static inline u8 get_controller_speed(struct controller *ctrl)
 		return PCI_SPEED_33MHz;
 	}
 
- 	misc = readw(ctrl->hpc_reg + MISC);
- 	return (misc & 0x0800) ? PCI_SPEED_66MHz : PCI_SPEED_33MHz;
+	misc = readw(ctrl->hpc_reg + MISC);
+	return (misc & 0x0800) ? PCI_SPEED_66MHz : PCI_SPEED_33MHz;
 }
- 
+
 
 /*
  * get_adapter_speed - find the max supported frequency/mode of adapter.
diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index c2e1bcb..55eae4c 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -25,7 +25,7 @@
  * Send feedback to <greg@kroah.com>
  *
  * Jan 12, 2003 -	Added 66/100/133MHz PCI-X support,
- * 			Torben Mathiasen <torben.mathiasen@hp.com>
+ *			Torben Mathiasen <torben.mathiasen@hp.com>
  *
  */
 
@@ -100,8 +100,8 @@ static struct hotplug_slot_ops cpqphp_hotplug_slot_ops = {
 	.get_attention_status =	get_attention_status,
 	.get_latch_status =	get_latch_status,
 	.get_adapter_status =	get_adapter_status,
-  	.get_max_bus_speed =	get_max_bus_speed,
-  	.get_cur_bus_speed =	get_cur_bus_speed,
+	.get_max_bus_speed =	get_max_bus_speed,
+	.get_cur_bus_speed =	get_cur_bus_speed,
 };
 
 
@@ -144,7 +144,7 @@ static void __iomem * detect_SMBIOS_pointer(void __iomem *begin, void __iomem *e
 			break;
 		}
 	}
-	
+
 	if (!status)
 		fp = NULL;
 
@@ -292,7 +292,7 @@ static void __iomem *get_SMBIOS_entry(void __iomem *smbios_start,
 	if (!smbios_table)
 		return NULL;
 
-	if (!previous) {		  
+	if (!previous) {
 		previous = smbios_start;
 	} else {
 		previous = get_subsequent_smbios_entry(smbios_start,
@@ -300,7 +300,7 @@ static void __iomem *get_SMBIOS_entry(void __iomem *smbios_start,
 	}
 
 	while (previous) {
-	       	if (readb(previous + SMBIOS_GENERIC_TYPE) != type) {
+		if (readb(previous + SMBIOS_GENERIC_TYPE) != type) {
 			previous = get_subsequent_smbios_entry(smbios_start,
 						smbios_table, previous);
 		} else {
@@ -426,7 +426,7 @@ static int ctrl_slot_setup(struct controller *ctrl,
 			cpq_get_latch_status(ctrl, slot);
 		hotplug_slot_info->adapter_status =
 			get_presence_status(ctrl, slot);
-		
+
 		dbg("registering bus %d, dev %d, number %d, "
 				"ctrl->slot_device_offset %d, slot %d\n",
 				slot->bus, slot->device,
@@ -440,7 +440,7 @@ static int ctrl_slot_setup(struct controller *ctrl,
 			err("pci_hp_register failed with error %d\n", result);
 			goto error_info;
 		}
-		
+
 		slot->next = ctrl->slot;
 		ctrl->slot = slot;
 
@@ -563,9 +563,9 @@ get_slot_mapping(struct pci_bus *bus, u8 bus_num, u8 dev_num, u8 *slot)
 
 	}
 
-	// If we got here, we didn't find an entry in the IRQ mapping table 
-	// for the target PCI device.  If we did determine that the target 
-	// device is on the other side of a PCI-to-PCI bridge, return the 
+	// If we got here, we didn't find an entry in the IRQ mapping table
+	// for the target PCI device.  If we did determine that the target
+	// device is on the other side of a PCI-to-PCI bridge, return the
 	// slot number for the bridge.
 	if (bridgeSlot != 0xFF) {
 		*slot = bridgeSlot;
@@ -719,7 +719,7 @@ static int hardware_test(struct hotplug_slot *hotplug_slot, u32 value)
 
 	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
-	return cpqhp_hardware_test(ctrl, value);	
+	return cpqhp_hardware_test(ctrl, value);
 }
 
 
@@ -738,7 +738,7 @@ static int get_attention_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
-	
+
 	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = cpq_get_attention_status(ctrl, slot);
@@ -832,7 +832,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Check for the proper subsytem ID's
-	 * Intel uses a different SSID programming model than Compaq.  
+	 * Intel uses a different SSID programming model than Compaq.
 	 * For Intel, each SSID bit identifies a PHP capability.
 	 * Also Intel HPC's may have RID=0.
 	 */
@@ -1087,7 +1087,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc) {
 		goto err_free_bus;
 	}
-	
+
 	dbg("pdev = %p\n", pdev);
 	dbg("pci resource start %llx\n", (unsigned long long)pci_resource_start(pdev, 0));
 	dbg("pci resource len %llx\n", (unsigned long long)pci_resource_len(pdev, 0));
@@ -1182,7 +1182,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			__func__, rc);
 		goto err_iounmap;
 	}
-	
+
 	/* Mask all general input interrupts */
 	writel(0xFFFFFFFFL, ctrl->hpc_reg + INT_MASK);
 
@@ -1291,7 +1291,6 @@ err_disable_device:
 	return rc;
 }
 
-
 static int one_time_init(void)
 {
 	int loop;
@@ -1328,10 +1327,10 @@ static int one_time_init(void)
 		retval = -EIO;
 		goto error;
 	}
-	
+
 	/* Now, map the int15 entry point if we are on compaq specific hardware */
 	compaq_nvram_init(cpqhp_rom_start);
-	
+
 	/* Map smbios table entry point structure */
 	smbios_table = detect_SMBIOS_pointer(cpqhp_rom_start,
 					cpqhp_rom_start + ROM_PHY_LEN);
@@ -1361,7 +1360,6 @@ error:
 	return retval;
 }
 
-
 static void __exit unload_cpqphpd(void)
 {
 	struct pci_func *next;
@@ -1381,10 +1379,10 @@ static void __exit unload_cpqphpd(void)
 		if (ctrl->hpc_reg) {
 			u16 misc;
 			rc = read_slot_enable (ctrl);
-			
+
 			writeb(0, ctrl->hpc_reg + SLOT_SERR);
 			writel(0xFFFFFFC0L | ~rc, ctrl->hpc_reg + INT_MASK);
-			
+
 			misc = readw(ctrl->hpc_reg + MISC);
 			misc &= 0xFFFD;
 			writew(misc, ctrl->hpc_reg + MISC);
@@ -1475,27 +1473,23 @@ static void __exit unload_cpqphpd(void)
 		iounmap(smbios_start);
 }
 
-
-
 static struct pci_device_id hpcd_pci_tbl[] = {
 	{
 	/* handle any PCI Hotplug controller */
 	.class =        ((PCI_CLASS_SYSTEM_PCI_HOTPLUG << 8) | 0x00),
 	.class_mask =   ~0,
-	
+
 	/* no matter who makes it */
 	.vendor =       PCI_ANY_ID,
 	.device =       PCI_ANY_ID,
 	.subvendor =    PCI_ANY_ID,
 	.subdevice =    PCI_ANY_ID,
-	
+
 	}, { /* end: all zeroes */ }
 };
 
 MODULE_DEVICE_TABLE(pci, hpcd_pci_tbl);
 
-
-
 static struct pci_driver cpqhpc_driver = {
 	.name =		"compaq_pci_hotplug",
 	.id_table =	hpcd_pci_tbl,
@@ -1503,8 +1497,6 @@ static struct pci_driver cpqhpc_driver = {
 	/* remove:	cpqhpc_remove_one, */
 };
 
-
-
 static int __init cpqhpc_init(void)
 {
 	int result;
@@ -1518,7 +1510,6 @@ static int __init cpqhpc_init(void)
 	return result;
 }
 
-
 static void __exit cpqhpc_cleanup(void)
 {
 	dbg("unload_cpqphpd()\n");
@@ -1529,8 +1520,5 @@ static void __exit cpqhpc_cleanup(void)
 	cpqhp_shutdown_debugfs();
 }
 
-
 module_init(cpqhpc_init);
 module_exit(cpqhpc_cleanup);
-
-
diff --git a/drivers/pci/hotplug/cpqphp_ctrl.c b/drivers/pci/hotplug/cpqphp_ctrl.c
index cc227a8..ec3a765 100644
--- a/drivers/pci/hotplug/cpqphp_ctrl.c
+++ b/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -642,7 +642,7 @@ static struct pci_resource *get_max_resource(struct pci_resource **head, u32 siz
 		return NULL;
 
 	for (max = *head; max; max = max->next) {
-		/* If not big enough we could probably just bail, 
+		/* If not big enough we could probably just bail,
 		 * instead we'll continue to the next. */
 		if (max->length < size)
 			continue;
@@ -886,7 +886,7 @@ irqreturn_t cpqhp_ctrl_intr(int IRQ, void *data)
 	u32 Diff;
 	u32 temp_dword;
 
-	
+
 	misc = readw(ctrl->hpc_reg + MISC);
 	/***************************************
 	 * Check to see if it was our interrupt
@@ -1130,33 +1130,33 @@ static u8 set_controller_speed(struct controller *ctrl, u8 adapter_speed, u8 hp_
 	u8 slot_power = readb(ctrl->hpc_reg + SLOT_POWER);
 	u16 reg16;
 	u32 leds = readl(ctrl->hpc_reg + LED_CONTROL);
-	
+
 	if (ctrl->speed == adapter_speed)
 		return 0;
-	
+
 	/* We don't allow freq/mode changes if we find another adapter running
 	 * in another slot on this controller */
 	for(slot = ctrl->slot; slot; slot = slot->next) {
-		if (slot->device == (hp_slot + ctrl->slot_device_offset)) 
+		if (slot->device == (hp_slot + ctrl->slot_device_offset))
 			continue;
 		if (!slot->hotplug_slot || !slot->hotplug_slot->info)
 			continue;
-		if (slot->hotplug_slot->info->adapter_status == 0) 
+		if (slot->hotplug_slot->info->adapter_status == 0)
 			continue;
 		/* If another adapter is running on the same segment but at a
 		 * lower speed/mode, we allow the new adapter to function at
 		 * this rate if supported */
-		if (ctrl->speed < adapter_speed) 
+		if (ctrl->speed < adapter_speed)
 			return 0;
 
 		return 1;
 	}
-	
+
 	/* If the controller doesn't support freq/mode changes and the
 	 * controller is running at a higher mode, we bail */
 	if ((ctrl->speed > adapter_speed) && (!ctrl->pcix_speed_capability))
 		return 1;
-	
+
 	/* But we allow the adapter to run at a lower rate if possible */
 	if ((ctrl->speed < adapter_speed) && (!ctrl->pcix_speed_capability))
 		return 0;
@@ -1171,22 +1171,22 @@ static u8 set_controller_speed(struct controller *ctrl, u8 adapter_speed, u8 hp_
 
 	writel(0x0L, ctrl->hpc_reg + LED_CONTROL);
 	writeb(0x00, ctrl->hpc_reg + SLOT_ENABLE);
-	
-	set_SOGO(ctrl); 
+
+	set_SOGO(ctrl);
 	wait_for_ctrl_irq(ctrl);
-	
+
 	if (adapter_speed != PCI_SPEED_133MHz_PCIX)
 		reg = 0xF5;
 	else
-		reg = 0xF4;	
+		reg = 0xF4;
 	pci_write_config_byte(ctrl->pci_dev, 0x41, reg);
-	
+
 	reg16 = readw(ctrl->hpc_reg + NEXT_CURR_FREQ);
 	reg16 &= ~0x000F;
 	switch(adapter_speed) {
-		case(PCI_SPEED_133MHz_PCIX): 
+		case(PCI_SPEED_133MHz_PCIX):
 			reg = 0x75;
-			reg16 |= 0xB; 
+			reg16 |= 0xB;
 			break;
 		case(PCI_SPEED_100MHz_PCIX):
 			reg = 0x74;
@@ -1203,47 +1203,47 @@ static u8 set_controller_speed(struct controller *ctrl, u8 adapter_speed, u8 hp_
 		default: /* 33MHz PCI 2.2 */
 			reg = 0x71;
 			break;
-			
+
 	}
 	reg16 |= 0xB << 12;
 	writew(reg16, ctrl->hpc_reg + NEXT_CURR_FREQ);
-	
-	mdelay(5); 
-	
+
+	mdelay(5);
+
 	/* Reenable interrupts */
 	writel(0, ctrl->hpc_reg + INT_MASK);
 
-	pci_write_config_byte(ctrl->pci_dev, 0x41, reg); 
-	
+	pci_write_config_byte(ctrl->pci_dev, 0x41, reg);
+
 	/* Restart state machine */
 	reg = ~0xF;
 	pci_read_config_byte(ctrl->pci_dev, 0x43, &reg);
 	pci_write_config_byte(ctrl->pci_dev, 0x43, reg);
-	
+
 	/* Only if mode change...*/
 	if (((ctrl->speed == PCI_SPEED_66MHz) && (adapter_speed == PCI_SPEED_66MHz_PCIX)) ||
 		((ctrl->speed == PCI_SPEED_66MHz_PCIX) && (adapter_speed == PCI_SPEED_66MHz))) 
 			set_SOGO(ctrl);
-	
+
 	wait_for_ctrl_irq(ctrl);
 	mdelay(1100);
-	
+
 	/* Restore LED/Slot state */
 	writel(leds, ctrl->hpc_reg + LED_CONTROL);
 	writeb(slot_power, ctrl->hpc_reg + SLOT_ENABLE);
-	
+
 	set_SOGO(ctrl);
 	wait_for_ctrl_irq(ctrl);
 
 	ctrl->speed = adapter_speed;
 	slot = cpqhp_find_slot(ctrl, hp_slot + ctrl->slot_device_offset);
 
-	info("Successfully changed frequency/mode for adapter in slot %d\n", 
+	info("Successfully changed frequency/mode for adapter in slot %d\n",
 			slot->number);
 	return 0;
 }
 
-/* the following routines constitute the bulk of the 
+/* the following routines constitute the bulk of the
    hotplug controller logic
  */
 
@@ -1299,7 +1299,7 @@ static u32 board_replaced(struct pci_func *func, struct controller *ctrl)
 
 		/* Wait for SOBS to be unset */
 		wait_for_ctrl_irq (ctrl);
-		
+
 		adapter_speed = get_adapter_speed(ctrl, hp_slot);
 		if (ctrl->speed != adapter_speed)
 			if (set_controller_speed(ctrl, adapter_speed, hp_slot))
@@ -1443,12 +1443,12 @@ static u32 board_added(struct pci_func *func, struct controller *ctrl)
 
 	/* Wait for SOBS to be unset */
 	wait_for_ctrl_irq (ctrl);
-	
+
 	adapter_speed = get_adapter_speed(ctrl, hp_slot);
 	if (ctrl->speed != adapter_speed)
 		if (set_controller_speed(ctrl, adapter_speed, hp_slot))
 			rc = WRONG_BUS_FREQUENCY;
-	
+
 	/* turn off board without attaching to the bus */
 	disable_slot_power (ctrl, hp_slot);
 
@@ -1461,7 +1461,7 @@ static u32 board_added(struct pci_func *func, struct controller *ctrl)
 
 	if (rc)
 		return rc;
-	
+
 	p_slot = cpqhp_find_slot(ctrl, hp_slot + ctrl->slot_device_offset);
 
 	/* turn on board and blink green LED */
@@ -1859,12 +1859,12 @@ static void interrupt_event_handler(struct controller *ctrl)
 						info(msg_button_on, p_slot->number);
 					}
 					mutex_lock(&ctrl->crit_sect);
-					
+
 					dbg("blink green LED and turn off amber\n");
-					
+
 					amber_LED_off (ctrl, hp_slot);
 					green_LED_blink (ctrl, hp_slot);
-					
+
 					set_SOGO(ctrl);
 
 					/* Wait for SOBS to be unset */
@@ -1958,7 +1958,7 @@ void cpqhp_pushbutton_thread(unsigned long slot)
 			if (cpqhp_process_SI(ctrl, func) != 0) {
 				amber_LED_on(ctrl, hp_slot);
 				green_LED_off(ctrl, hp_slot);
-				
+
 				set_SOGO(ctrl);
 
 				/* Wait for SOBS to be unset */
@@ -2079,7 +2079,7 @@ int cpqhp_process_SS(struct controller *ctrl, struct pci_func *func)
 	struct pci_bus *pci_bus = ctrl->pci_bus;
 	int physical_slot=0;
 
-	device = func->device; 
+	device = func->device;
 	func = cpqhp_slot_find(ctrl->bus, device, index++);
 	p_slot = cpqhp_find_slot(ctrl, device);
 	if (p_slot) {
@@ -2216,7 +2216,7 @@ int cpqhp_hardware_test(struct controller *ctrl, int test_num)
 				long_delay((3*HZ)/10);
 				work_LED = work_LED >> 16;
 				writel(work_LED, ctrl->hpc_reg + LED_CONTROL);
-				
+
 				set_SOGO(ctrl);
 
 				/* Wait for SOGO interrupt */
@@ -2339,7 +2339,7 @@ static u32 configure_new_device(struct controller * ctrl, struct pci_func * func
 
 
 /*
-  Configuration logic that involves the hotplug data structures and 
+  Configuration logic that involves the hotplug data structures and
   their bookkeeping
  */
 
@@ -2917,17 +2917,17 @@ static int configure_new_function(struct controller *ctrl, struct pci_func *func
 		}		/* End of base register loop */
 		if (cpqhp_legacy_mode) {
 			/* Figure out which interrupt pin this function uses */
-			rc = pci_bus_read_config_byte (pci_bus, devfn, 
+			rc = pci_bus_read_config_byte (pci_bus, devfn,
 				PCI_INTERRUPT_PIN, &temp_byte);
 
 			/* If this function needs an interrupt and we are behind
 			 * a bridge and the pin is tied to something that's
 			 * alread mapped, set this one the same */
-			if (temp_byte && resources->irqs && 
-			    (resources->irqs->valid_INT & 
+			if (temp_byte && resources->irqs &&
+			    (resources->irqs->valid_INT &
 			     (0x01 << ((temp_byte + resources->irqs->barber_pole - 1) & 0x03)))) {
 				/* We have to share with something already set up */
-				IRQ = resources->irqs->interrupt[(temp_byte + 
+				IRQ = resources->irqs->interrupt[(temp_byte +
 					resources->irqs->barber_pole - 1) & 0x03];
 			} else {
 				/* Program IRQ based on card type */
diff --git a/drivers/pci/hotplug/cpqphp_nvram.c b/drivers/pci/hotplug/cpqphp_nvram.c
index cb17488..76e110f 100644
--- a/drivers/pci/hotplug/cpqphp_nvram.c
+++ b/drivers/pci/hotplug/cpqphp_nvram.c
@@ -113,7 +113,7 @@ static u32 add_byte( u32 **p_buffer, u8 value, u32 *used, u32 *avail)
 
 	if ((*used + 1) > *avail)
 		return(1);
-	
+
 	*((u8*)*p_buffer) = value;
 	tByte = (u8**)p_buffer;
 	(*tByte)++;
@@ -170,10 +170,10 @@ static u32 access_EV (u16 operation, u8 *ev_name, u8 *buffer, u32 *buf_size)
 	unsigned long flags;
 	int op = operation;
 	int ret_val;
-	
+
 	if (!compaq_int15_entry_point)
 		return -ENODEV;
-	
+
 	spin_lock_irqsave(&int15_lock, flags);
 	__asm__ (
 		"xorl   %%ebx,%%ebx\n" \
@@ -187,7 +187,7 @@ static u32 access_EV (u16 operation, u8 *ev_name, u8 *buffer, u32 *buf_size)
 		"D" (buffer), "m" (compaq_int15_entry_point)
 		: "%ebx", "%edx");
 	spin_unlock_irqrestore(&int15_lock, flags);
-	
+
 	return((ret_val & 0xFF00) >> 8);
 }
 
@@ -263,7 +263,7 @@ static u32 store_HRT (void __iomem *rom_start)
 	p_EV_header = (struct ev_hrt_header *) pFill;
 
 	ctrl = cpqhp_ctrl_list;
-	
+
 	// The revision of this structure
 	rc = add_byte( &pFill, 1 + ctrl->push_flag, &usedbytes, &available);
 	if (rc)
@@ -401,7 +401,7 @@ static u32 store_HRT (void __iomem *rom_start)
 
 		ctrl = ctrl->next;
 	}
-	
+
 	p_EV_header->num_of_ctrl = numCtrl;
 
 	// Now store the EV
@@ -479,7 +479,7 @@ int compaq_nvram_load (void __iomem *rom_start, struct controller *ctrl)
 		function = p_ev_ctrl->function;
 
 		while ((bus != ctrl->bus) ||
-		       (device != PCI_SLOT(ctrl->pci_dev->devfn)) || 
+		       (device != PCI_SLOT(ctrl->pci_dev->devfn)) ||
 		       (function != PCI_FUNC(ctrl->pci_dev->devfn))) {
 			nummem = p_ev_ctrl->mem_avail;
 			numpmem = p_ev_ctrl->p_mem_avail;
@@ -640,14 +640,14 @@ int compaq_nvram_load (void __iomem *rom_start, struct controller *ctrl)
 		if (rc)
 			return(rc);
 	} else {
-		if ((evbuffer[0] != 0) && (!ctrl->push_flag)) 
+		if ((evbuffer[0] != 0) && (!ctrl->push_flag))
 			return 1;
 	}
 
 	return 0;
 }
 
-	
+
 int compaq_nvram_store (void __iomem *rom_start)
 {
 	int rc = 1;
diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index 6c0ed0f..573a270 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -82,7 +82,7 @@ static void __iomem *detect_HRT_floating_pointer(void __iomem *begin, void __iom
 }
 
 
-int cpqhp_configure_device (struct controller* ctrl, struct pci_func* func)  
+int cpqhp_configure_device (struct controller* ctrl, struct pci_func* func)
 {
 	unsigned char bus;
 	struct pci_bus *child;
@@ -116,10 +116,10 @@ int cpqhp_configure_device (struct controller* ctrl, struct pci_func* func)
 }
 
 
-int cpqhp_unconfigure_device(struct pci_func* func) 
+int cpqhp_unconfigure_device(struct pci_func* func)
 {
 	int j;
-	
+
 	dbg("%s: bus/dev/func = %x/%x/%x\n", __func__, func->bus, func->device, func->function);
 
 	for (j=0; j<8 ; j++) {
@@ -195,8 +195,8 @@ int cpqhp_set_irq (u8 bus_num, u8 dev_num, u8 int_pin, u8 irq_num)
 
 
 /*
- * WTF??? This function isn't in the code, yet a function calls it, but the 
- * compiler optimizes it away?  strange.  Here as a placeholder to keep the 
+ * WTF??? This function isn't in the code, yet a function calls it, but the
+ * compiler optimizes it away?  strange.  Here as a placeholder to keep the
  * compiler happy.
  */
 static int PCI_ScanBusNonBridge (u8 bus, u8 device)
@@ -398,7 +398,7 @@ int cpqhp_save_config(struct controller *ctrl, int busnumber, int is_hot_plug)
 
 				index = 0;
 				new_slot = cpqhp_slot_find(busnumber, device, index++);
-				while (new_slot && 
+				while (new_slot &&
 				       (new_slot->function != (u8) function))
 					new_slot = cpqhp_slot_find(busnumber, device, index++);
 
@@ -1168,7 +1168,7 @@ int cpqhp_valid_replace(struct controller *ctrl, struct pci_func * func)
  * this function is for hot plug ADD!
  *
  * returns 0 if success
- */  
+ */
 int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_start)
 {
 	u8 temp;

