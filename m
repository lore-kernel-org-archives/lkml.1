Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbXJLXH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbXJLXH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761244AbXJLWXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:23:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:50115 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761181AbXJLWXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:23:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 75/75] PM: merge device power-management source files
Date: Fri, 12 Oct 2007 15:17:19 -0700
Message-Id: <11922277983462-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922277903290-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
 <11922276163147-git-send-email-gregkh@suse.de>
 <11922276201219-git-send-email-gregkh@suse.de>
 <11922276254051-git-send-email-gregkh@suse.de>
 <11922276302338-git-send-email-gregkh@suse.de>
 <1192227634772-git-send-email-gregkh@suse.de>
 <11922276392200-git-send-email-gregkh@suse.de>
 <11922276433594-git-send-email-gregkh@suse.de>
 <11922276471365-git-send-email-gregkh@suse.de>
 <1192227653165-git-send-email-gregkh@suse.de>
 <11922276572176-git-send-email-gregkh@suse.de>
 <11922276622731-git-send-email-gregkh@suse.de>
 <11922276672660-git-send-email-gregkh@suse.de>
 <1192227671143-git-send-email-gregkh@suse.de>
 <11922276763650-git-send-email-gregkh@suse.de>
 <1192227681926-git-send-email-gregkh@suse.de>
 <11922276862914-git-send-email-gregkh@suse.de>
 <11922276913288-git-send-email-gregkh@suse.de>
 <1192227695547-git-send-email-gregkh@suse.de>
 <11922276993289-git-send-email-gregkh@suse.de>
 <11922277041450-git-send-email-gregkh@suse.de>
 <11922277091389-git-send-email-gregkh@suse.de>
 <11922277133374-git-send-email-gregkh@suse.de>
 <11922277181565-git-send-email-gregkh@suse.de>
 <11922277222714-git-send-email-gregkh@suse.de>
 <11922277261501-git-send-email-gregkh@suse.de>
 <1192227731677-git-send-email-gregkh@suse.de>
 <11922277364080-git-send-email-gregkh@suse.de>
 <11922277403355-git-send-email-gregkh@suse.de>
 <11922277441791-git-send-email-gregkh@suse.de>
 <11922277493627-git-send-email-gregkh@suse.de>
 <11922277571933-git-send-email-gregkh@suse.de>
 <119222776277-git-send-email-gregkh@suse.de>
 <11922277663827-git-send-email-gregkh@suse.de>
 <11922277711448-git-send-email-gregkh@suse.de>
 <1192227776447-git-send-email-gregkh@suse.de>
 <11922277801964-git-send-email-gregkh@suse.de>
 <11922277851672-git-send-email-gregkh@suse.de>
 <11922277903290-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as993) merges the suspend.c and resume.c files in
drivers/base/power into main.c, making some public symbols private.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/Makefile  |    2 +-
 drivers/base/power/main.c    |  344 +++++++++++++++++++++++++++++++++++++++++-
 drivers/base/power/power.h   |   32 +----
 drivers/base/power/resume.c  |  149 ------------------
 drivers/base/power/suspend.c |  210 -------------------------
 5 files changed, 343 insertions(+), 394 deletions(-)
 delete mode 100644 drivers/base/power/resume.c
 delete mode 100644 drivers/base/power/suspend.c

diff --git a/drivers/base/power/Makefile b/drivers/base/power/Makefile
index 9caeaea..a803733 100644
--- a/drivers/base/power/Makefile
+++ b/drivers/base/power/Makefile
@@ -1,5 +1,5 @@
 obj-y			:= shutdown.o
-obj-$(CONFIG_PM_SLEEP)	+= main.o suspend.o resume.o sysfs.o
+obj-$(CONFIG_PM_SLEEP)	+= main.o sysfs.o
 obj-$(CONFIG_PM_TRACE)	+= trace.o
 
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index eb9f38d..0ab4ab2 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -20,19 +20,24 @@
  */
 
 #include <linux/device.h>
+#include <linux/kallsyms.h>
 #include <linux/mutex.h>
+#include <linux/pm.h>
+#include <linux/resume-trace.h>
 
+#include "../base.h"
 #include "power.h"
 
 LIST_HEAD(dpm_active);
-LIST_HEAD(dpm_off);
-LIST_HEAD(dpm_off_irq);
+static LIST_HEAD(dpm_off);
+static LIST_HEAD(dpm_off_irq);
 
-DEFINE_MUTEX(dpm_mtx);
-DEFINE_MUTEX(dpm_list_mtx);
+static DEFINE_MUTEX(dpm_mtx);
+static DEFINE_MUTEX(dpm_list_mtx);
 
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
+
 int device_pm_add(struct device *dev)
 {
 	int error;
@@ -61,3 +66,334 @@ void device_pm_remove(struct device *dev)
 }
 
 
+/*------------------------- Resume routines -------------------------*/
+
+/**
+ *	resume_device - Restore state for one device.
+ *	@dev:	Device.
+ *
+ */
+
+static int resume_device(struct device * dev)
+{
+	int error = 0;
+
+	TRACE_DEVICE(dev);
+	TRACE_RESUME(0);
+
+	down(&dev->sem);
+
+	if (dev->bus && dev->bus->resume) {
+		dev_dbg(dev,"resuming\n");
+		error = dev->bus->resume(dev);
+	}
+
+	if (!error && dev->type && dev->type->resume) {
+		dev_dbg(dev,"resuming\n");
+		error = dev->type->resume(dev);
+	}
+
+	if (!error && dev->class && dev->class->resume) {
+		dev_dbg(dev,"class resume\n");
+		error = dev->class->resume(dev);
+	}
+
+	up(&dev->sem);
+
+	TRACE_RESUME(error);
+	return error;
+}
+
+
+static int resume_device_early(struct device * dev)
+{
+	int error = 0;
+
+	TRACE_DEVICE(dev);
+	TRACE_RESUME(0);
+	if (dev->bus && dev->bus->resume_early) {
+		dev_dbg(dev,"EARLY resume\n");
+		error = dev->bus->resume_early(dev);
+	}
+	TRACE_RESUME(error);
+	return error;
+}
+
+/*
+ * Resume the devices that have either not gone through
+ * the late suspend, or that did go through it but also
+ * went through the early resume
+ */
+static void dpm_resume(void)
+{
+	mutex_lock(&dpm_list_mtx);
+	while(!list_empty(&dpm_off)) {
+		struct list_head * entry = dpm_off.next;
+		struct device * dev = to_device(entry);
+
+		get_device(dev);
+		list_move_tail(entry, &dpm_active);
+
+		mutex_unlock(&dpm_list_mtx);
+		resume_device(dev);
+		mutex_lock(&dpm_list_mtx);
+		put_device(dev);
+	}
+	mutex_unlock(&dpm_list_mtx);
+}
+
+
+/**
+ *	device_resume - Restore state of each device in system.
+ *
+ *	Walk the dpm_off list, remove each entry, resume the device,
+ *	then add it to the dpm_active list.
+ */
+
+void device_resume(void)
+{
+	might_sleep();
+	mutex_lock(&dpm_mtx);
+	dpm_resume();
+	mutex_unlock(&dpm_mtx);
+}
+
+EXPORT_SYMBOL_GPL(device_resume);
+
+
+/**
+ *	dpm_power_up - Power on some devices.
+ *
+ *	Walk the dpm_off_irq list and power each device up. This
+ *	is used for devices that required they be powered down with
+ *	interrupts disabled. As devices are powered on, they are moved
+ *	to the dpm_active list.
+ *
+ *	Interrupts must be disabled when calling this.
+ */
+
+static void dpm_power_up(void)
+{
+	while(!list_empty(&dpm_off_irq)) {
+		struct list_head * entry = dpm_off_irq.next;
+		struct device * dev = to_device(entry);
+
+		list_move_tail(entry, &dpm_off);
+		resume_device_early(dev);
+	}
+}
+
+
+/**
+ *	device_power_up - Turn on all devices that need special attention.
+ *
+ *	Power on system devices then devices that required we shut them down
+ *	with interrupts disabled.
+ *	Called with interrupts disabled.
+ */
+
+void device_power_up(void)
+{
+	sysdev_resume();
+	dpm_power_up();
+}
+
+EXPORT_SYMBOL_GPL(device_power_up);
+
+
+/*------------------------- Suspend routines -------------------------*/
+
+/*
+ * The entries in the dpm_active list are in a depth first order, simply
+ * because children are guaranteed to be discovered after parents, and
+ * are inserted at the back of the list on discovery.
+ *
+ * All list on the suspend path are done in reverse order, so we operate
+ * on the leaves of the device tree (or forests, depending on how you want
+ * to look at it ;) first. As nodes are removed from the back of the list,
+ * they are inserted into the front of their destintation lists.
+ *
+ * Things are the reverse on the resume path - iterations are done in
+ * forward order, and nodes are inserted at the back of their destination
+ * lists. This way, the ancestors will be accessed before their descendents.
+ */
+
+static inline char *suspend_verb(u32 event)
+{
+	switch (event) {
+	case PM_EVENT_SUSPEND:	return "suspend";
+	case PM_EVENT_FREEZE:	return "freeze";
+	case PM_EVENT_PRETHAW:	return "prethaw";
+	default:		return "(unknown suspend event)";
+	}
+}
+
+
+static void
+suspend_device_dbg(struct device *dev, pm_message_t state, char *info)
+{
+	dev_dbg(dev, "%s%s%s\n", info, suspend_verb(state.event),
+		((state.event == PM_EVENT_SUSPEND) && device_may_wakeup(dev)) ?
+		", may wakeup" : "");
+}
+
+/**
+ *	suspend_device - Save state of one device.
+ *	@dev:	Device.
+ *	@state:	Power state device is entering.
+ */
+
+static int suspend_device(struct device * dev, pm_message_t state)
+{
+	int error = 0;
+
+	down(&dev->sem);
+	if (dev->power.power_state.event) {
+		dev_dbg(dev, "PM: suspend %d-->%d\n",
+			dev->power.power_state.event, state.event);
+	}
+
+	if (dev->class && dev->class->suspend) {
+		suspend_device_dbg(dev, state, "class ");
+		error = dev->class->suspend(dev, state);
+		suspend_report_result(dev->class->suspend, error);
+	}
+
+	if (!error && dev->type && dev->type->suspend) {
+		suspend_device_dbg(dev, state, "type ");
+		error = dev->type->suspend(dev, state);
+		suspend_report_result(dev->type->suspend, error);
+	}
+
+	if (!error && dev->bus && dev->bus->suspend) {
+		suspend_device_dbg(dev, state, "");
+		error = dev->bus->suspend(dev, state);
+		suspend_report_result(dev->bus->suspend, error);
+	}
+	up(&dev->sem);
+	return error;
+}
+
+
+/*
+ * This is called with interrupts off, only a single CPU
+ * running. We can't acquire a mutex or semaphore (and we don't
+ * need the protection)
+ */
+static int suspend_device_late(struct device *dev, pm_message_t state)
+{
+	int error = 0;
+
+	if (dev->bus && dev->bus->suspend_late) {
+		suspend_device_dbg(dev, state, "LATE ");
+		error = dev->bus->suspend_late(dev, state);
+		suspend_report_result(dev->bus->suspend_late, error);
+	}
+	return error;
+}
+
+/**
+ *	device_suspend - Save state and stop all devices in system.
+ *	@state:		Power state to put each device in.
+ *
+ *	Walk the dpm_active list, call ->suspend() for each device, and move
+ *	it to the dpm_off list.
+ *
+ *	(For historical reasons, if it returns -EAGAIN, that used to mean
+ *	that the device would be called again with interrupts disabled.
+ *	These days, we use the "suspend_late()" callback for that, so we
+ *	print a warning and consider it an error).
+ *
+ *	If we get a different error, try and back out.
+ *
+ *	If we hit a failure with any of the devices, call device_resume()
+ *	above to bring the suspended devices back to life.
+ *
+ */
+
+int device_suspend(pm_message_t state)
+{
+	int error = 0;
+
+	might_sleep();
+	mutex_lock(&dpm_mtx);
+	mutex_lock(&dpm_list_mtx);
+	while (!list_empty(&dpm_active) && error == 0) {
+		struct list_head * entry = dpm_active.prev;
+		struct device * dev = to_device(entry);
+
+		get_device(dev);
+		mutex_unlock(&dpm_list_mtx);
+
+		error = suspend_device(dev, state);
+
+		mutex_lock(&dpm_list_mtx);
+
+		/* Check if the device got removed */
+		if (!list_empty(&dev->power.entry)) {
+			/* Move it to the dpm_off list */
+			if (!error)
+				list_move(&dev->power.entry, &dpm_off);
+		}
+		if (error)
+			printk(KERN_ERR "Could not suspend device %s: "
+				"error %d%s\n",
+				kobject_name(&dev->kobj), error,
+				error == -EAGAIN ? " (please convert to suspend_late)" : "");
+		put_device(dev);
+	}
+	mutex_unlock(&dpm_list_mtx);
+	if (error)
+		dpm_resume();
+
+	mutex_unlock(&dpm_mtx);
+	return error;
+}
+
+EXPORT_SYMBOL_GPL(device_suspend);
+
+/**
+ *	device_power_down - Shut down special devices.
+ *	@state:		Power state to enter.
+ *
+ *	Walk the dpm_off_irq list, calling ->power_down() for each device that
+ *	couldn't power down the device with interrupts enabled. When we're
+ *	done, power down system devices.
+ */
+
+int device_power_down(pm_message_t state)
+{
+	int error = 0;
+	struct device * dev;
+
+	while (!list_empty(&dpm_off)) {
+		struct list_head * entry = dpm_off.prev;
+
+		dev = to_device(entry);
+		error = suspend_device_late(dev, state);
+		if (error)
+			goto Error;
+		list_move(&dev->power.entry, &dpm_off_irq);
+	}
+
+	error = sysdev_suspend(state);
+ Done:
+	return error;
+ Error:
+	printk(KERN_ERR "Could not power down device %s: "
+		"error %d\n", kobject_name(&dev->kobj), error);
+	dpm_power_up();
+	goto Done;
+}
+
+EXPORT_SYMBOL_GPL(device_power_down);
+
+void __suspend_report_result(const char *function, void *fn, int ret)
+{
+	if (ret) {
+		printk(KERN_ERR "%s(): ", function);
+		print_fn_descriptor_symbol("%s() returns ", (unsigned long)fn);
+		printk("%d\n", ret);
+	}
+}
+EXPORT_SYMBOL_GPL(__suspend_report_result);
diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index 49e64db..5c4efd4 100644
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -11,32 +11,11 @@ extern void device_shutdown(void);
  * main.c
  */
 
-/*
- * Used to synchronize global power management operations.
- */
-extern struct mutex dpm_mtx;
-
-/*
- * Used to serialize changes to the dpm_* lists.
- */
-extern struct mutex dpm_list_mtx;
-
-/*
- * The PM lists.
- */
-extern struct list_head dpm_active;
-extern struct list_head dpm_off;
-extern struct list_head dpm_off_irq;
-
-
-static inline struct dev_pm_info * to_pm_info(struct list_head * entry)
-{
-	return container_of(entry, struct dev_pm_info, entry);
-}
+extern struct list_head dpm_active;	/* The active device list */
 
 static inline struct device * to_device(struct list_head * entry)
 {
-	return container_of(to_pm_info(entry), struct device, power);
+	return container_of(entry, struct device, power.entry);
 }
 
 extern int device_pm_add(struct device *);
@@ -49,13 +28,6 @@ extern void device_pm_remove(struct device *);
 extern int dpm_sysfs_add(struct device *);
 extern void dpm_sysfs_remove(struct device *);
 
-/*
- * resume.c
- */
-
-extern void dpm_resume(void);
-extern void dpm_power_up(void);
-
 #else /* CONFIG_PM_SLEEP */
 
 
diff --git a/drivers/base/power/resume.c b/drivers/base/power/resume.c
deleted file mode 100644
index 67948ba..0000000
--- a/drivers/base/power/resume.c
+++ /dev/null
@@ -1,149 +0,0 @@
-/*
- * resume.c - Functions for waking devices up.
- *
- * Copyright (c) 2003 Patrick Mochel
- * Copyright (c) 2003 Open Source Development Labs
- *
- * This file is released under the GPLv2
- *
- */
-
-#include <linux/device.h>
-#include <linux/resume-trace.h>
-#include "../base.h"
-#include "power.h"
-
-
-/**
- *	resume_device - Restore state for one device.
- *	@dev:	Device.
- *
- */
-
-static int resume_device(struct device * dev)
-{
-	int error = 0;
-
-	TRACE_DEVICE(dev);
-	TRACE_RESUME(0);
-
-	down(&dev->sem);
-
-	if (dev->bus && dev->bus->resume) {
-		dev_dbg(dev,"resuming\n");
-		error = dev->bus->resume(dev);
-	}
-
-	if (!error && dev->type && dev->type->resume) {
-		dev_dbg(dev,"resuming\n");
-		error = dev->type->resume(dev);
-	}
-
-	if (!error && dev->class && dev->class->resume) {
-		dev_dbg(dev,"class resume\n");
-		error = dev->class->resume(dev);
-	}
-
-	up(&dev->sem);
-
-	TRACE_RESUME(error);
-	return error;
-}
-
-
-static int resume_device_early(struct device * dev)
-{
-	int error = 0;
-
-	TRACE_DEVICE(dev);
-	TRACE_RESUME(0);
-	if (dev->bus && dev->bus->resume_early) {
-		dev_dbg(dev,"EARLY resume\n");
-		error = dev->bus->resume_early(dev);
-	}
-	TRACE_RESUME(error);
-	return error;
-}
-
-/*
- * Resume the devices that have either not gone through
- * the late suspend, or that did go through it but also
- * went through the early resume
- */
-void dpm_resume(void)
-{
-	mutex_lock(&dpm_list_mtx);
-	while(!list_empty(&dpm_off)) {
-		struct list_head * entry = dpm_off.next;
-		struct device * dev = to_device(entry);
-
-		get_device(dev);
-		list_move_tail(entry, &dpm_active);
-
-		mutex_unlock(&dpm_list_mtx);
-		resume_device(dev);
-		mutex_lock(&dpm_list_mtx);
-		put_device(dev);
-	}
-	mutex_unlock(&dpm_list_mtx);
-}
-
-
-/**
- *	device_resume - Restore state of each device in system.
- *
- *	Walk the dpm_off list, remove each entry, resume the device,
- *	then add it to the dpm_active list.
- */
-
-void device_resume(void)
-{
-	might_sleep();
-	mutex_lock(&dpm_mtx);
-	dpm_resume();
-	mutex_unlock(&dpm_mtx);
-}
-
-EXPORT_SYMBOL_GPL(device_resume);
-
-
-/**
- *	dpm_power_up - Power on some devices.
- *
- *	Walk the dpm_off_irq list and power each device up. This
- *	is used for devices that required they be powered down with
- *	interrupts disabled. As devices are powered on, they are moved
- *	to the dpm_active list.
- *
- *	Interrupts must be disabled when calling this.
- */
-
-void dpm_power_up(void)
-{
-	while(!list_empty(&dpm_off_irq)) {
-		struct list_head * entry = dpm_off_irq.next;
-		struct device * dev = to_device(entry);
-
-		list_move_tail(entry, &dpm_off);
-		resume_device_early(dev);
-	}
-}
-
-
-/**
- *	device_power_up - Turn on all devices that need special attention.
- *
- *	Power on system devices then devices that required we shut them down
- *	with interrupts disabled.
- *	Called with interrupts disabled.
- */
-
-void device_power_up(void)
-{
-	sysdev_resume();
-	dpm_power_up();
-}
-
-EXPORT_SYMBOL_GPL(device_power_up);
-
-
diff --git a/drivers/base/power/suspend.c b/drivers/base/power/suspend.c
deleted file mode 100644
index 204517a..0000000
--- a/drivers/base/power/suspend.c
+++ /dev/null
@@ -1,210 +0,0 @@
-/*
- * suspend.c - Functions for putting devices to sleep.
- *
- * Copyright (c) 2003 Patrick Mochel
- * Copyright (c) 2003 Open Source Development Labs
- *
- * This file is released under the GPLv2
- *
- */
-
-#include <linux/device.h>
-#include <linux/kallsyms.h>
-#include <linux/pm.h>
-#include "../base.h"
-#include "power.h"
-
-/*
- * The entries in the dpm_active list are in a depth first order, simply
- * because children are guaranteed to be discovered after parents, and
- * are inserted at the back of the list on discovery.
- *
- * All list on the suspend path are done in reverse order, so we operate
- * on the leaves of the device tree (or forests, depending on how you want
- * to look at it ;) first. As nodes are removed from the back of the list,
- * they are inserted into the front of their destintation lists.
- *
- * Things are the reverse on the resume path - iterations are done in
- * forward order, and nodes are inserted at the back of their destination
- * lists. This way, the ancestors will be accessed before their descendents.
- */
-
-static inline char *suspend_verb(u32 event)
-{
-	switch (event) {
-	case PM_EVENT_SUSPEND:	return "suspend";
-	case PM_EVENT_FREEZE:	return "freeze";
-	case PM_EVENT_PRETHAW:	return "prethaw";
-	default:		return "(unknown suspend event)";
-	}
-}
-
-
-static void
-suspend_device_dbg(struct device *dev, pm_message_t state, char *info)
-{
-	dev_dbg(dev, "%s%s%s\n", info, suspend_verb(state.event),
-		((state.event == PM_EVENT_SUSPEND) && device_may_wakeup(dev)) ?
-		", may wakeup" : "");
-}
-
-/**
- *	suspend_device - Save state of one device.
- *	@dev:	Device.
- *	@state:	Power state device is entering.
- */
-
-static int suspend_device(struct device * dev, pm_message_t state)
-{
-	int error = 0;
-
-	down(&dev->sem);
-	if (dev->power.power_state.event) {
-		dev_dbg(dev, "PM: suspend %d-->%d\n",
-			dev->power.power_state.event, state.event);
-	}
-
-	if (dev->class && dev->class->suspend) {
-		suspend_device_dbg(dev, state, "class ");
-		error = dev->class->suspend(dev, state);
-		suspend_report_result(dev->class->suspend, error);
-	}
-
-	if (!error && dev->type && dev->type->suspend) {
-		suspend_device_dbg(dev, state, "type ");
-		error = dev->type->suspend(dev, state);
-		suspend_report_result(dev->type->suspend, error);
-	}
-
-	if (!error && dev->bus && dev->bus->suspend) {
-		suspend_device_dbg(dev, state, "");
-		error = dev->bus->suspend(dev, state);
-		suspend_report_result(dev->bus->suspend, error);
-	}
-	up(&dev->sem);
-	return error;
-}
-
-
-/*
- * This is called with interrupts off, only a single CPU
- * running. We can't acquire a mutex or semaphore (and we don't
- * need the protection)
- */
-static int suspend_device_late(struct device *dev, pm_message_t state)
-{
-	int error = 0;
-
-	if (dev->bus && dev->bus->suspend_late) {
-		suspend_device_dbg(dev, state, "LATE ");
-		error = dev->bus->suspend_late(dev, state);
-		suspend_report_result(dev->bus->suspend_late, error);
-	}
-	return error;
-}
-
-/**
- *	device_suspend - Save state and stop all devices in system.
- *	@state:		Power state to put each device in.
- *
- *	Walk the dpm_active list, call ->suspend() for each device, and move
- *	it to the dpm_off list.
- *
- *	(For historical reasons, if it returns -EAGAIN, that used to mean
- *	that the device would be called again with interrupts disabled.
- *	These days, we use the "suspend_late()" callback for that, so we
- *	print a warning and consider it an error).
- *
- *	If we get a different error, try and back out.
- *
- *	If we hit a failure with any of the devices, call device_resume()
- *	above to bring the suspended devices back to life.
- *
- */
-
-int device_suspend(pm_message_t state)
-{
-	int error = 0;
-
-	might_sleep();
-	mutex_lock(&dpm_mtx);
-	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_active) && error == 0) {
-		struct list_head * entry = dpm_active.prev;
-		struct device * dev = to_device(entry);
-
-		get_device(dev);
-		mutex_unlock(&dpm_list_mtx);
-
-		error = suspend_device(dev, state);
-
-		mutex_lock(&dpm_list_mtx);
-
-		/* Check if the device got removed */
-		if (!list_empty(&dev->power.entry)) {
-			/* Move it to the dpm_off list */
-			if (!error)
-				list_move(&dev->power.entry, &dpm_off);
-		}
-		if (error)
-			printk(KERN_ERR "Could not suspend device %s: "
-				"error %d%s\n",
-				kobject_name(&dev->kobj), error,
-				error == -EAGAIN ? " (please convert to suspend_late)" : "");
-		put_device(dev);
-	}
-	mutex_unlock(&dpm_list_mtx);
-	if (error)
-		dpm_resume();
-
-	mutex_unlock(&dpm_mtx);
-	return error;
-}
-
-EXPORT_SYMBOL_GPL(device_suspend);
-
-/**
- *	device_power_down - Shut down special devices.
- *	@state:		Power state to enter.
- *
- *	Walk the dpm_off_irq list, calling ->power_down() for each device that
- *	couldn't power down the device with interrupts enabled. When we're
- *	done, power down system devices.
- */
-
-int device_power_down(pm_message_t state)
-{
-	int error = 0;
-	struct device * dev;
-
-	while (!list_empty(&dpm_off)) {
-		struct list_head * entry = dpm_off.prev;
-
-		dev = to_device(entry);
-		error = suspend_device_late(dev, state);
-		if (error)
-			goto Error;
-		list_move(&dev->power.entry, &dpm_off_irq);
-	}
-
-	error = sysdev_suspend(state);
- Done:
-	return error;
- Error:
-	printk(KERN_ERR "Could not power down device %s: "
-		"error %d\n", kobject_name(&dev->kobj), error);
-	dpm_power_up();
-	goto Done;
-}
-
-EXPORT_SYMBOL_GPL(device_power_down);
-
-void __suspend_report_result(const char *function, void *fn, int ret)
-{
-	if (ret) {
-		printk(KERN_ERR "%s(): ", function);
-		print_fn_descriptor_symbol("%s() returns ", (unsigned long)fn);
-		printk("%d\n", ret);
-	}
-}
-EXPORT_SYMBOL_GPL(__suspend_report_result);
-- 
1.5.3.4

