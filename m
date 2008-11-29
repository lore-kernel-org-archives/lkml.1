Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbYK2Bh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbYK2Bh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 20:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYK2BhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 20:37:14 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34941 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753151AbYK2BhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 20:37:13 -0500
Date: Sat, 29 Nov 2008 01:37:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] usb/serial: Add compat_ioctl pass-through
Message-ID: <20081129013712.5902e35e@lxorguk.ukuu.org.uk>
In-Reply-To: <20081128172300.0e30229e@infradead.org>
References: <200811281642.52637.arnd@arndb.de>
	<1227911282-8857-1-git-send-email-keithp@keithp.com>
	<20081128223305.2d11f8d9@lxorguk.ukuu.org.uk>
	<1227920556.4277.128.camel@aiko.keithp.com>
	<20081129011057.14840d20@lxorguk.ukuu.org.uk>
	<20081128172300.0e30229e@infradead.org>
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

> it's a double BKL since it's also using .ioctl not .unlocked_ioctl
> (but then again we should just over time merge the two into a .ioctl
> which is unlocked ;-)

tty_ioctl is an unlocked_ioctl method and that is what calls the ioctl
method of tty drivers.
