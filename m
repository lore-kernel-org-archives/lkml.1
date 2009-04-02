Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbZDBErU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbZDBErU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZDBErK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:47:10 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:29016 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZDBErI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:47:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LJ50qkmDnyucukqzUAD6mrNOFPMR9AJV5S3IF80wAxmiyHXIbxQkriM479DIuULXNA
         ME4TmwBXpmU8q8Vw1foVbJaMZ5/f2ONK0QxYBW/hlAaiwzdflfNOpc5rWqDKshLnOyio
         OJidziyMl7QFskOIYOy0cQscJVgVklEG6DHR0=
MIME-Version: 1.0
Date: Thu, 2 Apr 2009 00:47:05 -0400
Message-ID: <d68f80d90904012147x57ab186bp4b96ddfc56335d95@mail.gmail.com>
Subject: cleanup: usb_serial_port: update struct comments
From: Leandro Dorileo <ldorileo@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

updates some usb_serial_port members documentation.

Signed-off-by: Leandro Dorileo <ldorileo@gmail.com>
---
 include/linux/usb/serial.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index b958425..625e9e4 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -29,7 +29,7 @@
 /**
  * usb_serial_port: structure for the specific ports of a device.
  * @serial: pointer back to the struct usb_serial owner of this port.
- * @tty: pointer to the corresponding tty for this port.
+ * @port: pointer to the corresponding tty_port for this port.
  * @lock: spinlock to grab when updating portions of this structure.
  * @mutex: mutex used to synchronize serial_open() and serial_close()
  *	access for this port.
@@ -44,19 +44,22 @@
  * @interrupt_out_endpointAddress: endpoint address for the interrupt out pipe
  * 	for this port.
  * @bulk_in_buffer: pointer to the bulk in buffer for this port.
+ * @bulk_in_size: the size of the bulk_in_buffer, in bytes.
  * @read_urb: pointer to the bulk in struct urb for this port.
  * @bulk_in_endpointAddress: endpoint address for the bulk in pipe for this
  *	port.
  * @bulk_out_buffer: pointer to the bulk out buffer for this port.
  * @bulk_out_size: the size of the bulk_out_buffer, in bytes.
  * @write_urb: pointer to the bulk out struct urb for this port.
+ * @write_urb_busy: port`s writing status
  * @bulk_out_endpointAddress: endpoint address for the bulk out pipe for this
  *	port.
  * @write_wait: a wait_queue_head_t used by the port.
  * @work: work queue entry for the line discipline waking up.
- * @open_count: number of times this port has been opened.
  * @throttled: nonzero if the read urb is inactive to throttle the device
  * @throttle_req: nonzero if the tty wants to throttle us
+ * @console: attached usb serial console
+ * @dev: pointer to the serial device
  *
  * This structure is used by the usb-serial core and drivers for the specific
  * ports of a device.
-- 
1.6.2.1


-- 
(°=   Leandro Dorileo
//\    ldorileo@gmail.com   -   http://www.dorilex.net
V_/  Software is a matter of freedom.
