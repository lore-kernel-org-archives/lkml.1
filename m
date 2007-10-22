Return-Path: <linux-kernel-owner+w=401wt.eu-S1752020AbXJVWu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbXJVWu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbXJVWuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:50:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50634 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751189AbXJVWuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:50:15 -0400
Date: Mon, 22 Oct 2007 23:52:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matt Mackall <mpm@selenic.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071022235251.656b9cad@the-village.bc.nu>
In-Reply-To: <20071022214707.GJ17536@waste.org>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
	<1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
	<Pine.LNX.4.64.0710222137520.7105@anakin>
	<alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org>
	<20071022211617.31f5c63d@the-village.bc.nu>
	<471D145A.40904@garzik.org>
	<20071022214707.GJ17536@waste.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 16:47:07 -0500
Matt Mackall <mpm@selenic.com> wrote:

> On Mon, Oct 22, 2007 at 05:21:30PM -0400, Jeff Garzik wrote:
> > Alan Cox wrote:
> > >Why can't we just make the list one item longer than the entry count and
> > >stick a NULL on the end of it like normal people ?
> > 
> > Certainly seems safer than the current "let's run off the end of the 
> > list if anything bad happens" setup...  And I do not think allocating 
> > n+1 scatterlist entries will have much of a negative impact.
> 
> It'll mean m-1 scatterlists fit on a slab.

Is that really a credible space issue ?
