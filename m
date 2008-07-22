Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbYGVCSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbYGVCSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 22:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYGVCSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 22:18:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49755 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753866AbYGVCSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 22:18:04 -0400
Date: Tue, 22 Jul 2008 03:00:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       ppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] serial: fix struct uart_info change fallout
Message-ID: <20080722030011.6b0d8137@lxorguk.ukuu.org.uk>
In-Reply-To: <20080722003814.GA14809@redhat.com>
References: <20080722102520.ca801ab5.sfr@canb.auug.org.au>
	<20080722003814.GA14809@redhat.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 20:38:14 -0400
Dave Jones <davej@redhat.com> wrote:

> On Tue, Jul 22, 2008 at 10:25:20AM +1000, Stephen Rothwell wrote:
>  > Hi Linus, Alan,
>  > 
>  > Today's linux-next (actually just Linus' tree) build (powerpc
>  > ppc64_defconfig) failed like this:
>  > 
>  > drivers/serial/serial_txx9.c: In function 'receive_chars':
>  > drivers/serial/serial_txx9.c:275: error: 'struct uart_info' has no member named 'tty'
>  > drivers/serial/icom.c: In function 'recv_interrupt':
>  > drivers/serial/icom.c:733: error: 'struct uart_info' has no member named 'tty'
> 
> That's the same pair of patches I sent earlier, which apparently were
> "Already in the ttydev tree" which should be in linux-next ?

And are in Linux next, and would be in the Linus submission queue except
that everyone keeps patching tty files from other trees.

<mutter>

Alan
