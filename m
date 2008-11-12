Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbYKLCOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbYKLCOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 21:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbYKLCOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 21:14:08 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:16731 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbYKLCOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 21:14:06 -0500
X-BigFish: VPS-60(z21eWz1432R936eQ1805M936fO3117K9371P542Nzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KA77IK-04-0MM-01
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.27: ehci bug with AMD 770nb/SB700 southbridge. usb lockup
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Wed, 12 Nov 2008 10:13:39 +0800
Message-ID: <6077B97E85E7374DAE87B42B5AA9979709BBA3@sshaexmb1.amd.com>
In-Reply-To: <200811070927.57506.volker.armin.hemmann@tu-clausthal.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.27: ehci bug with AMD 770nb/SB700 southbridge. usb lockup
Thread-Index: AclAsvD3gaLJz47fQfesFIuxokTKlQDuP29g
References: <200810300215.18792.volker.armin.hemmann@tu-clausthal.de> <20081030055410.GB19035@kroah.com> <B90463BC30D2E446BA423D888DC85E50E8C0EB@sshaexmb1.amd.com> <200811070927.57506.volker.armin.hemmann@tu-clausthal.de>
From: "Yang, Libin" <Libin.Yang@amd.com>
To: "Volker Armin Hemmann" <volker.armin.hemmann@tu-clausthal.de>
CC: "Greg KH" <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, "Huang, Shane" <Shane.Huang@amd.com>
X-OriginalArrivalTime: 12 Nov 2008 02:13:43.0113 (UTC) FILETIME=[4925A390:01C9446C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Volker,

Can you help dump out the PCI configuration information with lspci
-xxxx? Thanks.

Thanks & Regards,
Libin

> -----Original Message-----
> From: Volker Armin Hemmann
[mailto:volker.armin.hemmann@tu-clausthal.de]
> Sent: Friday, November 07, 2008 4:28 PM
> To: Yang, Libin
> Cc: Greg KH; linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org;
> Huang, Shane
> Subject: Re: 2.6.27: ehci bug with AMD 770nb/SB700 southbridge. usb
lockup
> 
> Hi,
> when I load ohci-hcd first and ehci-hcd second and make sure that the
usb-
> port
> for the mouse does not share its interrupt with the graphic card,
> everything
> works (almost) fine. With big transfers from or to a harddisk in an
> enclosure
> the mouse is sometimes a bit jerky.
> 
> Bus 007 Device 001: ID 1d6b:0002
> Bus 006 Device 004: ID 05e3:0702 Genesys Logic, Inc. USB 2.0 IDE
Adapter
> Bus 006 Device 002: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port
HUB
> Bus 006 Device 001: ID 1d6b:0002
> Bus 005 Device 001: ID 1d6b:0001
> Bus 004 Device 001: ID 1d6b:0001
> Bus 003 Device 001: ID 1d6b:0001
> Bus 002 Device 001: ID 1d6b:0001
> Bus 001 Device 005: ID 046d:c518 Logitech, Inc. MX610 Laser Cordless
Mouse
> Bus 001 Device 001: ID 1d6b:0001
> 
> bus 1 is ohci.
> bus 6 is ehci.
> 
> But if the mouse is connected to a ehci port or the ehci hub, as soon
as
> data
> transfers from or to an usb connected storage device starts, it will
lock
> up.


