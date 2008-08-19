Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYHSIrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYHSIrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbYHSIrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:47:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34653 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752633AbYHSIrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:47:00 -0400
Date: Tue, 19 Aug 2008 09:29:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25.11-97.fc9 (P): idr_remove called for id=236 which is not
 allocated
Message-ID: <20080819092947.2dde0872@lxorguk.ukuu.org.uk>
In-Reply-To: <19f34abd0808182353n2174760ao135732327130a727@mail.gmail.com>
References: <19f34abd0808150811w2b77479fnead3ae6b527ad4dc@mail.gmail.com>
	<19f34abd0808150827m5128c8f6wd517796d95227654@mail.gmail.com>
	<20080815162848.08ff793c@lxorguk.ukuu.org.uk>
	<19f34abd0808151426i69256b59m25a9a0676b50a6ba@mail.gmail.com>
	<20080818231546.73020e41@lxorguk.ukuu.org.uk>
	<19f34abd0808182353n2174760ao135732327130a727@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The open path for ptmx slaves is via the ptmx device. Opening them any
> > other way is not allowed. Vegard Nossum found that previously this was not
> > the case and mknod foo c 128 42; cat foo would produce nasty diagnostics
> > ---
> 
> Thanks, this seems to work for me. I do get a "SLAP" in dmesg each
> time, however :-)

Thanks - pushed to -next (without the printk)
