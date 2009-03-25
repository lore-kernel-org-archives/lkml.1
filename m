Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbZCYQBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbZCYQBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZCYQBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:01:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:48094 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbZCYQBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:01:38 -0400
Date: Wed, 25 Mar 2009 17:01:30 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Gene Heskett <gene.heskett@verizon.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bluetooth Q?
In-Reply-To: <200903210150.46294.gene.heskett@verizon.net>
Message-ID: <alpine.LRH.2.00.0903251700440.8561@twin.jikos.cz>
References: <200903210150.46294.gene.heskett@verizon.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009, Gene Heskett wrote:

> Where can I find the status of support for a usb-bt module that answers to 
> this:
> Mar 21 00:55:29 coyote kernel: [97026.014221] usb 2-5.1: new full speed USB device using ohci_hcd and address 8
> Mar 21 00:55:29 coyote kernel: [97026.103223] usb 2-5.1: New USB device found, idVendor=0e5e, idProduct=6622
> Mar 21 00:55:29 coyote kernel: [97026.103226] usb 2-5.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> Mar 21 00:55:29 coyote kernel: [97026.103308] usb 2-5.1: configuration #1 chosen from 1 choice

This device should be driven by btusb driver:

drivers/bluetooth/btusb.c:      { USB_DEVICE(0x0e5e, 0x6622), .driver_info = BTUSB_BROKEN_ISOC },

-- 
Jiri Kosina
SUSE Labs

