Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZALTC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZALTC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZALTCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:02:47 -0500
Received: from mail.impinj.com ([206.169.229.170]:42960 "EHLO earth.impinj.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753789AbZALTCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:02:47 -0500
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Subject: Re: amd5536udc interrupts bug
Date: Mon, 12 Jan 2009 11:02:45 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.9-159.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <49661E83.2070703@arcor.de> <200901091440.15888.vlobanov@speakeasy.net> <496904E4.2000701@arcor.de>
In-Reply-To: <496904E4.2000701@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901121102.45783.vlobanov@speakeasy.net>
X-OriginalArrivalTime: 12 Jan 2009 19:02:46.0049 (UTC) FILETIME=[5ABF4910:01C974E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 January 2009 12:28:20 Thomas Dahlmann wrote:
> Vadim Lobanov schrieb:
> > Nope, nothing at all shows up in the logs or the interrupt counts when
> > the cable is plugged, neither for the host drivers nor the device
> > drivers. (The quickest test I have is to hook the device up to itself -
> > one A port and one B port.)
> >
> > The BIOS is configured "correctly" if the manuals are to be trusted. Here
> > are the relevant settings
> > 	OHCI: Enabled
> > 	EHCI: Enabled
> > 	UDC: Enabled
> > 	UOC: Disabled
> > 	Overcurrent reporting: Disabled
> > 	Port 4 assignment: Device
>
> UOC has to be enabled. This controller switches the UDC PHY to port 4
> and owns the mentioned
> PAD_EN and APU bits. These bits live in the memory mapped register space
> of UOC. I use a
> company intern tools to look at memory spaces of PCI devices. Lets
> forget these bits so far as I am
> pretty sure that enabling UOC fixes the problem.

That'll teach me for trusting the board vendor's documentation. :)

[ ... doing some tests ... ]

Unfortunately, however, even enabling UOC in the BIOS does not make the 
USB connection work. The symptoms are exactly the same as before.

I'm going to try to figure out how to get at those two bits, and also will 
start talking with the board vendor as well (since it's starting to look more 
and more like a BIOS and/or HW problem).

Thanks for your help so far!

