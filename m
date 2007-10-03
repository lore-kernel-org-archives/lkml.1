Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbXJCUZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbXJCUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 16:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXJCUZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 16:25:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55971 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753447AbXJCUZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 16:25:18 -0400
Date: Wed, 3 Oct 2007 21:30:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Neil Romig" <neil@romig.demon.co.uk>, linux-kernel@vger.kernel.org,
       hyoshiok@miraclelinux.com, "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: File corruption when using kernels 2.6.18+
Message-ID: <20071003213011.0962c5c5@the-village.bc.nu>
In-Reply-To: <84144f020710031235r29986ceaj3260e8271eee6ddb@mail.gmail.com>
References: <46FFC371.9040805@romig.demon.co.uk>
	<84144f020709300929t6aafd98at23d810d4460e898a@mail.gmail.com>
	<4702B28F.5050404@romig.demon.co.uk>
	<84144f020710022218x147ffc74y477c0a1be3e60d66@mail.gmail.com>
	<4703E287.3070705@romig.demon.co.uk>
	<84144f020710031148i346b393bm528fc150fedff00f@mail.gmail.com>
	<alpine.LFD.0.999.0710031209450.3579@woody.linux-foundation.org>
	<84144f020710031235r29986ceaj3260e8271eee6ddb@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2007 22:35:24 +0300
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> Hi Linus,
> 
> On 10/3/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > I would bet that the reason the intel-optimized memcpy triggers this is
> > that the non-temporal stores just means that you go out directly on the
> > bus, and it probably just shows a weakness in the chipset or bus that
> > doesn't show with the normal cacheline accesses.
> 
> But that should show up with memtest too, no?

Not neccessarily. The old VIA memory copying bug only showed up with
prefetching and mmx store patterns. That was a hardware flaw that took
extreme memory utilisation to show up - so it does occur but thats not to
say it is the cause

Alan
