Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbXEJMNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbXEJMNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXEJMM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:12:56 -0400
Received: from neon.samage.net ([85.17.153.66]:59644 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbXEJMM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:12:56 -0400
Message-ID: <1358.81.207.0.53.1178799167.squirrel@secure.samage.net>
In-Reply-To: <20070510013855.GA3402@havoc.gtf.org>
References: <20070510013855.GA3402@havoc.gtf.org>
Date: Thu, 10 May 2007 14:12:47 +0200 (CEST)
Subject: Re: [git patch] move USB net drivers to drivers/net
From: "Indan Zupancic" <indan@nul.nu>
To: "Jeff Garzik" <jeff@garzik.org>, duncan.sands@free.fr
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: e462de357cb394d64966911c06262bc8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 10, 2007 03:38, Jeff Garzik wrote:
>
> This was ACK'd by Greg, as you see in the sign-offs.  See the commit
> below for rationale.
>
> USB is now treated like other buses, for network drivers:
> * USB network driver patches should go to me and netdev
> * Just like in PCI or PCMCIA land, bus-specific code may
>   originate from the USB side of the house (Greg's tree).
>
>
>
> Please pull from 'usb-move' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git usb-move
>
> to receive the following update:
>
>
> commit 5b2fc499917e5897a13add780e181b4cef197072
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Wed May 9 21:31:55 2007 -0400
>
>     Move USB network drivers to drivers/net/usb.
>
>     It is preferable to group drivers by usage (net, scsi, ATA, ...) than
>     by bus.  When reviewing drivers, the [PCI|USB|PCMCIA|...] maintainer
>     is probably less qualified on networking issues than a networking
>     maintainer.  Also, from a practical standpoint, chips often
>     appear on multiple buses, which is why we do not put drivers into
>     drivers/pci/net.

What about drivers/usb/atm/?

Greetings,

Indan


