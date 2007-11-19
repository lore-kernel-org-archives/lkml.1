Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbXKSROh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbXKSROh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 12:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbXKSRO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 12:14:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbXKSRO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 12:14:28 -0500
Subject: Re: libertas ub8xxx - bcdDevice 30.06 - firmware issues?
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: libertas-dev@lists.infradead.org,
       linux kernel <linux-kernel@vger.kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <43e72e890711161726m11682a2fwcaba31c2d093310f@mail.gmail.com>
References: <43e72e890711161726m11682a2fwcaba31c2d093310f@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 12:10:57 -0500
Message-Id: <1195492257.3248.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-6.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-16 at 20:26 -0500, Luis R. Rodriguez wrote:
> I have a USB libertas 1286:2001 with bcdDevice 30.06 (from lsusb -v).
> I tried downloading the firmware from marvell:
> 
> https://www.marvell.com/drivers/driverDisplay.do?dId=160&pId=38
> 
> renaming and to usb8388.bin and putting it in firmware dir. Is this
> the right firmware??

Yikes; really old.  You might want to try:

http://dev.laptop.org/pub/firmware/libertas/

Dan

> Upon load this is what I get:
> 
> 17:58 < mcgrof> usb8xxx: URB in failure status: -71
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb8xxx: probe of 4-1:1.0 failed with error -12
> 17:58 < mcgrof> usbcore: registered new interface driver usb8xxx
> 
> I'm using the compatibility package from:
> 
> http://linuxwireless.org/en/users/Download
> 
> on 2.6.22. So this driver reflects what's on
> wireless2.6.git#everything. I tried looking on the wiki but well can't
> find much information. Can we please start adding some info about this
> driver to:
> 
> http://linuxwireless.org/en/users/Drivers/libertas
> 
>   Luis
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev

