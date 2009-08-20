Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbZHTFoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbZHTFoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 01:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbZHTFoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 01:44:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:51364 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751300AbZHTFoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 01:44:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18p+GllaVwpfBdOMr08IxL0rdMaolNh0MHHfS/zMI
	WcbCevISJq3s3o
Subject: Re: [PATCH 00/22] Staging: rt{286,287,307}0: various fixes/cleanups
From: Mike Galbraith <efault@gmx.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200908192125.59395.bzolnier@gmail.com>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
	 <1250480865.7243.15.camel@marge.simson.net>
	 <200908192125.59395.bzolnier@gmail.com>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 07:44:01 +0200
Message-Id: <1250747041.7517.33.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 21:25 +0200, Bartlomiej Zolnierkiewicz wrote: 

> Thanks a lot for extra testing, could you also check what MAC version is
> this beast using?  I'm now working on merging rt2870 and rt3070 together,
> and I would need somebody with 2870 flavor to verify the end result.. :)
> 
> The USB dongle that I'm doing tests with is:
> 
> 	Bus 004 Device 003: ID 148f:3070 Ralink Technology, Corp.
> 
> and is identified by rt2800usb as 3070 flavor:
> 
> 	phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1600, rf: 0005, rev: 30700200.

phy1 -> rt2x00_set_chip: Info - Chipset detected - rt: 1600, rf: 0003, rev: 28600101.

This doesn't tell me whole lot, 2860 is allegedly PCI, my gizmo is USB.
(maybe i should poke it with sharp stick... nah, not bored enough)

USB device ID is 13D3:3247, which is supported by both 2870 and 3070
drivers, though it's associated with AzureWave instead of IMC Networks
as reported by lsusb.  In the 3070 section of 2870.h however, I see...

        {USB_DEVICE(0x13D3,0x3247)}, /* AzureWave */    \
        {USB_DEVICE(0x13D3,0x3273)}, /* AzureWave 3070*/        \

... so _maybe_ it's a 2870.

	-Mike

