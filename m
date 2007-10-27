Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbXJ0Mow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbXJ0Mow (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 08:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbXJ0Mop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 08:44:45 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39483 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752382AbXJ0Mop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 08:44:45 -0400
Date: Sat, 27 Oct 2007 13:47:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Holvenstot <cholvenstot@comcast.net>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Major SATA / EXT3 Issue?
Message-ID: <20071027134705.310487f3@the-village.bc.nu>
In-Reply-To: <1193451712.6639.13.camel@localhost>
References: <1193451712.6639.13.camel@localhost>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 21:21:52 -0500
Chris Holvenstot <cholvenstot@comcast.net> wrote:

> My SATA controller is integrated on my MSI motherboard and sports four
> ports.  It is implemented using the Nvidia CK804 chipset.  My processor
> is an AMD64 X2 4600+ running the 32 bit version of Linux.  
> 
> I have had these drives up and running for about six months.=

You don't provide enough information to even guess. The whole of the
relevant part of the ata messages would be a lot more useful than the
cutting/pasting of bits you've provided.

The BIOS finding the drive is indicating it responds to identify and the
basic commands (and usually means your cabling is fine), but really the
rest of the trace is needed to see what occurs next. If the drive has
gone then the partition table read will fail and you won't
get /dev/sdb[something] for it.

