Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbXLLQbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbXLLQbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbXLLQax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:30:53 -0500
Received: from nikita.holtmann.net ([62.75.245.128]:53128 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbXLLQaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:30:52 -0500
X-Greylist: delayed 1295 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2007 11:30:52 EST
Subject: Re: 2.6.24-rc4: bluetooth device gone after suspend to ram
From: Marcel Holtmann <marcel@holtmann.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200712121252.54061.oliver@neukum.org>
References: <1197455517.8814.10.camel@localhost>
	 <200712121252.54061.oliver@neukum.org>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 17:08:47 +0100
Message-Id: <1197475727.5644.20.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

> > I noticed that on my macbook pro1,1 the bluetooth device is gone after
> > suspend to ram, i.e.
> 
> Is this a regression?
> Does it work if you unload hci_usb before you suspend?
> If so, please recompile with CONFIG_USB_DEBUG and provide
> dmesg.

sometimes ACPI is involved and will killswitch the Bluetooth device on
suspend. Sometimes the distros to a manual killswitch. And in case of
Bluetooth a killswitch means physically removing the power from the
device.

In case of a MacBook it can happen that this device goes back into HID
mode and thus you need to call hid2hci.

Regards

Marcel


