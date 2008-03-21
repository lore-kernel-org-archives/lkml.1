Return-Path: <linux-kernel-owner+w=401wt.eu-S1765218AbYCUXEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765218AbYCUXEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763761AbYCUWvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:51:12 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59383 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763782AbYCUWvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:51:06 -0400
Message-Id: <20080321224432.486794198@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:45 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, gregkh@suse.de
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sven Andersen <s.andersen@cryonet.de>
Subject: [patch 55/76] USB: ftdi_sio - really enable EM1010PC
Content-Disposition: inline; filename=usb-ftdi_sio-really-enable-em1010pc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Sven Andersen <s.andersen@cryonet.de>

[upstream commit: 4ae897df]

Add EM1010PC to ftdi_sio.c

Signed-off-by: Sven Andersen <s.andersen@cryonet.de>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/usb/serial/ftdi_sio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -499,6 +499,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_FS20SIG_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_WS300PC_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_FHZ1300PC_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_EM1010PC_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_WS500_PID) },
 	{ USB_DEVICE(FTDI_VID, LINX_SDMUSBQSS_PID) },
 	{ USB_DEVICE(FTDI_VID, LINX_MASTERDEVEL2_PID) },

-- 
