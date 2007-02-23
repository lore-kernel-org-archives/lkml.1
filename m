Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbXBWAfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbXBWAfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 19:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbXBWAfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 19:35:34 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:14178 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbXBWAfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 19:35:33 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       johnrose@us.ibm.com
Subject: [PATCH 2/2] ibmebus: whitespace fixes
User-Agent: KMail/1.8.2
Cc: pmac@au1.ibm.com, fenkes@de.ibm.com, benh@kernel.crashing.org,
       Sylvain Munaut <tnt@246tnt.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 23 Feb 2007 01:39:23 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200702230139.23535.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joachim Fenkes <fenkes@de.ibm.com>

This fixes whitespacing in ibmebus.[ch] - no functionality changed.


Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---


 arch/powerpc/kernel/ibmebus.c |  126 +++++++++++++++++++++---------------------
 include/asm-powerpc/ibmebus.h |   42 +++++++-------


diff -urp b/arch/powerpc/kernel/ibmebus.c c/arch/powerpc/kernel/ibmebus.c
--- b/arch/powerpc/kernel/ibmebus.c	2007-02-22 05:43:32.133934656 +0100
+++ c/arch/powerpc/kernel/ibmebus.c	2007-02-20 23:31:39.000000000 +0100
@@ -4,35 +4,35 @@
  * Copyright (c) 2005 IBM Corporation
  *  Joachim Fenkes <fenkes@de.ibm.com>
  *  Heiko J Schick <schickhj@de.ibm.com>
- *    
+ *
  * All rights reserved.
  *
- * This source code is distributed under a dual license of GPL v2.0 and OpenIB 
- * BSD. 
+ * This source code is distributed under a dual license of GPL v2.0 and OpenIB
+ * BSD.
  *
  * OpenIB BSD License
  *
- * Redistribution and use in source and binary forms, with or without 
- * modification, are permitted provided that the following conditions are met: 
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
  *
- * Redistributions of source code must retain the above copyright notice, this 
- * list of conditions and the following disclaimer. 
+ * Redistributions of source code must retain the above copyright notice, this
+ * list of conditions and the following disclaimer.
  *
- * Redistributions in binary form must reproduce the above copyright notice, 
- * this list of conditions and the following disclaimer in the documentation 
+ * Redistributions in binary form must reproduce the above copyright notice,
+ * this list of conditions and the following disclaimer in the documentation
  * and/or other materials
- * provided with the distribution. 
+ * provided with the distribution.
  *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
- * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
- * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
- * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
  * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
- * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
+ * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGE.
  */
 
@@ -54,7 +54,7 @@ static void *ibmebus_alloc_coherent(stru
 				    gfp_t flag)
 {
 	void *mem;
-	
+
 	mem = kmalloc(size, flag);
 	*dma_handle = (dma_addr_t)mem;
 
@@ -62,7 +62,7 @@ static void *ibmebus_alloc_coherent(stru
 }
 
 static void ibmebus_free_coherent(struct device *dev,
-				  size_t size, void *vaddr, 
+				  size_t size, void *vaddr,
 				  dma_addr_t dma_handle)
 {
 	kfree(vaddr);
@@ -78,7 +78,7 @@ static dma_addr_t ibmebus_map_single(str
 
 static void ibmebus_unmap_single(struct device *dev,
 				 dma_addr_t dma_addr,
-				 size_t size, 
+				 size_t size,
 				 enum dma_data_direction direction)
 {
 	return;
@@ -89,13 +89,13 @@ static int ibmebus_map_sg(struct device 
 			  int nents, enum dma_data_direction direction)
 {
 	int i;
-	
+
 	for (i = 0; i < nents; i++) {
-		sg[i].dma_address = (dma_addr_t)page_address(sg[i].page) 
+		sg[i].dma_address = (dma_addr_t)page_address(sg[i].page)
 			+ sg[i].offset;
 		sg[i].dma_length = sg[i].length;
 	}
-	
+
 	return nents;
 }
 
@@ -127,15 +127,15 @@ static int ibmebus_bus_probe(struct devi
 	struct ibmebus_driver *ibmebusdrv = to_ibmebus_driver(dev->driver);
 	const struct of_device_id *id;
 	int error = -ENODEV;
-	
+
 	if (!ibmebusdrv->probe)
 		return error;
-	
+
 	id = of_match_device(ibmebusdrv->id_table, &ibmebusdev->ofdev);
 	if (id) {
 		error = ibmebusdrv->probe(ibmebusdev, id);
 	}
-	
+
 	return error;
 }
 
@@ -143,11 +143,11 @@ static int ibmebus_bus_remove(struct dev
 {
 	struct ibmebus_dev *ibmebusdev    = to_ibmebus_dev(dev);
 	struct ibmebus_driver *ibmebusdrv = to_ibmebus_driver(dev->driver);
-	
+
 	if (ibmebusdrv->remove) {
 		return ibmebusdrv->remove(ibmebusdev);
 	}
-	
+
 	return 0;
 }
 
@@ -157,14 +157,14 @@ static void __devinit ibmebus_dev_releas
 	kfree(to_ibmebus_dev(dev));
 }
 
-static ssize_t ibmebusdev_show_name(struct device *dev, 
+static ssize_t ibmebusdev_show_name(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
 	struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
 	char *name = (char*)get_property(ebus_dev->ofdev.node, "name", NULL);
 	return sprintf(buf, "%s\n", name);
 }
-static DEVICE_ATTR(name, S_IRUSR | S_IRGRP | S_IROTH, ibmebusdev_show_name, 
+static DEVICE_ATTR(name, S_IRUSR | S_IRGRP | S_IROTH, ibmebusdev_show_name,
 		   NULL);
 
 static int __devinit ibmebus_register_device_common(
@@ -181,16 +181,16 @@ static int __devinit ibmebus_register_de
 	dev->ofdev.dev.archdata.numa_node = of_node_to_nid(dev->ofdev.node);
 
 	/* An ibmebusdev is based on a of_device. We have to change the
-	 * bus type to use our own DMA mapping operations. 
-	 */       
+	 * bus type to use our own DMA mapping operations.
+	 */
 	if ((err = of_device_register(&dev->ofdev)) != 0) {
 		printk(KERN_ERR "%s: failed to register device (%d).\n",
 		       __FUNCTION__, err);
 		return -ENODEV;
 	}
-	
+
 	device_create_file(&dev->ofdev.dev, &dev_attr_name);
-	
+
 	return 0;
 }
 
@@ -207,7 +207,7 @@ static struct ibmebus_dev* __devinit ibm
 		       __FUNCTION__, dn->name ? dn->name : "<unknown>");
 		return ERR_PTR(-EINVAL);
         }
-	
+
 	if (strlen(loc_code) == 0) {
 	        printk(KERN_WARNING "%s: 'ibm,loc-code' is invalid\n",
 		       __FUNCTION__);
@@ -220,10 +220,10 @@ static struct ibmebus_dev* __devinit ibm
 	}
 
 	dev->ofdev.node = of_node_get(dn);
-       
+
 	length = strlen(loc_code);
-	memcpy(dev->ofdev.dev.bus_id, loc_code 
-		+ (length - min(length, BUS_ID_SIZE - 1)), 
+	memcpy(dev->ofdev.dev.bus_id, loc_code
+		+ (length - min(length, BUS_ID_SIZE - 1)),
 		min(length, BUS_ID_SIZE - 1));
 
 	/* Register with generic device framework. */
@@ -238,16 +238,16 @@ static struct ibmebus_dev* __devinit ibm
 static void ibmebus_probe_of_nodes(char* name)
 {
 	struct device_node *dn = NULL;
-	
+
 	while ((dn = of_find_node_by_name(dn, name))) {
 		if (IS_ERR(ibmebus_register_device_node(dn))) {
 			of_node_put(dn);
 			return;
 		}
 	}
-	
+
 	of_node_put(dn);
-	
+
 	return;
 }
 
@@ -271,7 +271,7 @@ static int ibmebus_match_helper_name(str
 
 	if (name && (strcmp((char*)data, name) == 0))
 		return 1;
-	
+
 	return 0;
 }
 
@@ -286,16 +286,16 @@ static int ibmebus_unregister_device(str
 static void ibmebus_remove_devices_by_id(struct of_device_id *idt)
 {
 	struct device *dev;
-	
+
 	while (strlen(idt->name) > 0) {
-		while ((dev = bus_find_device(&ibmebus_bus_type, NULL, 
+		while ((dev = bus_find_device(&ibmebus_bus_type, NULL,
 					      (void*)idt->name,
 					      ibmebus_match_helper_name))) {
 			ibmebus_unregister_device(dev);
 		}
 		idt++;
 	}
-	
+
 	return;
 }
 
@@ -315,29 +315,29 @@ int ibmebus_register_driver(struct ibmeb
 	 * probed them manually before registering the driver */
 	ibmebus_remove_devices_by_id(drv->id_table);
 	ibmebus_add_devices_by_id(drv->id_table);
-	
+
 	return 0;
 }
 EXPORT_SYMBOL(ibmebus_register_driver);
 
 void ibmebus_unregister_driver(struct ibmebus_driver *drv)
-{	
+{
 	driver_unregister(&drv->driver);
 	ibmebus_remove_devices_by_id(drv->id_table);
 }
 EXPORT_SYMBOL(ibmebus_unregister_driver);
 
 int ibmebus_request_irq(struct ibmebus_dev *dev,
-			u32 ist, 
+			u32 ist,
 			irq_handler_t handler,
 			unsigned long irq_flags, const char * devname,
 			void *dev_id)
 {
 	unsigned int irq = irq_create_mapping(NULL, ist);
-	
+
 	if (irq == NO_IRQ)
 		return -EINVAL;
-	
+
 	return request_irq(irq, handler,
 			   irq_flags, devname, dev_id);
 }
@@ -346,32 +346,32 @@ EXPORT_SYMBOL(ibmebus_request_irq);
 void ibmebus_free_irq(struct ibmebus_dev *dev, u32 ist, void *dev_id)
 {
 	unsigned int irq = irq_find_mapping(NULL, ist);
-	
+
 	free_irq(irq, dev_id);
 }
 EXPORT_SYMBOL(ibmebus_free_irq);
 
 static int ibmebus_bus_match(struct device *dev, struct device_driver *drv)
-{	
+{
 	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
 	struct ibmebus_driver *ebus_drv    = to_ibmebus_driver(drv);
 	const struct of_device_id *ids     = ebus_drv->id_table;
 	const struct of_device_id *found_id;
-	
+
 	if (!ids)
 		return 0;
-	
+
 	found_id = of_match_device(ids, &ebus_dev->ofdev);
 	if (found_id)
 		return 1;
-	
+
 	return 0;
 }
 
 struct bus_type ibmebus_bus_type = {
-	.name = "ibmebus",
+	.name   = "ibmebus",
 	.uevent = of_device_uevent,
-	.match = ibmebus_bus_match,
+	.match  = ibmebus_bus_match,
 };
 EXPORT_SYMBOL(ibmebus_bus_type);
 
@@ -452,25 +452,25 @@ static BUS_ATTR(remove, S_IWUSR, NULL, i
 static int __init ibmebus_bus_init(void)
 {
 	int err;
-	
+
 	printk(KERN_INFO "IBM eBus Device Driver\n");
-	
+
 	err = bus_register(&ibmebus_bus_type);
 	if (err) {
 		printk(KERN_ERR ":%s: failed to register IBM eBus.\n",
 		       __FUNCTION__);
 		return err;
 	}
-	
+
 	err = device_register(&ibmebus_bus_device);
 	if (err) {
-		printk(KERN_WARNING "%s: device_register returned %i\n", 
+		printk(KERN_WARNING "%s: device_register returned %i\n",
 		       __FUNCTION__, err);
 		bus_unregister(&ibmebus_bus_type);
 
 		return err;
 	}
-	
+
 	bus_create_file(&ibmebus_bus_type, &bus_attr_probe);
 	bus_create_file(&ibmebus_bus_type, &bus_attr_remove);
 
diff -urp b/include/asm-powerpc/ibmebus.h c/include/asm-powerpc/ibmebus.h
--- b/include/asm-powerpc/ibmebus.h	2007-02-22 05:43:32.134934504 +0100
+++ c/include/asm-powerpc/ibmebus.h	2007-02-22 05:28:09.244928272 +0100
@@ -4,35 +4,35 @@
  * Copyright (c) 2005 IBM Corporation
  *  Joachim Fenkes <fenkes@de.ibm.com>
  *  Heiko J Schick <schickhj@de.ibm.com>
- *    
+ *
  * All rights reserved.
  *
- * This source code is distributed under a dual license of GPL v2.0 and OpenIB 
- * BSD. 
+ * This source code is distributed under a dual license of GPL v2.0 and OpenIB
+ * BSD.
  *
  * OpenIB BSD License
  *
- * Redistribution and use in source and binary forms, with or without 
- * modification, are permitted provided that the following conditions are met: 
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
  *
- * Redistributions of source code must retain the above copyright notice, this 
- * list of conditions and the following disclaimer. 
+ * Redistributions of source code must retain the above copyright notice, this
+ * list of conditions and the following disclaimer.
  *
- * Redistributions in binary form must reproduce the above copyright notice, 
- * this list of conditions and the following disclaimer in the documentation 
+ * Redistributions in binary form must reproduce the above copyright notice,
+ * this list of conditions and the following disclaimer in the documentation
  * and/or other materials
- * provided with the distribution. 
+ * provided with the distribution.
  *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
- * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
- * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
- * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
  * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
- * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
+ * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGE.
  */
 
@@ -47,11 +47,11 @@
 
 extern struct bus_type ibmebus_bus_type;
 
-struct ibmebus_dev {	
+struct ibmebus_dev {
 	struct of_device ofdev;
 };
 
-struct ibmebus_driver {	
+struct ibmebus_driver {
 	char *name;
 	struct of_device_id *id_table;
 	int (*probe) (struct ibmebus_dev *dev, const struct of_device_id *id);
@@ -63,7 +63,7 @@ int ibmebus_register_driver(struct ibmeb
 void ibmebus_unregister_driver(struct ibmebus_driver *drv);
 
 int ibmebus_request_irq(struct ibmebus_dev *dev,
-			u32 ist, 
+			u32 ist,
 			irq_handler_t handler,
 			unsigned long irq_flags, const char * devname,
 			void *dev_id);



