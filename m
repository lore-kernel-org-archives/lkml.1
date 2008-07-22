Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYGVQRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYGVQRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 12:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYGVQRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 12:17:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54358 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750852AbYGVQRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 12:17:39 -0400
Date: Tue, 22 Jul 2008 16:59:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] serial: fix struct uart_info change fallout
Message-ID: <20080722165929.717e38d4@lxorguk.ukuu.org.uk>
In-Reply-To: <20080723014910.7351c495.sfr@canb.auug.org.au>
References: <20080722102520.ca801ab5.sfr@canb.auug.org.au>
	<20080722025850.0d073a5e@lxorguk.ukuu.org.uk>
	<20080722130152.f115224d.sfr@canb.auug.org.au>
	<20080722114436.2c13edea@lxorguk.ukuu.org.uk>
	<20080723014910.7351c495.sfr@canb.auug.org.au>
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

> I interpreted your "So much for the linux-next tree" as saying "well,
> that has been no help".  I am sorry if I got that wrong.

True it didn't help in the merge that much this time. I don't think that
is a problem with the linux-next tree but one of the lack of tty
maintainer and tty tree letting the confusion occur in the first place -
plus a large quantity of first time around ineptness on my part.

> But my point above is that you had a fix for the current breakage in
> Linus' tree a couple of weeks before you sent the patches to Linus that
> broke the powerpc build (i.e. linux-next did its job) and yet you didn't
> combine the fix with the original patch or send the fix with the original
> patch.  So we end up with a powerpc tree that won't build in the middle
> of the merge window while more powerpc patches are trying to be
> tested ... I understand that this could easily happen because of
> forgetfulness, tiredness or accident.

I really expected to get the rest merged within an hour or two, but then
it broke, then I was travelling and each time I got wireless access to
resync the tree and work on it - it broke again and again and again.

Next time I will bump the patch up the pile and get it out earlier when
that occurs.

Alan
