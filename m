Return-Path: <linux-kernel-owner+w=401wt.eu-S1761445AbXENAxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445AbXENAxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 20:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbXENAxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 20:53:11 -0400
Received: from smtp.bulldogdsl.com ([212.158.248.7]:4025 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754970AbXENAxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 20:53:10 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: converting appletouch to usb autosuspend...
Date: Mon, 14 May 2007 01:53:03 +0100
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>, maxk@qualcomm.com
References: <1178995886.4168.10.camel@localhost> <200705122247.44795.s0348365@sms.ed.ac.uk> <1179103570.26132.8.camel@localhost>
In-Reply-To: <1179103570.26132.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705140153.03084.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2007 01:46:10 Soeren Sonnenburg wrote:
> On Sat, 2007-05-12 at 22:47 +0100, Alistair John Strachan wrote:
> > On Saturday 12 May 2007 19:51:26 Soeren Sonnenburg wrote:
> > > Dear all,
>
> [...]
>
> > > While we are at it usb related powerhogs on this macbook pro are
> > > uhci_hcd (usb keyboard) and usb_hcd_poll_rh_status (rh_timer_func)
> > > too...
> >
> > I've found that hci_usb also hogs power on the Macbook; blacklisting this
> > module cuts down HZ considerably. I also found appletouch consumed ticks,
>
> I guess without loading appletouch ? Then there really is something in
> there that needs to be fixed..
>
> > just as you did.
>
> What did you use instead of hci_usb then ? usbkbd ? This won't give you
> the special keys etc...

Sorry, I wasn't clear. hci_usb is actually part of the BlueZ stack, it's got 
nothing to do with the keyboard. I unloaded both appletouch AND hci_usb.

> > uhci_hcd then drops to noise; my Macbook's sitting on 10W with the
> > backlight on minimum, which is about what it can manage in OS X on
> > maximum life settings.
>
> Thats quite some improvement...

Yes indeed. The only thing left to improve, as I understand it, is enabling 
the C4/C4e power states available on the Core 2 Duo, which don't currently 
seem to be utilised by Linux. I notice, however, that the screenshot on the 
Intel Powertop page does seem to have these states available?

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
