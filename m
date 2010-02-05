Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab0BGW6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 17:58:13 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:46617 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341Ab0BGW6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 17:58:06 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Fri, 5 Feb 2010 22:59:33 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: dvomlehn@cisco.com, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100117025535.GB7045@srcf.ucam.org> <201002032358.03552.oliver@neukum.org> <20100205195817.GA14285@srcf.ucam.org>
In-Reply-To: <20100205195817.GA14285@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002052259.33645.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 5. Februar 2010 20:58:17 schrieb Matthew Garrett:
> drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
> drivers/usb/serial/usb-serial.c: serial_write - port 0, 2048 byte(s)
> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 2048 bytes
> drivers/usb/serial/generic.c: usb_serial_generic_write - put 512 bytes into fifo
> drivers/usb/serial/usb-serial.c: serial_write - port 0, 1536 byte(s)
> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 1536 bytes
> drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes into fifo
> drivers/usb/serial/generic.c: usb_serial_generic_write - FIFO is full

OK, could you also get an usbmon trace? This would allow a determination
whether the submitted URB doesn't finish for some reason, or whether
no URB is submitted, possibly because a wakeup is missed.

	Regards
		Oliver
