Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYHDJDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYHDJDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 05:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYHDJDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 05:03:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54400 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753320AbYHDJDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 05:03:30 -0400
Date: Mon, 4 Aug 2008 09:45:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, "Randy.Dunlap" <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Introduce down_try() so we can move away from
 down_trylock()
Message-ID: <20080804094507.61b68eba@lxorguk.ukuu.org.uk>
In-Reply-To: <200808041757.05323.rusty@rustcorp.com.au>
References: <200807291015.02865.rusty@rustcorp.com.au>
	<200808041328.45773.rusty@rustcorp.com.au>
	<alpine.LFD.1.10.0808032251050.3668@nehalem.linux-foundation.org>
	<200808041757.05323.rusty@rustcorp.com.au>
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

>       down_trylock -> down_try in drivers/watchdog/ar7_wdt.c
>       down_trylock -> down_try in drivers/watchdog/it8712f_wdt.c
>       down_trylock -> down_try in drivers/watchdog/s3c2410_wdt.c
>       down_trylock -> down_try in drivers/watchdog/sc1200wdt.c
>       down_trylock -> down_try in drivers/watchdog/scx200_wdt.c
>       down_trylock -> down_try in drivers/watchdog/wdt_pci.c

I sent fixes for all of those to the watchdog maintainer in May. The
patches are still sitting with the maintainer. They all convert to proper
locking rather than sem abuse, clean up all the coding style and fix
numerous bugs plus remove BKL requirements.

Wim it appears is still trying to get real life stuff sorted out so I
think at this point we really need a new watchdog maintainer.

(See series of 57 patches "watchdog: Giant scrub" about 19th May)

Alan
