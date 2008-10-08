Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbYJHJEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbYJHJEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 05:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbYJHJEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 05:04:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60367 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752474AbYJHJEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 05:04:39 -0400
Date: Wed, 8 Oct 2008 10:00:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, avorontsov@ru.mvista.com,
       Matt Sealey <matt@genesi-usa.com>, Jeff Garzik <jgarzik@pobox.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Li Yang <leoli@freescale.com>,
       Wang Jian <lark@linux.net.cn>
Subject: Re: [PATCH] pata_of_platform: fix no irq handling
Message-ID: <20081008100025.1c535401@lxorguk.ukuu.org.uk>
In-Reply-To: <1223455254.3145.143.camel@macbook.infradead.org>
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
	<48EA77EF.6080502@genesi-usa.com>
	<20081006213209.GA13072@oksana.dev.rtsoft.ru>
	<48EABBD3.1010401@kernel.org>
	<20081007103723.0224671e@lxorguk.ukuu.org.uk>
	<1223455254.3145.143.camel@macbook.infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Oct 2008 09:40:54 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2008-10-07 at 10:37 +0100, Alan Cox wrote:
> > Zero means no IRQ. Any platform with bits of code left over exposing IRQ
> > 0 is already not supported by lots of driver code including libata.
> 
> ...and must implement some kind of interrupt remapping crap just to work
> around this bogus design decision.

I'll leave you to argue with Linus about that, but since that was the
decision back in 2005 (for good C reasons) we can safely rely on it.
