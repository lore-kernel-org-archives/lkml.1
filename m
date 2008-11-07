Return-Path: <linux-kernel-owner+w=401wt.eu-S1752370AbYKGI32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbYKGI32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 03:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYKGI3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 03:29:18 -0500
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:49272 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929AbYKGI3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 03:29:17 -0500
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: "Yang, Libin" <Libin.Yang@amd.com>
Subject: Re: 2.6.27: ehci bug with AMD 770nb/SB700 southbridge. usb lockup
Date: Fri, 7 Nov 2008 09:27:56 +0100
User-Agent: KMail/1.10.90 (Linux/2.6.27.4r4; KDE/4.1.71; x86_64; ; )
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, "Huang, Shane" <Shane.Huang@amd.com>
References: <200810300215.18792.volker.armin.hemmann@tu-clausthal.de> <20081030055410.GB19035@kroah.com> <B90463BC30D2E446BA423D888DC85E50E8C0EB@sshaexmb1.amd.com>
In-Reply-To: <B90463BC30D2E446BA423D888DC85E50E8C0EB@sshaexmb1.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811070927.57506.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
when I load ohci-hcd first and ehci-hcd second and make sure that the usb-port 
for the mouse does not share its interrupt with the graphic card, everything 
works (almost) fine. With big transfers from or to a harddisk in an enclosure 
the mouse is sometimes a bit jerky.

Bus 007 Device 001: ID 1d6b:0002
Bus 006 Device 004: ID 05e3:0702 Genesys Logic, Inc. USB 2.0 IDE Adapter
Bus 006 Device 002: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
Bus 006 Device 001: ID 1d6b:0002
Bus 005 Device 001: ID 1d6b:0001
Bus 004 Device 001: ID 1d6b:0001
Bus 003 Device 001: ID 1d6b:0001
Bus 002 Device 001: ID 1d6b:0001
Bus 001 Device 005: ID 046d:c518 Logitech, Inc. MX610 Laser Cordless Mouse
Bus 001 Device 001: ID 1d6b:0001

bus 1 is ohci.
bus 6 is ehci.

But if the mouse is connected to a ehci port or the ehci hub, as soon as data 
transfers from or to an usb connected storage device starts, it will lock up.
