Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbYAHGyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbYAHGyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 01:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYAHGxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 01:53:54 -0500
Received: from smurf.noris.de ([192.109.102.42]:54898 "EHLO smurf.noris.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbYAHGxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 01:53:53 -0500
X-Greylist: delayed 1561 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 01:53:53 EST
Date: Tue, 8 Jan 2008 07:27:39 +0100
From: Matthias Urlichs <smurf@smurf.noris.de>
To: =?utf-8?B?5byg6Z+h5q2m?= <zhangweiwu@realss.com>
Cc: linux-kernel@vger.kernel.org, hugh@blemings.org
Subject: Re: Huawei EC321 CDMA PCCARD support broken
Message-ID: <20080108062739.GO22955@kiste.smurf.noris.de>
References: <1199753931.6093.7.camel@Cruella>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199753931.6093.7.camel@Cruella>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Smurf-Spam-Score: -2.6 (--)
X-Smurf-Whitelist: +relay_from_hosts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> A lot of google searches reflect that, the latest kernel supporting
> Huawei EC321 CDMA PCCARD is 2.6.17. My version (2.6.22-14 on Ubuntu)
> doesn't work.
> 
This is probably because ...

> [ 3804.140000] /build/buildd/linux-source-2.6.22-2.6.22/drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303

... the card is in fact recognized by the pl2303 driver instead of the
Option driver. This driver may do something stupid.

Please try this (as root):
# rmmod plc2303
# modprobe option

If the card still does not work, type
# lsusb

and send me that.

-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
Okay, who stopped the payment on my reality check?
