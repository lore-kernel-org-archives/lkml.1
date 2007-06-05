Return-Path: <linux-kernel-owner+w=401wt.eu-S933587AbXFEVWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbXFEVWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932801AbXFEVWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:22:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933441AbXFEVV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:21:57 -0400
Message-ID: <4665D3EC.60404@redhat.com>
Date: Tue, 05 Jun 2007 17:21:48 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-serial@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: [PATCH TRIVIAL] icom whitespace cleanups
Content-Type: multipart/mixed;
 boundary="------------050406060502020506010401"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050406060502020506010401
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

From: Chris Snook <csnook@redhat.com>

Clean up whitespace and comments in drivers/serial/icom.c

Signed-off-by: Chris Snook <csnook@redhat.com>

The patch is very large (30k) so I have attached it.  Please let me know if you 
really, really want it inline.


--------------050406060502020506010401
Content-Type: text/x-patch;
 name="icom-whitespace-cleanup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="icom-whitespace-cleanup.patch"

--- a/drivers/serial/icom.c	2007-06-05 16:00:00.000000000 -0400
+++ b/drivers/serial/icom.c	2007-06-05 16:58:32.000000000 -0400
@@ -1,27 +1,27 @@
 /*
-  * icom.c
-  *
-  * Copyright (C) 2001 IBM Corporation. All rights reserved.
-  *
-  * Serial device driver.
-  *
-  * Based on code from serial.c
-  *
-  * This program is free software; you can redistribute it and/or modify
-  * it under the terms of the GNU General Public License as published by
-  * the Free Software Foundation; either version 2 of the License, or
-  * (at your option) any later version.
-  *
-  * This program is distributed in the hope that it will be useful,
-  * but WITHOUT ANY WARRANTY; without even the implied warranty of
-  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  * GNU General Public License for more details.
-  *
-  * You should have received a copy of the GNU General Public License
-  * along with this program; if not, write to the Free Software
-  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
-  *
-  */
+ * icom.c
+ *
+ * Copyright (C) 2001 IBM Corporation. All rights reserved.
+ *
+ * Serial device driver.
+ *
+ * Based on code from serial.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ */
 #define SERIAL_DO_RESTART
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -63,7 +63,7 @@
 
 #define ICOM_DRIVER_NAME "icom"
 #define ICOM_VERSION_STR "1.3.1"
-#define NR_PORTS	       128
+#define NR_PORTS	128
 #define ICOM_PORT ((struct icom_port *)port)
 #define to_icom_adapter(d) container_of(d, struct icom_adapter, kobj)
 
@@ -149,23 +149,23 @@ static void free_port_memory(struct icom
 	trace(icom_port, "RET_PORT_MEM", 0);
 	if (icom_port->recv_buf) {
 		pci_free_consistent(dev, 4096, icom_port->recv_buf,
-				    icom_port->recv_buf_pci);
+			icom_port->recv_buf_pci);
 		icom_port->recv_buf = NULL;
 	}
 	if (icom_port->xmit_buf) {
 		pci_free_consistent(dev, 4096, icom_port->xmit_buf,
-				    icom_port->xmit_buf_pci);
+			icom_port->xmit_buf_pci);
 		icom_port->xmit_buf = NULL;
 	}
 	if (icom_port->statStg) {
 		pci_free_consistent(dev, 4096, icom_port->statStg,
-				    icom_port->statStg_pci);
+			icom_port->statStg_pci);
 		icom_port->statStg = NULL;
 	}
 
 	if (icom_port->xmitRestart) {
 		pci_free_consistent(dev, 4096, icom_port->xmitRestart,
-				    icom_port->xmitRestart_pci);
+			icom_port->xmitRestart_pci);
 		icom_port->xmitRestart = NULL;
 	}
 }
@@ -179,49 +179,48 @@ static int __devinit get_port_memory(str
 	struct pci_dev *dev = icom_port->adapter->pci_dev;
 
 	icom_port->xmit_buf =
-	    pci_alloc_consistent(dev, 4096, &icom_port->xmit_buf_pci);
+		pci_alloc_consistent(dev, 4096, &icom_port->xmit_buf_pci);
 	if (!icom_port->xmit_buf) {
 		dev_err(&dev->dev, "Can not allocate Transmit buffer\n");
 		return -ENOMEM;
 	}
 
-	trace(icom_port, "GET_PORT_MEM",
-	      (unsigned long) icom_port->xmit_buf);
+	trace(icom_port, "GET_PORT_MEM", (unsigned long) icom_port->xmit_buf);
 
 	icom_port->recv_buf =
-	    pci_alloc_consistent(dev, 4096, &icom_port->recv_buf_pci);
+		pci_alloc_consistent(dev, 4096, &icom_port->recv_buf_pci);
 	if (!icom_port->recv_buf) {
 		dev_err(&dev->dev, "Can not allocate Receive buffer\n");
 		free_port_memory(icom_port);
 		return -ENOMEM;
 	}
 	trace(icom_port, "GET_PORT_MEM",
-	      (unsigned long) icom_port->recv_buf);
+		(unsigned long) icom_port->recv_buf);
 
 	icom_port->statStg =
-	    pci_alloc_consistent(dev, 4096, &icom_port->statStg_pci);
+		pci_alloc_consistent(dev, 4096, &icom_port->statStg_pci);
 	if (!icom_port->statStg) {
 		dev_err(&dev->dev, "Can not allocate Status buffer\n");
 		free_port_memory(icom_port);
 		return -ENOMEM;
 	}
 	trace(icom_port, "GET_PORT_MEM",
-	      (unsigned long) icom_port->statStg);
+		(unsigned long) icom_port->statStg);
 
 	icom_port->xmitRestart =
-	    pci_alloc_consistent(dev, 4096, &icom_port->xmitRestart_pci);
+		pci_alloc_consistent(dev, 4096, &icom_port->xmitRestart_pci);
 	if (!icom_port->xmitRestart) {
-		dev_err(&dev->dev,
-			"Can not allocate xmit Restart buffer\n");
+		dev_err(&dev->dev, "Can not allocate xmit Restart buffer\n");
 		free_port_memory(icom_port);
 		return -ENOMEM;
 	}
 
 	memset(icom_port->statStg, 0, 4096);
 
-	/* FODs: Frame Out Descriptor Queue, this is a FIFO queue that
-           indicates that frames are to be transmitted
-	*/
+	/*
+	 * FODs: Frame Out Descriptor Queue, this is a FIFO queue that
+	 * indicates that frames are to be transmitted
+	 */
 
 	stgAddr = (unsigned long) icom_port->statStg;
 	for (index = 0; index < NUM_XBUFFS; index++) {
@@ -230,20 +229,20 @@ static int __devinit get_port_memory(str
 		if (index < (NUM_XBUFFS - 1)) {
 			memset(&icom_port->statStg->xmit[index], 0, sizeof(struct xmit_status_area));
 			icom_port->statStg->xmit[index].leLengthASD =
-			    (unsigned short int) cpu_to_le16(XMIT_BUFF_SZ);
+				(unsigned short int) cpu_to_le16(XMIT_BUFF_SZ);
 			trace(icom_port, "FOD_ADDR", stgAddr);
 			trace(icom_port, "FOD_XBUFF",
-			      (unsigned long) icom_port->xmit_buf);
+				(unsigned long) icom_port->xmit_buf);
 			icom_port->statStg->xmit[index].leBuffer =
-			    cpu_to_le32(icom_port->xmit_buf_pci);
+				cpu_to_le32(icom_port->xmit_buf_pci);
 		} else if (index == (NUM_XBUFFS - 1)) {
 			memset(&icom_port->statStg->xmit[index], 0, sizeof(struct xmit_status_area));
 			icom_port->statStg->xmit[index].leLengthASD =
-			    (unsigned short int) cpu_to_le16(XMIT_BUFF_SZ);
+				(unsigned short int) cpu_to_le16(XMIT_BUFF_SZ);
 			trace(icom_port, "FOD_XBUFF",
-			      (unsigned long) icom_port->xmit_buf);
+				(unsigned long) icom_port->xmit_buf);
 			icom_port->statStg->xmit[index].leBuffer =
-			    cpu_to_le32(icom_port->xmit_buf_pci);
+				cpu_to_le32(icom_port->xmit_buf_pci);
 		} else {
 			memset(&icom_port->statStg->xmit[index], 0, sizeof(struct xmit_status_area));
 		}
@@ -257,23 +256,23 @@ static int __devinit get_port_memory(str
 		stgAddr = stgAddr + sizeof(icom_port->statStg->rcv[0]);
 		icom_port->statStg->rcv[index].leLength = 0;
 		icom_port->statStg->rcv[index].WorkingLength =
-		    (unsigned short int) cpu_to_le16(RCV_BUFF_SZ);
+			(unsigned short int) cpu_to_le16(RCV_BUFF_SZ);
 		if (index < (NUM_RBUFFS - 1) ) {
 			offset = stgAddr - (unsigned long) icom_port->statStg;
 			icom_port->statStg->rcv[index].leNext =
-			      cpu_to_le32(icom_port-> statStg_pci + offset);
+				cpu_to_le32(icom_port-> statStg_pci + offset);
 			trace(icom_port, "FID_RBUFF",
-			      (unsigned long) icom_port->recv_buf);
+				(unsigned long) icom_port->recv_buf);
 			icom_port->statStg->rcv[index].leBuffer =
-			    cpu_to_le32(icom_port->recv_buf_pci);
+				cpu_to_le32(icom_port->recv_buf_pci);
 		} else if (index == (NUM_RBUFFS -1) ) {
 			offset = startStgAddr - (unsigned long) icom_port->statStg;
 			icom_port->statStg->rcv[index].leNext =
-			    cpu_to_le32(icom_port-> statStg_pci + offset);
+				cpu_to_le32(icom_port-> statStg_pci + offset);
 			trace(icom_port, "FID_RBUFF",
-			      (unsigned long) icom_port->recv_buf + 2048);
+				(unsigned long) icom_port->recv_buf + 2048);
 			icom_port->statStg->rcv[index].leBuffer =
-			    cpu_to_le32(icom_port->recv_buf_pci + 2048);
+				cpu_to_le32(icom_port->recv_buf_pci + 2048);
 		} else {
 			icom_port->statStg->rcv[index].leNext = 0;
 			icom_port->statStg->rcv[index].leBuffer = 0;
@@ -300,15 +299,15 @@ static void stop_processor(struct icom_p
 
 	if (port < 4) {
 		temp = readl(stop_proc[port].global_control_reg);
-		temp =
-	    		(temp & ~start_proc[port].processor_id) | stop_proc[port].processor_id;
+		temp = (temp & ~start_proc[port].processor_id)
+			| stop_proc[port].processor_id;
 		writel(temp, stop_proc[port].global_control_reg);
 
 		/* write flush */
 		readl(stop_proc[port].global_control_reg);
 	} else {
 		dev_err(&icom_port->adapter->pci_dev->dev,
-                        "Invalid port assignment\n");
+			"Invalid port assignment\n");
 	}
 
 	spin_unlock_irqrestore(&icom_lock, flags);
@@ -329,15 +328,15 @@ static void start_processor(struct icom_
 		start_proc[port].global_control_reg = &icom_port->global_reg->control_2;
 	if (port < 4) {
 		temp = readl(start_proc[port].global_control_reg);
-		temp =
-	    		(temp & ~stop_proc[port].processor_id) | start_proc[port].processor_id;
+		temp = (temp & ~stop_proc[port].processor_id)
+			| start_proc[port].processor_id;
 		writel(temp, start_proc[port].global_control_reg);
 
 		/* write flush */
 		readl(start_proc[port].global_control_reg);
 	} else {
 		dev_err(&icom_port->adapter->pci_dev->dev,
-                        "Invalid port assignment\n");
+			"Invalid port assignment\n");
 	}
 
 	spin_unlock_irqrestore(&icom_lock, flags);
@@ -414,15 +413,16 @@ static void load_code(struct icom_port *
 	start_processor(icom_port);
 
 	writeb((HDLC_PPP_PURE_ASYNC | HDLC_FF_FILL),
-	       &(icom_port->dram->HDLCConfigReg));
+		&(icom_port->dram->HDLCConfigReg));
 	writeb(0x04, &(icom_port->dram->FlagFillIdleTimer));	/* 0.5 seconds */
 	writeb(0x00, &(icom_port->dram->CmdReg));
 	writeb(0x10, &(icom_port->dram->async_config3));
 	writeb((ICOM_ACFG_DRIVE1 | ICOM_ACFG_NO_PARITY | ICOM_ACFG_8BPC |
 		ICOM_ACFG_1STOP_BIT), &(icom_port->dram->async_config2));
 
-	/*Set up data in icom DRAM to indicate where personality
-	 *code is located and its length.
+	/*
+	 * Set up data in icom DRAM to indicate where personality
+	 * code is located and its length.
 	 */
 	new_page = pci_alloc_consistent(dev, 4096, &temp_pci);
 
@@ -453,15 +453,16 @@ static void load_code(struct icom_port *
 	writeb((char) ((fw->size + 16)/16), &icom_port->dram->mac_length);
 	writel(temp_pci, &icom_port->dram->mac_load_addr);
 
-	/*Setting the syncReg to 0x80 causes adapter to start downloading
-	   the personality code into adapter instruction RAM.
-	   Once code is loaded, it will begin executing and, based on
-	   information provided above, will start DMAing data from
-	   shared memory to adapter DRAM.
+	/*
+	 * Setting the syncReg to 0x80 causes adapter to start downloading
+	 * the personality code into adapter instruction RAM.
+	 * Once code is loaded, it will begin executing and, based on
+	 * information provided above, will start DMAing data from
+	 * shared memory to adapter DRAM.
+	 *
+	 * the wait loop below verifies this write operation has been done
+	 * and processed
 	 */
-	/* the wait loop below verifies this write operation has been done
-	   and processed
-	*/
 	writeb(START_DOWNLOAD, &icom_port->dram->sync);
 
 	/* Wait max 1 Sec for data download and processor to start */
@@ -474,9 +475,7 @@ static void load_code(struct icom_port *
 	if (index == 10)
 		status = -1;
 
-	/*
-	 * check Cable ID
-	 */
+	/* check Cable ID */
 	cable_id = readb(&icom_port->dram->cable_id);
 
 	if (cable_id & ICOM_CABLE_ID_VALID) {
@@ -488,7 +487,7 @@ static void load_code(struct icom_port *
 		icom_port->cable_id = NO_CABLE;
 	}
 
-      load_code_exit:
+load_code_exit:
 
 	if (status != 0) {
 		/* Clear out any pending interrupts */
@@ -503,8 +502,8 @@ static void load_code(struct icom_port *
 		dev_err(&icom_port->adapter->pci_dev->dev,"Port not opertional\n");
 	}
 
-      if (new_page != NULL)
-	      pci_free_consistent(dev, 4096, new_page, temp_pci);
+	if (new_page != NULL)
+		pci_free_consistent(dev, 4096, new_page, temp_pci);
 }
 
 static int startup(struct icom_port *icom_port)
@@ -523,9 +522,7 @@ static int startup(struct icom_port *ico
 		return -ENODEV;
 	}
 
-	/*
-	 * check Cable ID
-	 */
+	/* check Cable ID */
 	raw_cable_id = readb(&icom_port->dram->cable_id);
 	trace(icom_port, "CABLE_ID", raw_cable_id);
 
@@ -534,7 +531,7 @@ static int startup(struct icom_port *ico
 
 	/* Check for valid Cable ID */
 	if (!(raw_cable_id & ICOM_CABLE_ID_VALID) ||
-	    (cable_id != icom_port->cable_id)) {
+		(cable_id != icom_port->cable_id)) {
 
 		/* reload adapter code, pick up any potential changes in cable id */
 		load_code(icom_port);
@@ -543,13 +540,11 @@ static int startup(struct icom_port *ico
 		raw_cable_id = readb(&icom_port->dram->cable_id);
 		cable_id = (raw_cable_id & ICOM_CABLE_ID_MASK) >> 4;
 		if (!(raw_cable_id & ICOM_CABLE_ID_VALID) ||
-		    (icom_port->cable_id == NO_CABLE))
+			(icom_port->cable_id == NO_CABLE))
 			return -EIO;
 	}
 
-	/*
-	 * Finally, clear and  enable interrupts
-	 */
+	/* Finally, clear and  enable interrupts */
 	spin_lock_irqsave(&icom_lock, flags);
 	port = icom_port->port;
 	if (port == 0 || port == 1)
@@ -569,7 +564,7 @@ static int startup(struct icom_port *ico
 		readl(int_mask_tbl[port].global_int_mask);
 	} else {
 		dev_err(&icom_port->adapter->pci_dev->dev,
-                        "Invalid port assignment\n");
+			"Invalid port assignment\n");
 	}
 
 	spin_unlock_irqrestore(&icom_lock, flags);
@@ -586,9 +581,7 @@ static void shutdown(struct icom_port *i
 	spin_lock_irqsave(&icom_lock, flags);
 	trace(icom_port, "SHUTDOWN", 0);
 
-	/*
-	 * disable all interrupts
-	 */
+	/* disable all interrupts */
 	port = icom_port->port;
 	if (port == 0 || port == 1)
 		int_mask_tbl[port].global_int_mask = &icom_port->global_reg->int_mask;
@@ -603,13 +596,11 @@ static void shutdown(struct icom_port *i
 		readl(int_mask_tbl[port].global_int_mask);
 	} else {
 		dev_err(&icom_port->adapter->pci_dev->dev,
-                        "Invalid port assignment\n");
+			"Invalid port assignment\n");
 	}
 	spin_unlock_irqrestore(&icom_lock, flags);
 
-	/*
-	 * disable break condition
-	 */
+	/* disable break condition */
 	cmdReg = readb(&icom_port->dram->CmdReg);
 	if ((cmdReg | CMD_SND_BREAK) == CMD_SND_BREAK) {
 		writeb(cmdReg & ~CMD_SND_BREAK, &icom_port->dram->CmdReg);
@@ -626,17 +617,17 @@ static int icom_write(struct uart_port *
 	trace(ICOM_PORT, "WRITE", 0);
 
 	if (cpu_to_le16(ICOM_PORT->statStg->xmit[0].flags) &
-	    SA_FLAGS_READY_TO_XMIT) {
+		SA_FLAGS_READY_TO_XMIT) {
 		trace(ICOM_PORT, "WRITE_FULL", 0);
 		return 0;
 	}
 
 	data_count = 0;
 	while ((port->info->xmit.head != temp_tail) &&
-	       (data_count <= XMIT_BUFF_SZ)) {
+		(data_count <= XMIT_BUFF_SZ)) {
 
 		ICOM_PORT->xmit_buf[data_count++] =
-		    port->info->xmit.buf[temp_tail];
+			port->info->xmit.buf[temp_tail];
 
 		temp_tail++;
 		temp_tail &= (UART_XMIT_SIZE - 1);
@@ -644,17 +635,17 @@ static int icom_write(struct uart_port *
 
 	if (data_count) {
 		ICOM_PORT->statStg->xmit[0].flags =
-		    cpu_to_le16(SA_FLAGS_READY_TO_XMIT);
+			cpu_to_le16(SA_FLAGS_READY_TO_XMIT);
 		ICOM_PORT->statStg->xmit[0].leLength =
-		    cpu_to_le16(data_count);
+			cpu_to_le16(data_count);
 		offset =
-		    (unsigned long) &ICOM_PORT->statStg->xmit[0] -
-		    (unsigned long) ICOM_PORT->statStg;
+			(unsigned long) &ICOM_PORT->statStg->xmit[0] -
+			(unsigned long) ICOM_PORT->statStg;
 		*ICOM_PORT->xmitRestart =
-		    cpu_to_le32(ICOM_PORT->statStg_pci + offset);
+			cpu_to_le32(ICOM_PORT->statStg_pci + offset);
 		cmdReg = readb(&ICOM_PORT->dram->CmdReg);
 		writeb(cmdReg | CMD_XMIT_RCV_ENABLE,
-		       &ICOM_PORT->dram->CmdReg);
+			&ICOM_PORT->dram->CmdReg);
 		writeb(START_XMIT, &ICOM_PORT->dram->StartXmitCmd);
 		trace(ICOM_PORT, "WRITE_START", data_count);
 		/* write flush */
@@ -683,13 +674,13 @@ static inline void check_modem_status(st
 			icom_port->uart_port.icount.dsr++;
 		if (delta_status & ICOM_DCD)
 			uart_handle_dcd_change(&icom_port->uart_port,
-					       delta_status & ICOM_DCD);
+				delta_status & ICOM_DCD);
 		if (delta_status & ICOM_CTS)
 			uart_handle_cts_change(&icom_port->uart_port,
-					       delta_status & ICOM_CTS);
+				delta_status & ICOM_CTS);
 
 		wake_up_interruptible(&icom_port->uart_port.info->
-				      delta_msr_wait);
+			delta_msr_wait);
 		old_status = status;
 	}
 	spin_unlock(&icom_port->uart_port.lock);
@@ -745,7 +736,7 @@ static void recv_interrupt(u16 port_int_
 		trace(icom_port, "FID_STATUS", status);
 		count = cpu_to_le16(icom_port->statStg->rcv[rcv_buff].leLength);
 
-                count = tty_buffer_request_room(tty, count);
+		count = tty_buffer_request_room(tty, count);
 		trace(icom_port, "RCV_COUNT", count);
 
 		trace(icom_port, "REAL_COUNT", count);
@@ -765,7 +756,7 @@ static void recv_interrupt(u16 port_int_
 
 		/* Break detect logic */
 		if ((status & SA_FLAGS_FRAME_ERROR)
-		    && first == 0) {
+			&& first == 0) {
 			status &= ~SA_FLAGS_FRAME_ERROR;
 			status |= SA_FLAGS_BREAK_DET;
 			trace(icom_port, "BREAK_DET", 0);
@@ -774,8 +765,8 @@ static void recv_interrupt(u16 port_int_
 		flag = TTY_NORMAL;
 
 		if (status &
-		    (SA_FLAGS_BREAK_DET | SA_FLAGS_PARITY_ERROR |
-		     SA_FLAGS_FRAME_ERROR | SA_FLAGS_OVERRUN)) {
+			(SA_FLAGS_BREAK_DET | SA_FLAGS_PARITY_ERROR |
+			SA_FLAGS_FRAME_ERROR | SA_FLAGS_OVERRUN)) {
 
 			if (status & SA_FLAGS_BREAK_DET)
 				icount->brk++;
@@ -834,7 +825,7 @@ ignore_char:
 }
 
 static void process_interrupt(u16 port_int_reg,
-			      struct icom_port *icom_port)
+	struct icom_port *icom_port)
 {
 
 	spin_lock(&icom_port->uart_port.lock);
@@ -877,7 +868,7 @@ static irqreturn_t icom_interrupt(int ir
 			icom_port = &icom_adapter->port_info[3];
 			if (icom_port->status == ICOM_PORT_ACTIVE) {
 				port_int_reg =
-				    (u16) (adapter_interrupts >> 16);
+					(u16) (adapter_interrupts >> 16);
 				process_interrupt(port_int_reg, icom_port);
 				check_modem_status(icom_port);
 			}
@@ -931,7 +922,7 @@ static unsigned int icom_tx_empty(struct
 
 	spin_lock_irqsave(&port->lock, flags);
 	if (cpu_to_le16(ICOM_PORT->statStg->xmit[0].flags) &
-	    SA_FLAGS_READY_TO_XMIT)
+		SA_FLAGS_READY_TO_XMIT)
 		ret = TIOCSER_TEMT;
 	else
 		ret = 0;
@@ -976,9 +967,9 @@ static unsigned int icom_get_mctrl(struc
 	status = readb(&ICOM_PORT->dram->isr);
 
 	result = ((status & ICOM_DCD) ? TIOCM_CAR : 0)
-	    | ((status & ICOM_RI) ? TIOCM_RNG : 0)
-	    | ((status & ICOM_DSR) ? TIOCM_DSR : 0)
-	    | ((status & ICOM_CTS) ? TIOCM_CTS : 0);
+		| ((status & ICOM_RI) ? TIOCM_RNG : 0)
+		| ((status & ICOM_DSR) ? TIOCM_DSR : 0)
+		| ((status & ICOM_CTS) ? TIOCM_CTS : 0);
 	return result;
 }
 
@@ -999,7 +990,7 @@ static void icom_start_tx(struct uart_po
 	cmdReg = readb(&ICOM_PORT->dram->CmdReg);
 	if ((cmdReg & CMD_HOLD_XMIT) == CMD_HOLD_XMIT)
 		writeb(cmdReg & ~CMD_HOLD_XMIT,
-		       &ICOM_PORT->dram->CmdReg);
+			&ICOM_PORT->dram->CmdReg);
 
 	icom_write(port);
 }
@@ -1084,7 +1075,7 @@ static void icom_close(struct uart_port 
 	/* stop receiver */
 	cmdReg = readb(&ICOM_PORT->dram->CmdReg);
 	writeb(cmdReg & (unsigned char) ~CMD_RCV_ENABLE,
-	       &ICOM_PORT->dram->CmdReg);
+		&ICOM_PORT->dram->CmdReg);
 
 	shutdown(ICOM_PORT);
 
@@ -1092,8 +1083,8 @@ static void icom_close(struct uart_port 
 }
 
 static void icom_set_termios(struct uart_port *port,
-			     struct ktermios *termios,
-			     struct ktermios *old_termios)
+	struct ktermios *termios,
+	struct ktermios *old_termios)
 {
 	int baud;
 	unsigned cflag, iflag;
@@ -1155,8 +1146,8 @@ static void icom_set_termios(struct uart
 
 	/* Determine divisor based on baud rate */
 	baud = uart_get_baud_rate(port, termios, old_termios,
-				  icom_acfg_baud[0],
-				  icom_acfg_baud[BAUD_TABLE_LIMIT]);
+		icom_acfg_baud[0],
+		icom_acfg_baud[BAUD_TABLE_LIMIT]);
 	if (!baud)
 		baud = 9600;	/* B0 transition handled in rs_set_termios */
 
@@ -1183,7 +1174,7 @@ static void icom_set_termios(struct uart
 	ICOM_PORT->read_status_mask = SA_FLAGS_OVERRUN | SA_FL_RCV_DONE;
 	if (iflag & INPCK)
 		ICOM_PORT->read_status_mask |=
-		    SA_FLAGS_FRAME_ERROR | SA_FLAGS_PARITY_ERROR;
+			SA_FLAGS_FRAME_ERROR | SA_FLAGS_PARITY_ERROR;
 
 	if ((iflag & BRKINT) || (iflag & PARMRK))
 		ICOM_PORT->read_status_mask |= SA_FLAGS_BREAK_DET;
@@ -1194,7 +1185,7 @@ static void icom_set_termios(struct uart
 	ICOM_PORT->ignore_status_mask = 0;
 	if (iflag & IGNPAR)
 		ICOM_PORT->ignore_status_mask |=
-		    SA_FLAGS_PARITY_ERROR | SA_FLAGS_FRAME_ERROR;
+			SA_FLAGS_PARITY_ERROR | SA_FLAGS_FRAME_ERROR;
 	if (iflag & IGNBRK) {
 		ICOM_PORT->ignore_status_mask |= SA_FLAGS_BREAK_DET;
 		/*
@@ -1225,7 +1216,7 @@ static void icom_set_termios(struct uart
 		ICOM_PORT->statStg->rcv[rcv_buff].flags = 0;
 		ICOM_PORT->statStg->rcv[rcv_buff].leLength = 0;
 		ICOM_PORT->statStg->rcv[rcv_buff].WorkingLength =
-		    (unsigned short int) cpu_to_le16(RCV_BUFF_SZ);
+			(unsigned short int) cpu_to_le16(RCV_BUFF_SZ);
 	}
 
 	for (xmit_buff = 0; xmit_buff < NUM_XBUFFS; xmit_buff++) {
@@ -1253,15 +1244,15 @@ static void icom_set_termios(struct uart
 
 	/* Enable Transmitter and Reciever */
 	offset =
-	    (unsigned long) &ICOM_PORT->statStg->rcv[0] -
-	    (unsigned long) ICOM_PORT->statStg;
+		(unsigned long) &ICOM_PORT->statStg->rcv[0] -
+		(unsigned long) ICOM_PORT->statStg;
 	writel(ICOM_PORT->statStg_pci + offset,
-	       &ICOM_PORT->dram->RcvStatusAddr);
+		&ICOM_PORT->dram->RcvStatusAddr);
 	ICOM_PORT->next_rcv = 0;
 	ICOM_PORT->put_length = 0;
 	*ICOM_PORT->xmitRestart = 0;
 	writel(ICOM_PORT->xmitRestart_pci,
-	       &ICOM_PORT->dram->XmitStatusAddr);
+		&ICOM_PORT->dram->XmitStatusAddr);
 	trace(ICOM_PORT, "XR_ENAB", 0);
 	writeb(CMD_XMIT_RCV_ENABLE, &ICOM_PORT->dram->CmdReg);
 
@@ -1352,7 +1343,7 @@ static int __devinit icom_init_ports(str
 			icom_adapter->port_info[0].status = ICOM_PORT_ACTIVE;
 
 			if (subsystem_id ==
-			    PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM) {
+				PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM) {
 				icom_adapter->port_info[0].imbed_modem = ICOM_IMBED_MODEM;
 			} else {
 				icom_adapter->port_info[0].imbed_modem = ICOM_RVX;
@@ -1375,15 +1366,15 @@ static void icom_port_active(struct icom
 	if (icom_adapter->version == ADAPTER_V1) {
 		icom_port->global_reg = icom_adapter->base_addr + 0x4000;
 		icom_port->int_reg = icom_adapter->base_addr +
-		    0x4004 + 2 - 2 * port_num;
+			0x4004 + 2 - 2 * port_num;
 	} else {
 		icom_port->global_reg = icom_adapter->base_addr + 0x8000;
 		if (icom_port->port < 2)
 			icom_port->int_reg = icom_adapter->base_addr +
-			    0x8004 + 2 - 2 * icom_port->port;
+				0x8004 + 2 - 2 * icom_port->port;
 		else
 			icom_port->int_reg = icom_adapter->base_addr +
-			    0x8024 + 2 - 2 * (icom_port->port - 2);
+				0x8024 + 2 - 2 * (icom_port->port - 2);
 	}
 }
 static int __devinit icom_load_ports(struct icom_adapter *icom_adapter)
@@ -1399,7 +1390,7 @@ static int __devinit icom_load_ports(str
 		if (icom_port->status == ICOM_PORT_ACTIVE) {
 			icom_port_active(icom_port, icom_adapter, port_num);
 			icom_port->dram = icom_adapter->base_addr +
-					0x2000 * icom_port->port;
+				0x2000 * icom_port->port;
 
 			icom_port->adapter = icom_adapter;
 
@@ -1413,8 +1404,7 @@ static int __devinit icom_load_ports(str
 	return 0;
 }
 
-static int __devinit icom_alloc_adapter(struct icom_adapter
-					**icom_adapter_ref)
+static int __devinit icom_alloc_adapter(struct icom_adapter **icom_adapter_ref)
 {
 	int adapter_count = 0;
 	struct icom_adapter *icom_adapter;
@@ -1422,7 +1412,7 @@ static int __devinit icom_alloc_adapter(
 	struct list_head *tmp;
 
 	icom_adapter = (struct icom_adapter *)
-	    kzalloc(sizeof(struct icom_adapter), GFP_KERNEL);
+		kzalloc(sizeof(struct icom_adapter), GFP_KERNEL);
 
 	if (!icom_adapter) {
 		return -ENOMEM;
@@ -1430,8 +1420,8 @@ static int __devinit icom_alloc_adapter(
 
 	list_for_each(tmp, &icom_adapter_head) {
 		cur_adapter_entry =
-		    list_entry(tmp, struct icom_adapter,
-			       icom_adapter_entry);
+			list_entry(tmp, struct icom_adapter,
+				icom_adapter_entry);
 		if (cur_adapter_entry->index != adapter_count) {
 			break;
 		}
@@ -1461,10 +1451,10 @@ static void icom_remove_adapter(struct i
 
 		if (icom_port->status == ICOM_PORT_ACTIVE) {
 			dev_info(&icom_adapter->pci_dev->dev,
-				 "Device removed\n");
+				"Device removed\n");
 
 			uart_remove_one_port(&icom_uart_driver,
-					     &icom_port->uart_port);
+				&icom_port->uart_port);
 
 			/* be sure that DTR and RTS are dropped */
 			writeb(0x00, &icom_port->dram->osr);
@@ -1498,32 +1488,32 @@ static struct kobj_type icom_kobj_type =
 };
 
 static int __devinit icom_probe(struct pci_dev *dev,
-				const struct pci_device_id *ent)
+	const struct pci_device_id *ent)
 {
 	int index;
-        unsigned int command_reg;
-        int retval;
-        struct icom_adapter *icom_adapter;
-        struct icom_port *icom_port;
+	unsigned int command_reg;
+	int retval;
+	struct icom_adapter *icom_adapter;
+	struct icom_port *icom_port;
 
-        retval = pci_enable_device(dev);
-        if (retval) {
+	retval = pci_enable_device(dev);
+	if (retval) {
 		dev_err(&dev->dev, "Device enable FAILED\n");
-                return retval;
+		return retval;
 	}
 
 	if ( (retval = pci_request_regions(dev, "icom"))) {
-		 dev_err(&dev->dev, "pci_request_regions FAILED\n");
-		 pci_disable_device(dev);
-		 return retval;
-	 }
+		dev_err(&dev->dev, "pci_request_regions FAILED\n");
+		pci_disable_device(dev);
+		return retval;
+	}
 
-        pci_set_master(dev);
+	pci_set_master(dev);
 
-        if ( (retval = pci_read_config_dword(dev, PCI_COMMAND, &command_reg))) {
+	if ( (retval = pci_read_config_dword(dev, PCI_COMMAND, &command_reg))) {
 		dev_err(&dev->dev, "PCI Config read FAILED\n");
-                return retval;
-        }
+		return retval;
+	}
 
 	pci_write_config_dword(dev, PCI_COMMAND,
 		command_reg | PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER
@@ -1531,24 +1521,22 @@ static int __devinit icom_probe(struct p
 
         if (ent->driver_data == ADAPTER_V1) {
 		pci_write_config_dword(dev, 0x44, 0x8300830A);
-	 } else {
+	} else {
 		pci_write_config_dword(dev, 0x44, 0x42004200);
 		pci_write_config_dword(dev, 0x48, 0x42004200);
-         }
-
+	}
 
 	retval = icom_alloc_adapter(&icom_adapter);
 	if (retval) {
-		 dev_err(&dev->dev, "icom_alloc_adapter FAILED\n");
-		 retval = -EIO;
-		 goto probe_exit0;
+		dev_err(&dev->dev, "icom_alloc_adapter FAILED\n");
+		retval = -EIO;
+		goto probe_exit0;
 	}
 
-	 icom_adapter->base_addr_pci = pci_resource_start(dev, 0);
-	 icom_adapter->pci_dev = dev;
-	 icom_adapter->version = ent->driver_data;
-	 icom_adapter->subsystem_id = ent->subdevice;
-
+	icom_adapter->base_addr_pci = pci_resource_start(dev, 0);
+	icom_adapter->pci_dev = dev;
+	icom_adapter->version = ent->driver_data;
+	icom_adapter->subsystem_id = ent->subdevice;
 
 	retval = icom_init_ports(icom_adapter);
 	if (retval) {
@@ -1556,22 +1544,22 @@ static int __devinit icom_probe(struct p
 		goto probe_exit1;
 	}
 
-	 icom_adapter->base_addr = ioremap(icom_adapter->base_addr_pci,
-						pci_resource_len(dev, 0));
+	icom_adapter->base_addr = ioremap(icom_adapter->base_addr_pci,
+		pci_resource_len(dev, 0));
 
 	if (!icom_adapter->base_addr)
 		goto probe_exit1;
 
 	 /* save off irq and request irq line */
-	 if ( (retval = request_irq(dev->irq, icom_interrupt,
-				   IRQF_DISABLED | IRQF_SHARED, ICOM_DRIVER_NAME,
-				   (void *) icom_adapter))) {
-		  goto probe_exit2;
-	 }
+	if ( (retval = request_irq(dev->irq, icom_interrupt,
+		IRQF_DISABLED | IRQF_SHARED, ICOM_DRIVER_NAME,
+		(void *) icom_adapter))) {
+		goto probe_exit2;
+	}
 
 	retval = icom_load_ports(icom_adapter);
 
-        for (index = 0; index < icom_adapter->numb_ports; index++) {
+	for (index = 0; index < icom_adapter->numb_ports; index++) {
 		icom_port = &icom_adapter->port_info[index];
 
 		if (icom_port->status == ICOM_PORT_ACTIVE) {
@@ -1579,16 +1567,16 @@ static int __devinit icom_probe(struct p
 			icom_port->uart_port.type = PORT_ICOM;
 			icom_port->uart_port.iotype = UPIO_MEM;
 			icom_port->uart_port.membase =
-					       (char *) icom_adapter->base_addr_pci;
+				(char *) icom_adapter->base_addr_pci;
 			icom_port->uart_port.fifosize = 16;
 			icom_port->uart_port.ops = &icom_ops;
 			icom_port->uart_port.line =
-		        icom_port->port + icom_adapter->index * 4;
+				icom_port->port + icom_adapter->index * 4;
 			if (uart_add_one_port (&icom_uart_driver, &icom_port->uart_port)) {
 				icom_port->status = ICOM_PORT_OFF;
 				dev_err(&dev->dev, "Device add failed\n");
-			 } else
-			        dev_info(&dev->dev, "Device added\n");
+			} else
+				dev_info(&dev->dev, "Device added\n");
 		}
 	}
 
@@ -1605,9 +1593,7 @@ probe_exit0:
 	pci_release_regions(dev);
 	pci_disable_device(dev);
 
-        return retval;
-
-
+return retval;
 }
 
 static void __devexit icom_remove(struct pci_dev *dev)
@@ -1617,7 +1603,7 @@ static void __devexit icom_remove(struct
 
 	list_for_each(tmp, &icom_adapter_head) {
 		icom_adapter = list_entry(tmp, struct icom_adapter,
-					  icom_adapter_entry);
+			icom_adapter_entry);
 		if (icom_adapter->pci_dev == dev) {
 			kobject_put(&icom_adapter->kobj);
 			return;
@@ -1663,7 +1649,7 @@ module_exit(icom_exit);
 
 #ifdef ICOM_TRACE
 static inline void trace(struct icom_port *icom_port, char *trace_pt,
-		  unsigned long trace_data)
+	unsigned long trace_data)
 {
 	dev_info(&icom_port->adapter->pci_dev->dev, ":%d:%s - %lx\n",
 		 icom_port->port, trace_pt, trace_data);
@@ -1673,6 +1659,6 @@ static inline void trace(struct icom_por
 MODULE_AUTHOR("Michael Anderson <mjanders@us.ibm.com>");
 MODULE_DESCRIPTION("IBM iSeries Serial IOA driver");
 MODULE_SUPPORTED_DEVICE
-    ("IBM iSeries 2745, 2771, 2772, 2742, 2793 and 2805 Communications adapters");
+	("IBM iSeries 2745, 2771, 2772, 2742, 2793 and 2805 Communications adapters");
 MODULE_LICENSE("GPL");
 

--------------050406060502020506010401--
