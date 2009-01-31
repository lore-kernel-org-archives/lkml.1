Return-Path: <linux-kernel-owner+w=401wt.eu-S1761897AbZAaDG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761897AbZAaDG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbZAaCri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:38 -0500
Received: from kroah.org ([198.145.64.141]:55415 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753211AbZAaCr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:29 -0500
Date: Fri, 30 Jan 2009 18:42:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Flavio Leitner <fleitner@redhat.com>,
       Alan Cox <alan@redhat.com>
Subject: [patch 22/43] serial_8250: support for Sealevel Systems Model 7803
	COMM+8
Message-ID: <20090131024259.GW12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="serial_8250-support-for-sealevel-systems-model-7803-comm-8.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Flavio Leitner <fleitner@redhat.com>

commit e65f0f8271b1b0452334e5da37fd35413a000de4 upstream.

Add support for Sealevel Systems Model 7803 COMM+8

Signed-off-by: Flavio Leitner <fleitner@redhat.com>
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250_pci.c |    3 +++
 include/linux/pci_ids.h   |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -2271,6 +2271,9 @@ static struct pci_device_id serial_pci_t
 	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_COMM8,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_8_115200 },
+	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_7803,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b2_8_460800 },
 	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_UCOMM8,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b2_8_115200 },
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1799,6 +1799,7 @@
 #define PCI_DEVICE_ID_SEALEVEL_UCOMM232	0x7202
 #define PCI_DEVICE_ID_SEALEVEL_COMM4	0x7401
 #define PCI_DEVICE_ID_SEALEVEL_COMM8	0x7801
+#define PCI_DEVICE_ID_SEALEVEL_7803	0x7803
 #define PCI_DEVICE_ID_SEALEVEL_UCOMM8	0x7804
 
 #define PCI_VENDOR_ID_HYPERCOPE		0x1365

