Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbXLLSX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbXLLSX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbXLLSXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:23:51 -0500
Received: from nn7.de ([85.214.94.156]:38292 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbXLLSXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:23:50 -0500
Subject: Re: 2.6.24-rc4: bluetooth device gone after suspend to ram
From: Soeren Sonnenburg <kernel@nn7.de>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Oliver Neukum <oliver@neukum.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1197475727.5644.20.camel@aeonflux>
References: <1197455517.8814.10.camel@localhost>
	 <200712121252.54061.oliver@neukum.org>  <1197475727.5644.20.camel@aeonflux>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Dec 2007 19:23:47 +0100
Message-Id: <1197483827.4492.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-12 at 17:08 +0100, Marcel Holtmann wrote:
> Hi Oliver,
> 
> > > I noticed that on my macbook pro1,1 the bluetooth device is gone after
> > > suspend to ram, i.e.
> > 
> > Is this a regression?
> > Does it work if you unload hci_usb before you suspend?
> > If so, please recompile with CONFIG_USB_DEBUG and provide
> > dmesg.

No it was always like this.

> sometimes ACPI is involved and will killswitch the Bluetooth device on
> suspend. Sometimes the distros to a manual killswitch. And in case of
> Bluetooth a killswitch means physically removing the power from the
> device.
> 
> In case of a MacBook it can happen that this device goes back into HID
> mode and thus you need to call hid2hci.

indeed after calling hid2hci the device is visible again via 
hciconfig -a

Thanks!!!
Soeren
