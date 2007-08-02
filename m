Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbXHBM6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbXHBM6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbXHBM6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:58:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57227 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755068AbXHBM6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:58:25 -0400
Date: Thu, 2 Aug 2007 14:04:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       trenn@suse.de, pavel@ucw.cz, mjg59@srcf.ucam.org, lenb@kernel.org
Subject: Re: 2.6.22 regression: thermal trip points
Message-ID: <20070802140442.62c56dbd@the-village.bc.nu>
In-Reply-To: <20070802120511.GA440@one.firstfloor.org>
References: <46B1988C.3090302@t-online.de>
	<20070802015248.45a40717.akpm@linux-foundation.org>
	<p731wemnre6.fsf@bingen.suse.de>
	<20070802120014.1d08830a@the-village.bc.nu>
	<20070802120511.GA440@one.firstfloor.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Set a taint flag, 
> That's hardly any useful if the machine is dead afterwards.

It won't be the hardware will do a failsafe shutdown first.

> You'll just end up with "Linux destroyed my laptop" headlines all 
> over the internet and rightfully very annoyed users.

You have to systematically sit down and tweak your machine.

> The philosophy didn't include physically destroying hardware
> as far as I know.

It most certainly did. With safety checks you could override.

> > As root you can erase the bios, 
> We don't ship the devbios driver for good reasons.

Thats debatably a bad reason (the user space API is wrong thats all), and
one thats totally inconsistent with some of the other drivers we do ship.

> > lock the hard disk with a random
> > password, reflash your video card .... 
> 
> That all requires significant effort and custom software. It's not that we 
> have a one liner echo destroy > /sys/.../flash-bios. 

Well you can do the hard disk one in one line of perl, the video card one
in a small bit of C. And this merely makes the argument that raising the
trip points should be harder.

Alan
