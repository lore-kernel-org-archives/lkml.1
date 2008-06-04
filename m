Return-Path: <linux-kernel-owner+w=401wt.eu-S1762143AbYFDTee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762143AbYFDTee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbYFDTeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:34:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42993 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750987AbYFDTeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:34:22 -0400
Date: Wed, 4 Jun 2008 20:18:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andrew Victor" <avictor.za@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, wim@iguana.be,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: AT91SAM9/CAP9 watchdog driver
Message-ID: <20080604201825.2decc66e@core>
In-Reply-To: <cd73a99e0806041202v592c41e1ya3c9fa51918efb0f@mail.gmail.com>
References: <cd73a99e0806010940g501f11b4jcb7caf6acfd5c49f@mail.gmail.com>
	<20080603142316.c53b32b2.akpm@linux-foundation.org>
	<cd73a99e0806040031s13e6b4a5ndc5fb3d931e1945f@mail.gmail.com>
	<20080604123642.51449a04@core>
	<cd73a99e0806041136o2a9ee520q28752af9b6290644@mail.gmail.com>
	<20080604192458.02f76022@core>
	<cd73a99e0806041202v592c41e1ya3c9fa51918efb0f@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > - If you specify a bogus value it doesn't load
> > - If you specify no value you get a valid default
> > - If you specify a valid value you get that
> >
> > I don't believe yours should be different.
> 
> I don't think any other in-kernel watchdog driver has to deal with
> write-once hardware.  On these processors once the watchdog register

That would not be the case.

> is programmed, it cannot be disabled or re-programmed.
> If the above behaviour is required, then we might aswell remove the
> ioctl(WDIOC_SETTIMEOUT) interface for this driver since if the user
> wants anything other than the default timeout they would need to pass
> it via the kernel command-line or module parameters.

Actually quit a few of them deal with various hardware limits by using a
software timer to maintain the hardware timer poking.

Alan
