Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbYLATpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbYLATpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 14:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYLATpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 14:45:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36916 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751254AbYLATp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 14:45:29 -0500
Date: Mon, 1 Dec 2008 19:41:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [Industrial I/O] [0/13] RFC: IIO v3 patchset
Message-ID: <20081201194136.039e201b@lxorguk.ukuu.org.uk>
In-Reply-To: <4933F291.4020001@cam.ac.uk>
References: <4933F291.4020001@cam.ac.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> have both functions. The sort of devices we are talking typically
> communicate over I2C or SPI buses though drivers for rs232 devices etc are
> definitely on the cards. Basically we are interested in devices where direct
> memory mapped access is not possible.

We have I2C and SPI drivers so I assume you will use the lower layers of
the stacks to do this ?

> For discussion of why these don't fit within existing subsystems see 
> http://lkml.org/lkml/2008/5/20/135 and the rest of the associated thread.

I don't see much there which says why you can't unify all this in a user
space library.

For RS232/423/.. devices you can go this path if you want (but I would
keep it all in userspace anyway) as you can use a line discipline to sit
on top of the port and provide another interface (eg the way PPP does)
