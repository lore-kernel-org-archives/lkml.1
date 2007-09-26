Return-Path: <linux-kernel-owner+w=401wt.eu-S1762815AbXIZW4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762815AbXIZW4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758978AbXIZWzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:55:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34779 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752882AbXIZWzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:55:54 -0400
Date: Thu, 27 Sep 2007 00:01:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] usb_serial: Stop passing NULL to functions that expect
 data
Message-ID: <20070927000155.54ff09bb@the-village.bc.nu>
In-Reply-To: <20070926155248.5e7df147.akpm@linux-foundation.org>
References: <20070926230840.231df58e@the-village.bc.nu>
	<20070926155248.5e7df147.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 15:52:48 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 26 Sep 2007 23:08:40 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > Earlier patches have removed the checking for old v new differences from
> > the USB drivers so we can now pass in a valid blank old termios so that
> > we don't to fill the drivers with magic hacks for console support
> 
> Are all the prerequisites for these patches in mainline, or are there
> dependencies on -mm stuff here?

Sorry pre-req for the USB serial ones is the tty patch I sent you last
chunk that added tty_encode_baud_rate

I'd prefer them to sit in -mm a bit. I'm pretty sure most of them are
100% solid but I also want to see if we get any app breakages caused
by correcting our behaviour

Alan
