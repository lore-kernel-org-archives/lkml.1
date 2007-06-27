Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbXF0OMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbXF0OMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbXF0OMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:12:46 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:57820 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbXF0OMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:12:45 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Clemens Koller <clemens.koller@anagramm.de>
Subject: Re: 2.6.21.5 BUG: USB FTDI FT323BM usb exports duplicate symbols
Date: Wed, 27 Jun 2007 16:12:45 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <46826EA3.2020707@anagramm.de>
In-Reply-To: <46826EA3.2020707@anagramm.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706271612.46175.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 27. Juni 2007 schrieb Clemens Koller:
> Whenever I plug/unplug the FTDI FT232BM USB-RS232 converter, the latest
> 2.6.21.5 kernel complains:
> 
> usb 2-1: USB disconnect, address 7
> ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
> ftdi_sio 2-1:1.0: device disconnected
> usb 3-1: new full speed USB device using ohci_hcd and address 43
> usb 3-1: configuration #1 chosen from 1 choice
> ftdi_sio 3-1:1.0: FTDI USB Serial Device converter detected
> drivers/usb/serial/ftdi_sio.c: Detected FT232BM
> usb 3-1: FTDI USB Serial Device converter now attached to ttyUSB0
> usbcore: exports duplicate symbol usb_buffer_unmap_sg (owned by kernel)
> usbserial: exports duplicate symbol usb_serial_port_softint (owned by kernel)

Please rebuild your kernel and modules from scratch. It looks like you are
mixing builds.

	Regards
		Oliver

