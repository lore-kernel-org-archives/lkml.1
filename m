Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbXGPWtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbXGPWtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbXGPWsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:48:53 -0400
Received: from [81.2.110.250] ([81.2.110.250]:53343 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751452AbXGPWsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:48:52 -0400
Date: Mon, 16 Jul 2007 23:54:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: "Rene Herman" <rene.herman@gmail.com>, "Bodo Eggert" <7eggert@gmx.de>,
       "Matt Mackall" <mpm@selenic.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070716235438.1bdd0722@the-village.bc.nu>
In-Reply-To: <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
References: <8FO1e-2jW-35@gated-at.bofh.it>
	<8Ghmx-60z-17@gated-at.bofh.it>
	<8Gj55-hJ-5@gated-at.bofh.it>
	<8GkNo-2Vb-1@gated-at.bofh.it>
	<8GtnN-7TG-23@gated-at.bofh.it>
	<8GVjY-PL-25@gated-at.bofh.it>
	<E1IA7j1-0000j9-I3@be1.lrz>
	<469A5D7C.5010904@gmail.com>
	<Pine.LNX.4.58.0707161523500.25779@be1.lrz>
	<469BF104.1040703@gmail.com>
	<2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If at some point one of the pro-4k stacks crowd can prove that all
> code paths are safe, or introduce another viable alternative (such as
> Matt's idea for extending the stack dynamically), then removing the 8k
> stacks option makes sense.

Any x86-32 path unsafe with 4K stacks is almost certainly unsafe with 8K
stacks because the 8K stacks do not have seperate IRQ stack paths, so you
have the same space but split. It might be less predictable on 8K stacks
but it isn't absent.
