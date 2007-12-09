Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbXLINq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbXLINq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 08:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbXLINqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 08:46:52 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45155 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750712AbXLINqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 08:46:51 -0500
Date: Sun, 9 Dec 2007 13:39:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: benh@kernel.crashing.org, Ralf Baechle <ralf@linux-mips.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
Message-ID: <20071209133923.4c35147b@the-village.bc.nu>
In-Reply-To: <200712091346.25532.bzolnier@gmail.com>
References: <200710122305.l9CN5tFI008240@hera.kernel.org>
	<1197185091.6572.38.camel@pasglop>
	<1197193794.6572.52.camel@pasglop>
	<200712091346.25532.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > In fact, I see a deeper problem with Bart's original patch that moved
> > the "fixup" the PCI probe.
> 
> I don't remember changing anything there, could you remind me what it was
> exactly (commit number or patch name)?

I'm pretty sure he means the code I added a while ago to actually correct
our IDE/ATA handling for legacy devices, fix the resource tree being
wrong and remove tons of special cases from drivers.

Alan
