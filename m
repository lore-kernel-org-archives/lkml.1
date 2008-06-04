Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbYFDSlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbYFDSlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbYFDSkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:40:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49795 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754493AbYFDSkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:40:51 -0400
Date: Wed, 4 Jun 2008 19:24:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andrew Victor" <avictor.za@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, wim@iguana.be,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: AT91SAM9/CAP9 watchdog driver
Message-ID: <20080604192458.02f76022@core>
In-Reply-To: <cd73a99e0806041136o2a9ee520q28752af9b6290644@mail.gmail.com>
References: <cd73a99e0806010940g501f11b4jcb7caf6acfd5c49f@mail.gmail.com>
	<20080603142316.c53b32b2.akpm@linux-foundation.org>
	<cd73a99e0806040031s13e6b4a5ndc5fb3d931e1945f@mail.gmail.com>
	<20080604123642.51449a04@core>
	<cd73a99e0806041136o2a9ee520q28752af9b6290644@mail.gmail.com>
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

> The issue above is rather that probe() should not fail if
> at91_wdt_settimeout() returns -EINVAL, since we'd like the
> driver/module to still load to allow the user to later specify a valid
> timeout via ioctl(WDIOC_SETTIMEOUT).

Every other watchdog behaves as follows

- If you specify a bogus value it doesn't load
- If you specify no value you get a valid default
- If you specify a valid value you get that

I don't believe yours should be different.

Alan
