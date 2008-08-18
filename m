Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbYHRSxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbYHRSxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760186AbYHRSwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:52:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:35184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760177AbYHRSwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:52:31 -0400
Date: Mon, 18 Aug 2008 11:43:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Andre Schenk <andre@melior.s.bawue.de>
Subject: [patch 19/60] USB: ftdi_sio: Add USB Product Id for ELV HS485
Message-ID: <20080818184307.GT29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-ftdi_sio-add-usb-product-id-for-elv-hs485.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andre Schenk <andre@melior.s.bawue.de>

commit b5894a500127fce1db1309db5f9ca8b77a2ac266 upstream

USB product id registration for the ELV HS485 USB adapter (www.elv.de) to
their home automation bus system. Applies to 2.6.26.

Signed-off-by: Andre Schenk <andre@melior.s.bawue.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    1 +
 drivers/usb/serial/ftdi_sio.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -553,6 +553,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_FHZ1300PC_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_EM1010PC_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_WS500_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_HS485_PID) },
 	{ USB_DEVICE(FTDI_VID, LINX_SDMUSBQSS_PID) },
 	{ USB_DEVICE(FTDI_VID, LINX_MASTERDEVEL2_PID) },
 	{ USB_DEVICE(FTDI_VID, LINX_FUTURE_0_PID) },
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -524,6 +524,7 @@
 #define FTDI_ELV_WS300PC_PID	0xE0F6	/* PC-Wetterstation (WS 300 PC) */
 #define FTDI_ELV_FHZ1300PC_PID	0xE0E8	/* FHZ 1300 PC */
 #define FTDI_ELV_WS500_PID	0xE0E9	/* PC-Wetterstation (WS 500) */
+#define FTDI_ELV_HS485_PID	0xE0EA	/* USB to RS-485 adapter */
 #define FTDI_ELV_EM1010PC_PID	0xE0EF	/* Engery monitor EM 1010 PC */
 
 /*

-- 
