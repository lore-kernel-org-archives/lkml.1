Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbXDWIK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbXDWIK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 04:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbXDWIK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 04:10:28 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:44898 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753624AbXDWIK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 04:10:26 -0400
Date: Mon, 23 Apr 2007 10:10:22 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: regression with gammu on 2.6.21-rc7
Message-ID: <20070423081022.GA25694@erig.dyndns.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20070420085853.GA5594@erig.dyndns.org> <20070423054717.GB17997@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423054717.GB17997@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On Sun, Apr 22, 2007 at 10:47:17PM -0700, Greg KH wrote:
> On Fri, Apr 20, 2007 at 10:58:53AM +0200, Wolfgang Erig wrote:
> > Hello,
> > 
> > I have a regression with 2.6.21-rc7-g80d74d51.
> > The utility "gammu" to talk to my mobile does not work anymore.
> > With 2.6.20 gammu runs fine.
> > 
> > Distribution is the latest Debian/testing
> > 
> > Wolfgang
> > 
> > $ gammu --backup backup
> > Press Ctrl+C to break...
> > I/O possible
the problem is here because gammu stops working.
Maybe a problem in gammu, but with 2.6.20 gammu works fine.
> > $ uname -a
> > Linux max 2.6.21-rc7-g80d74d51 #9 SMP Wed Apr 18 21:41:41 CEST 2007 i686 GNU/Linux
> > $ tail messages 
> > Apr 20 08:04:36 max kernel: ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
> > Apr 20 08:04:36 max kernel: extern: link up, 100Mbps, full-duplex, lpa 0x45E1
> > Apr 20 08:04:36 max kernel: intern:  setting half-duplex.
> > Apr 20 08:09:02 max kernel: usb 2-2: USB disconnect, address 3
> > Apr 20 08:09:02 max kernel: pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
> > Apr 20 08:09:02 max kernel: pl2303 2-2:1.0: device disconnected
> > Apr 20 08:10:24 max kernel: usb 2-2: new full speed USB device using uhci_hcd and address 4
> > Apr 20 08:10:25 max kernel: usb 2-2: configuration #1 chosen from 1 choice
> > Apr 20 08:10:25 max kernel: pl2303 2-2:1.0: pl2303 converter detected
> > Apr 20 08:10:25 max kernel: usb 2-2: pl2303 converter now attached to ttyUSB0
> 
> That looks ok, I'm guessing you yanked it out and then back in?
Yes.
This is included only to see which device is connected.
> Or is the problem that the device was removed?
No, no problem with removal.
I see no hint for a problem in the usb-layer.

Thanks,
Wolfgang
