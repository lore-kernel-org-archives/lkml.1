Return-Path: <linux-kernel-owner+w=401wt.eu-S1765438AbXFRUdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765438AbXFRUdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763449AbXFRUdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:33:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33431 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763180AbXFRUdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:33:39 -0400
Date: Mon, 18 Jun 2007 13:33:12 -0700
From: Greg KH <greg@kroah.com>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-usb-users@lists.sourceforge.net
Subject: Re: [Linux-usb-users] Stable identification of identical USB
	hardware
Message-ID: <20070618203312.GA13990@kroah.com>
References: <157636.91774.qm@web51404.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157636.91774.qm@web51404.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 08:35:35AM -0700, Joerg Pommnitz wrote:
> Hello all,
> I want to be able to distinguish between two (or more) mostly
> identical USB serial devices. The devices in question are UMTS modems.
> AFAIK they are identical except for the SIM card and the point of
> attachment. Externally the cards are CardBus devices with an
> integrated USB host adapter. The actual UMTS device is (internally)
> connected to the USB host adapter.
> 
> If I have to cardbus sockets, how do I get from what I know ("the card
> is in socket 0") to "I have to talk to ttyUSB2 to talk to the card"? I
> suspect I have to follow the thread from /sys/bus/pci to
> /sys/bus/usb/devices, but how exactly?

Walk up the "chain" of devices in sysfs and in udev.  The udev man pages
and documentation should show you how to do this.  If you have specific
questions about this, please ask them on the linux-hotplug-devel mailing
list.

hope this helps,
greg k-h
