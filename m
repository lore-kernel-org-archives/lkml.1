Return-Path: <linux-kernel-owner+w=401wt.eu-S936207AbXGSAeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936207AbXGSAeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759724AbXGSAd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:33:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55504 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759474AbXGSAd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:33:57 -0400
Date: Thu, 19 Jul 2007 01:39:55 +0100
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
Message-ID: <20070719013955.1bedc423@the-village.bc.nu>
In-Reply-To: <20070719001539.GC29728@v2.random>
References: <8GVjY-PL-25@gated-at.bofh.it>
	<E1IA7j1-0000j9-I3@be1.lrz>
	<469A5D7C.5010904@gmail.com>
	<Pine.LNX.4.58.0707161523500.25779@be1.lrz>
	<469BF104.1040703@gmail.com>
	<2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
	<469BF768.6040200@gmail.com>
	<20070716230719.GC11115@waste.org>
	<469BFB73.3070105@gmail.com>
	<20070716232755.GD11115@waste.org>
	<20070719001539.GC29728@v2.random>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> About 4k stacks I was generally against them, much better to fail in
> fork than to risk corruption. The per-irq stack part is great feature
> instead (too bad it wasn't enabled for the safer 8k stacks).

8K stacks without IRQ stacks are not "safer" so I don't understand your
comment ?
