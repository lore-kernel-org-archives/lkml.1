Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbYK0K7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbYK0K7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYK0K6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:58:21 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60956 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758631AbYK0K6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:58:20 -0500
Date: Thu, 27 Nov 2008 10:58:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] usb/serial/cp2101: Add support for cp2103 GPIO pins
Message-ID: <20081127105823.30786bf4@lxorguk.ukuu.org.uk>
In-Reply-To: <1227774576-5503-2-git-send-email-keithp@keithp.com>
References: <1227774576-5503-1-git-send-email-keithp@keithp.com>
	<1227774576-5503-2-git-send-email-keithp@keithp.com>
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

On Thu, 27 Nov 2008 00:29:36 -0800
Keith Packard <keithp@keithp.com> wrote:

> The cp2103 is programmed the same as the cp2101/cp2102 except for the
> addition of a set of four GPIO pins which can be directly controlled by the
> host. Access to this is done through a custom ioctl.

Only concern I have is that a custom ioctl means every time a new serial
chip grows GPIO pins we end up with more ioctls.

We have an LED class driver which might perhaps do the job but isn't
really oriented that way but would keep the tty and gpio pins separate
and available to different applications at the same time.

Failing that a rename to make it a generic tty gpio ioctl might be more
futurerpoof ?

Alan
