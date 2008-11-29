Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbYK2BLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbYK2BLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 20:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYK2BKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 20:10:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34704 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753525AbYK2BKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 20:10:50 -0500
Date: Sat, 29 Nov 2008 01:10:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Keith Packard <keithp@keithp.com>
Cc: keithp@keithp.com, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] usb/serial: Add compat_ioctl pass-through
Message-ID: <20081129011057.14840d20@lxorguk.ukuu.org.uk>
In-Reply-To: <1227920556.4277.128.camel@aiko.keithp.com>
References: <200811281642.52637.arnd@arndb.de>
	<1227911282-8857-1-git-send-email-keithp@keithp.com>
	<20081128223305.2d11f8d9@lxorguk.ukuu.org.uk>
	<1227920556.4277.128.camel@aiko.keithp.com>
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

> Oh yes, it is -- serial_ioctl does:
> 
>         if (port->serial->type->ioctl) {
>                 lock_kernel();
>                 retval = port->serial->type->ioctl(tty, file, cmd, arg);
>                 unlock_kernel();
>         } else
> 
> I added the comment to make the difference in calling convention
> documented in the header file at least, I didn't change the code.

Gak I thought I'd killed all of those.

Let me rephase it "It won't be next week" ;)

Alan
