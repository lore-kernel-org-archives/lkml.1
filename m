Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbZHSSSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbZHSSSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbZHSSSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:18:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55016 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751026AbZHSSSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:18:38 -0400
Date: Wed, 19 Aug 2009 19:19:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: "Greg KH" <greg@kroah.com>, "Linux USB" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: Purpose of parameter in sysfs binary read
Message-ID: <20090819191944.23e6e0ee@lxorguk.ukuu.org.uk>
In-Reply-To: <5ea7c6a46fa1e051d69a302fdc8961ac.squirrel@intranet.cs.nmsu.edu>
References: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu>
	<20090818151427.GA6295@kroah.com>
	<ead4b2f9b7e5b1a415d010c524812e3a.squirrel@intranet.cs.nmsu.edu>
	<20090819170501.1dbd29a8@lxorguk.ukuu.org.uk>
	<5ea7c6a46fa1e051d69a302fdc8961ac.squirrel@intranet.cs.nmsu.edu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But, in addition to sending keystroke output you can send a usb control
> message to change the backlight color and an interrupt message to load a
> bitmap as an image.

Ok that actually fits the LCD interface model a bit better, but the LCD
class right now is a hack inside of a single driver so eventually needs
fixing

> The bitmap itself is simple, but requires a specific format. Byte 0 must
> be 0x03 followed by 31 bytes of null. The low bit of byte 32 is x,y (0,0)
> second high bit is (0,1)... with low bit of byte 33 being (1,0)...

How big is it and can it be used for general purpose graphics - I know
the G19 is something like 320x240 but the G13 ?
