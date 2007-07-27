Return-Path: <linux-kernel-owner+w=401wt.eu-S937556AbXG0Rbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937556AbXG0Rbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762652AbXG0Rbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:31:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32955 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758250AbXG0Rbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:31:46 -0400
Date: Fri, 27 Jul 2007 18:38:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Andrea Arcangeli <andrea@suse.de>, Matt Mackall <mpm@selenic.com>,
       Rene Herman <rene.herman@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Bodo Eggert <7eggert@gmx.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070727183807.2d7dbe7b@the-village.bc.nu>
In-Reply-To: <46A9ECD5.3050801@sandeen.net>
References: <469BF104.1040703@gmail.com>
	<2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
	<469BF768.6040200@gmail.com>
	<20070716230719.GC11115@waste.org>
	<469BFB73.3070105@gmail.com>
	<20070716232755.GD11115@waste.org>
	<20070719001539.GC29728@v2.random>
	<20070719013955.1bedc423@the-village.bc.nu>
	<20070719013358.GD29728@v2.random>
	<20070719013725.GP11115@waste.org>
	<20070719112436.GG29728@v2.random>
	<20070719124419.48c3d610@the-village.bc.nu>
	<46A9ECD5.3050801@sandeen.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe I should resurrect it & send it out...
> 
> (FWIW I think I recall that the warning itself sometimes tipped the
> scales enough on 4k stacks to bring the box down)

You can always switch stack for the printk and it probably should panic
at that point and give a trace then die as that is what we are trying to
prove does not occur
