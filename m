Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYJDIsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYJDIsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 04:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYJDIsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 04:48:00 -0400
Received: from senator.holtmann.net ([87.106.208.187]:42783 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbYJDIr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 04:47:59 -0400
Subject: Re: USB disconnects every 30 seconds (2.6.27-rc8)
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Hansen <dave@sr71.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>, gregkh <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
In-Reply-To: <1223075214.7798.5.camel@nimitz>
References: <Pine.LNX.4.44L0.0810031608000.6462-100000@iolanthe.rowland.org>
	 <1223075214.7798.5.camel@nimitz>
Content-Type: text/plain
Date: Sat, 04 Oct 2008 10:48:06 +0200
Message-Id: <1223110086.11272.44.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> OK, here's output with both Thomas/Hugh's timing fix as well as the USB
> snooping turned on.  The disconnects still happen, but I did get some
> good snoop output:
> 
> Oct  3 16:01:59 nimitz kernel: [  180.273883] usb usb7: opened by process 6485: hald-addon-usb-
> Oct  3 16:01:59 nimitz kernel: [  180.273894] usb usb7: usbdev_ioctl: CONNECTINFO
> Oct  3 16:01:59 nimitz kernel: [  180.273935] usb usb7: opened by process 6485: hald-addon-usb-
> 
> grepping for hald:
> dave@nimitz:~$ ps aux | grep hald
> 111       6407  0.5  0.1   6340  4352 ?        Ss   15:59   0:00 /usr/sbin/hald
> root      6411  0.0  0.0   3348  1152 ?        S    15:59   0:00 hald-runner
> root      6485  0.1  0.0   2996  1140 ?        S    15:59   0:00 hald-addon-usb-csr: listening on 'MX700 Optical Mouse'
> ...
> 
> If I kill off 'hald-addon-usb-csr', then the resets stop happening.

the addon is for some weird handling of CSR based HID devices in their
Bluetooth/USB HID proxy devices or so.

Alan, that is the vendor request you saw. Don't ask me what exactly this
one does. I really have no idea.

Regards

Marcel


