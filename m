Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbYHFUdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbYHFUdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbYHFUaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:30:06 -0400
Received: from cpsmtpo-eml05.kpnxchange.com ([213.75.38.154]:23218 "EHLO
	cpsmtpo-eml05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbYHFUaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:30:01 -0400
From: Frans Pop <elendil@planet.nl>
To: me@felipebalbi.com
Subject: Re: [regression?] usb: new errors during device detection
Date: Wed, 6 Aug 2008 22:29:47 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
References: <200808032211.22483.elendil@planet.nl> <20080803203512.GA11185@frodo>
In-Reply-To: <20080803203512.GA11185@frodo>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808062229.48383.elendil@planet.nl>
X-OriginalArrivalTime: 06 Aug 2008 20:29:58.0158 (UTC) FILETIME=[31A582E0:01C8F803]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 August 2008, Felipe Balbi wrote:
> On Sun, Aug 03, 2008 at 10:11:21PM +0200, Frans Pop wrote:
> > +usb 3-1: new low speed USB device using uhci_hcd and address 2
> >  ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
> >  ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec
> > 2004 usb usb5: configuration #1 chosen from 1 choice
> >  hub 5-0:1.0: USB hub found
> > -usb 3-1: new low speed USB device using uhci_hcd and address 2
> > +usb 3-1: device not accepting address 2, error -71
> > +hub 3-0:1.0: unable to enumerate USB device on port 1
>
> what is this device attached to this port ?

Eh, that info is already trivially available from my original mail:
 uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[...]
 input: USB Compliant Keyboard as /class/input/input0
 input: USB HID v1.10 Keyboard [USB Compliant Keyboard] on usb-0000:00:1d.2-1
 input: USB Compliant Keyboard as /class/input/input1
 input: USB HID v1.10 Device [USB Compliant Keyboard] on usb-0000:00:1d.2-1

> Do you have the device attached before turning on the machine ?

Yes, obviously the keyboard is attached during boot (and has been connected
to the same USB port basically since I first installed the machine...).

> Does it happen if you boot without that device attached and attach
> it afterwards ?

No idea. I could try this I guess if it will really provide useful info.
Somehow I doubt that in this case.

> Can you please enable CONFIG_USB_DEBUG and resend dmesg output ?

Will include that in my reply to Alan's mail.

Cheers,
FJP
