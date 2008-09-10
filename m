Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYIJOS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYIJOS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYIJOSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:18:50 -0400
Received: from 81-7-68-229.static.zebra.lt ([81.7.68.229]:46098 "EHLO
	teltonika.lt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbYIJOSt (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:18:49 -0400
Message-ID: <48C7D746.9070100@teltonika.lt>
Date: Wed, 10 Sep 2008 17:18:46 +0300
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: Linux-kernel@vger.kernel.org
Subject: [PATCH] ftdi_sio: fix 'product' parameter description
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>

Index: linux-2.6/drivers/usb/serial/ftdi_sio.c
===================================================================
--- linux-2.6.orig/drivers/usb/serial/ftdi_sio.c
+++ linux-2.6/drivers/usb/serial/ftdi_sio.c
@@ -2452,5 +2452,5 @@ module_param(vendor, ushort, 0);
  MODULE_PARM_DESC(vendor, "User specified vendor ID (default="
  		__MODULE_STRING(FTDI_VID)")");
  module_param(product, ushort, 0);
-MODULE_PARM_DESC(vendor, "User specified product ID");
+MODULE_PARM_DESC(product, "User specified product ID");


