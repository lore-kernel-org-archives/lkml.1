Return-Path: <linux-kernel-owner+w=401wt.eu-S935357AbXGRR1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935357AbXGRR1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933557AbXGRR11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:27:27 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49334 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933287AbXGRR10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:27:26 -0400
Date: Wed, 18 Jul 2007 18:32:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Matt Mackall <mpm@selenic.com>, Rene Herman <rene.herman@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070718183252.264fe6b2@the-village.bc.nu>
In-Reply-To: <469E4BB0.8010203@cfl.rr.com>
References: <200707111916.35036.jesper.juhl@gmail.com>
	<2c0942db0707112159v3ee2cd83i74759c7138e273f7@mail.gmail.com>
	<9a8748490707121324q3b3e6e65ye14ab8e7f089d999@mail.gmail.com>
	<4696C89E.4010002@goop.org>
	<9a8748490707121925w5fb22c0o61068f06d66d5845@mail.gmail.com <20070714191737.GA11166@waste.org>
	<469E4BB0.8010203@cfl.rr.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Why do the two pages have to be physically contiguous?  The stack just 
> needs to be two contiguous pages in virtual memory, but they can map to 
> any two pages anywhere in physical memory.

Historically we allowed DMA off the stack on old x86 systems. Removing
that while a good idea would take a lot of auditing. We also have a very
limited vmalloc window for mapped pages and filling that with stacks
would be bad.
