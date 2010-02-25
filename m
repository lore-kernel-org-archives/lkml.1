Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948Ab0BYFEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 00:04:34 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:52416 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab0BYFEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 00:04:32 -0500
Date: Thu, 25 Feb 2010 00:04:02 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Ben Gardner <gardner.ben@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] cs5535_gpio: gpio_chip.get should return the input
 value
Message-ID: <20100225000402.0951a473@droptest.queued.net>
In-Reply-To: <808c8e9d1002242016j52d763e3wb0b00c73a014e6e5@mail.gmail.com>
References: <808c8e9d1002231455q379b26acq4b4a50188c5d73be@mail.gmail.com>
	<20100224145822.803e86ed.akpm@linux-foundation.org>
	<808c8e9d1002241952s63633da3m471b6fb170558789@mail.gmail.com>
	<20100224200559.fa911282.akpm@linux-foundation.org>
	<808c8e9d1002242016j52d763e3wb0b00c73a014e6e5@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010 22:16:43 -0600
Ben Gardner <gardner.ben@gmail.com> wrote:

> >> > What were the user-visible effects of this bug?
> >>
> >> The user-visible effects were that the input didn't work.
> >> I use the CS5535 chip in a custom board that uses GPIO 25 and 26 as
> >> voltage monitoring inputs (external voltage comparators).
> >> Since the char-based cs5535-gpio is now deprecated, I'm trying out
> >> the gpio driver.
> >> I export the GPIO pins via sysfs to access them from user-space.
> >> Reading the 'value' member didn't reflect the input.
> >
> > OK, then in that case we'd want to backport this into 2.6.33.x and
> > perhaps earlier?
> 
> It looks like the driver was added 15 Dec 2009, so it doesn't look
> like it existed in an earlier kernel.

But it should definitely be added to 2.6.33.y.

