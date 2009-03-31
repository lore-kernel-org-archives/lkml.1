Return-Path: <linux-kernel-owner+w=401wt.eu-S1762552AbZCaPYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762552AbZCaPYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762118AbZCaPXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:23:25 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:42194 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760383AbZCaPXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:23:23 -0400
Subject: [PATCH 03/15] PCI Hotplug: cpqphp: obey 80 column convention in
	cpqphp.h
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:23:21 -0600
Message-ID: <20090331152321.26622.74473.stgit@bob.kio>
In-Reply-To: <20090331150158.26622.45423.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up cpqphp.h to follow 80 column convention.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/cpqphp.h |   76 +++++++++++++++++++++++++-----------------
 1 files changed, 45 insertions(+), 31 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp.h b/drivers/pci/hotplug/cpqphp.h
index e15d657..308f82b 100644
--- a/drivers/pci/hotplug/cpqphp.h
+++ b/drivers/pci/hotplug/cpqphp.h
@@ -405,40 +405,50 @@ struct resource_lists {
 
 
 /* debugfs functions for the hotplug controller info */
-extern void cpqhp_initialize_debugfs		(void);
-extern void cpqhp_shutdown_debugfs		(void);
-extern void cpqhp_create_debugfs_files		(struct controller *ctrl);
-extern void cpqhp_remove_debugfs_files		(struct controller *ctrl);
+extern void cpqhp_initialize_debugfs(void);
+extern void cpqhp_shutdown_debugfs(void);
+extern void cpqhp_create_debugfs_files(struct controller *ctrl);
+extern void cpqhp_remove_debugfs_files(struct controller *ctrl);
 
 /* controller functions */
-extern void	cpqhp_pushbutton_thread		(unsigned long event_pointer);
-extern irqreturn_t cpqhp_ctrl_intr		(int IRQ, void *data);
-extern int	cpqhp_find_available_resources	(struct controller *ctrl, void __iomem *rom_start);
-extern int	cpqhp_event_start_thread	(void);
-extern void	cpqhp_event_stop_thread		(void);
-extern struct pci_func *cpqhp_slot_create	(unsigned char busnumber);
-extern struct pci_func *cpqhp_slot_find		(unsigned char bus, unsigned char device, unsigned char index);
-extern int	cpqhp_process_SI		(struct controller *ctrl, struct pci_func *func);
-extern int	cpqhp_process_SS		(struct controller *ctrl, struct pci_func *func);
-extern int	cpqhp_hardware_test		(struct controller *ctrl, int test_num);
+extern void cpqhp_pushbutton_thread(unsigned long event_pointer);
+extern irqreturn_t cpqhp_ctrl_intr(int IRQ, void *data);
+extern int cpqhp_find_available_resources(struct controller *ctrl,
+					  void __iomem *rom_start);
+extern int cpqhp_event_start_thread(void);
+extern void cpqhp_event_stop_thread(void);
+extern struct pci_func *cpqhp_slot_create(unsigned char busnumber);
+extern struct pci_func *cpqhp_slot_find(unsigned char bus, unsigned char device,
+					unsigned char index);
+extern int cpqhp_process_SI(struct controller *ctrl, struct pci_func *func);
+extern int cpqhp_process_SS(struct controller *ctrl, struct pci_func *func);
+extern int cpqhp_hardware_test(struct controller *ctrl, int test_num);
 
 /* resource functions */
 extern int	cpqhp_resource_sort_and_combine	(struct pci_resource **head);
 
 /* pci functions */
-extern int	cpqhp_set_irq			(u8 bus_num, u8 dev_num, u8 int_pin, u8 irq_num);
-extern int	cpqhp_get_bus_dev		(struct controller *ctrl, u8 *bus_num, u8 *dev_num, u8 slot);
-extern int	cpqhp_save_config		(struct controller *ctrl, int busnumber, int is_hot_plug);
-extern int	cpqhp_save_base_addr_length	(struct controller *ctrl, struct pci_func * func);
-extern int	cpqhp_save_used_resources	(struct controller *ctrl, struct pci_func * func);
-extern int	cpqhp_configure_board		(struct controller *ctrl, struct pci_func * func);
-extern int	cpqhp_save_slot_config		(struct controller *ctrl, struct pci_func * new_slot);
-extern int	cpqhp_valid_replace		(struct controller *ctrl, struct pci_func * func);
-extern void	cpqhp_destroy_board_resources	(struct pci_func * func);
-extern int	cpqhp_return_board_resources	(struct pci_func * func, struct resource_lists * resources);
-extern void	cpqhp_destroy_resource_list	(struct resource_lists * resources);
-extern int	cpqhp_configure_device		(struct controller* ctrl, struct pci_func* func);
-extern int	cpqhp_unconfigure_device	(struct pci_func* func);
+extern int cpqhp_set_irq(u8 bus_num, u8 dev_num, u8 int_pin, u8 irq_num);
+extern int cpqhp_get_bus_dev(struct controller *ctrl, u8 *bus_num, u8 *dev_num,
+			     u8 slot);
+extern int cpqhp_save_config(struct controller *ctrl, int busnumber,
+			     int is_hot_plug);
+extern int cpqhp_save_base_addr_length(struct controller *ctrl,
+				       struct pci_func *func);
+extern int cpqhp_save_used_resources(struct controller *ctrl,
+				     struct pci_func *func);
+extern int cpqhp_configure_board(struct controller *ctrl,
+				 struct pci_func *func);
+extern int cpqhp_save_slot_config(struct controller *ctrl,
+				  struct pci_func *new_slot);
+extern int cpqhp_valid_replace(struct controller *ctrl, struct pci_func *func);
+extern void cpqhp_destroy_board_resources(struct pci_func *func);
+extern int cpqhp_return_board_resources	(struct pci_func *func,
+					 struct resource_lists *resources);
+extern void cpqhp_destroy_resource_list(struct resource_lists *resources);
+extern int cpqhp_configure_device(struct controller *ctrl,
+				  struct pci_func *func);
+extern int cpqhp_unconfigure_device(struct pci_func *func);
 
 /* Global variables */
 extern int cpqhp_debug;
@@ -463,7 +473,8 @@ static inline char *slot_name(struct slot *slot)
  *
  * Puts node back in the resource list pointed to by head
  */
-static inline void return_resource(struct pci_resource **head, struct pci_resource *node)
+static inline void return_resource(struct pci_resource **head,
+				   struct pci_resource *node)
 {
 	if (!node || !head)
 		return;
@@ -673,7 +684,8 @@ static inline int get_slot_enabled(struct controller *ctrl, struct slot *slot)
 }
 
 
-static inline int cpq_get_latch_status(struct controller *ctrl, struct slot *slot)
+static inline int cpq_get_latch_status(struct controller *ctrl,
+				       struct slot *slot)
 {
 	u32 status;
 	u8 hp_slot;
@@ -688,7 +700,8 @@ static inline int cpq_get_latch_status(struct controller *ctrl, struct slot *slo
 }
 
 
-static inline int get_presence_status(struct controller *ctrl, struct slot *slot)
+static inline int get_presence_status(struct controller *ctrl,
+				      struct slot *slot)
 {
 	int presence_save = 0;
 	u8 hp_slot;
@@ -697,7 +710,8 @@ static inline int get_presence_status(struct controller *ctrl, struct slot *slot
 	hp_slot = slot->device - ctrl->slot_device_offset;
 
 	tempdword = readl(ctrl->hpc_reg + INT_INPUT_CLEAR);
-	presence_save = (int) ((((~tempdword) >> 23) | ((~tempdword) >> 15)) >> hp_slot) & 0x02;
+	presence_save = (int) ((((~tempdword) >> 23) | ((~tempdword) >> 15))
+				>> hp_slot) & 0x02;
 
 	return presence_save;
 }

