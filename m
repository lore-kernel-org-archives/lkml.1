Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbYELQSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbYELQSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 12:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYELQSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 12:18:30 -0400
Received: from a0048.abansys.com ([86.109.162.218]:37266 "EHLO
	a0048.abansys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbYELQS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 12:18:29 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2008 12:18:28 EDT
Message-ID: <48286C3E.90705@t2i.es>
Date: Mon, 12 May 2008 18:11:42 +0200
From: =?ISO-8859-1?Q?Ignacio_Garc=EDa_P=E9rez?= <iggarpe@t2i.es>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [2.6 patch] serial: support for InstaShield IS-400 four port RS-232
 PCI card.
Content-Type: multipart/mixed;
 boundary="------------040602000400010704050503"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040602000400010704050503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

From: Ignacio García Pérez

Description:
Adds support for the InstaShield IS-400 four port RS-232 PCI card.

Signed-off-by: Ignacio García Pérez <iggarpe@t2i.com>

---

The patch is pretty simple. No code, little more than just the PCI 
vendor/product id.

Thorougly tested and working.

Applies to kernels 2.6.22, 2.6.23, 2.6.24 and 2.6.25.

---

diff -pruN linux-2.6.24.6/drivers/serial/8250_pci.c 
linux-2.6.24.6-modified/drivers/serial/8250_pci.c
--- linux-2.6.24.6/drivers/serial/8250_pci.c    2008-05-01 
23:50:00.000000000 +0200
+++ linux-2.6.24.6-modified/drivers/serial/8250_pci.c    2008-05-05 
21:03:27.000000000 +0200
@@ -2566,7 +2566,12 @@ static struct pci_device_id serial_pci_t
     {    PCI_VENDOR_ID_INTASHIELD, PCI_DEVICE_ID_INTASHIELD_IS200,
         PCI_ANY_ID, PCI_ANY_ID, 0, 0,    /* 135a.0811 */
         pbn_b2_2_115200 },
-
+    /*
+     * IntaShield IS-400
+     */
+    {    PCI_VENDOR_ID_INTASHIELD, PCI_DEVICE_ID_INTASHIELD_IS400,
+        PCI_ANY_ID, PCI_ANY_ID, 0, 0,    /* 135a.0dc0 */
+        pbn_b2_4_115200 },
     /*
      * Perle PCI-RAS cards
      */
diff -pruN linux-2.6.24.6/include/linux/pci_ids.h 
linux-2.6.24.6-modified/include/linux/pci_ids.h
--- linux-2.6.24.6/include/linux/pci_ids.h    2008-05-01 
23:50:00.000000000 +0200
+++ linux-2.6.24.6-modified/include/linux/pci_ids.h    2008-05-05 
21:03:27.000000000 +0200
@@ -1759,6 +1759,7 @@
 
 #define PCI_VENDOR_ID_INTASHIELD    0x135a
 #define PCI_DEVICE_ID_INTASHIELD_IS200    0x0d80
+#define PCI_DEVICE_ID_INTASHIELD_IS400    0x0dc0
 
 #define PCI_VENDOR_ID_QUATECH        0x135C
 #define PCI_DEVICE_ID_QUATECH_QSC100    0x0010


--------------040602000400010704050503
Content-Type: text/x-vcard; charset=utf-8;
 name="iggarpe.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iggarpe.vcf"

begin:vcard
fn;quoted-printable:Ignacio Garc=C3=ADa P=C3=A9rez
n;quoted-printable:Garc=C3=ADa P=C3=A9rez;Ignacio
org;quoted-printable:T2i, Ingenier=C3=ADa Integral en Tecnolog=C3=ADa y Telecomunicaciones
adr;quoted-printable;quoted-printable:;;C/. Pur=C3=ADsima 23, puerta 3;B=C3=A9tera;Valencia;46117;SPAIN
email;internet:iggarpe@t2i.es
title:Director I+D+i
tel;fax:+34 961602842
tel;cell:+34 619311995
url:www.t2i.es
version:2.1
end:vcard


--------------040602000400010704050503--
