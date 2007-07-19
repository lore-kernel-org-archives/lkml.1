Return-Path: <linux-kernel-owner+w=401wt.eu-S937462AbXGSJSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937462AbXGSJSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763525AbXGSJSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:18:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46706 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762371AbXGSJSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:18:06 -0400
Date: Thu, 19 Jul 2007 10:23:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrea Arcangeli <andrea@suse.de>
Cc: Matt Mackall <mpm@selenic.com>, Rene Herman <rene.herman@gmail.com>,
       Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070719102359.0e6a2e17@the-village.bc.nu>
In-Reply-To: <20070719013358.GD29728@v2.random>
References: <469A5D7C.5010904@gmail.com>
	<Pine.LNX.4.58.0707161523500.25779@be1.lrz>
	<469BF104.1040703@gmail.com>
	<2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
	<469BF768.6040200@gmail.com>
	<20070716230719.GC11115@waste.org>
	<469BFB73.3070105@gmail.com>
	<20070716232755.GD11115@waste.org>
	<20070719001539.GC29728@v2.random>
	<20070719013955.1bedc423@the-village.bc.nu>
	<20070719013358.GD29728@v2.random>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 03:33:58 +0200
Andrea Arcangeli <andrea@suse.de> wrote:

> > 8K stacks without IRQ stacks are not "safer" so I don't understand your
> > comment ?
> 
> Ouch, see the reports about 4k stack crashes. I agree they're not
> safe w/o irq stacks (like on x86-64), but they're generally safer.

Still don't follow. How is "exceeds stack space but less likely to be
noticed" safer.

Alan
