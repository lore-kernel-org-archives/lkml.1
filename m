Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYLIVuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYLIVuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 16:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbYLIVuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 16:50:24 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:32844 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbYLIVuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 16:50:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EptE0AnSmzXxehCxSIY+PdiXVsVGhNZF/sLjzNTtSzIvV9Bja52Zoys27HUToQAVtz
         5Cwo447h2l+1hyyBsvVV5ygoskzE8B6p2x+T/V3ozjNjAm7LMyMO6wEsmm1Lg/aDSYoZ
         pX9wkwNSmfNJ9wLbp57UXfiCCOX6m6Hy9Ltl0=
Message-ID: <493EE81E.4050904@gmail.com>
Date: Tue, 09 Dec 2008 22:50:22 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 23/31] drivers/usb: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/usb/serial/usb_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/usb_debug.c b/drivers/usb/serial/usb_debug.c
index fc5d995..6c9cbb5 100644
--- a/drivers/usb/serial/usb_debug.c
+++ b/drivers/usb/serial/usb_debug.c
@@ -31,7 +31,7 @@ static struct usb_driver debug_driver = {
 	.no_dynamic_id = 	1,
 };
 
-int usb_debug_open(struct tty_struct *tty, struct usb_serial_port *port,
+static int usb_debug_open(struct tty_struct *tty, struct usb_serial_port *port,
 							struct file *filp)
 {
 	port->bulk_out_size = USB_DEBUG_MAX_PACKET_SIZE;

