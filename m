Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYJOWge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYJOWge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 18:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYJOWg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 18:36:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35525 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753109AbYJOWgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 18:36:25 -0400
Date: Wed, 15 Oct 2008 23:36:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: is the weeks before -rc1 the time to really be working on
 -next?
Message-ID: <20081015233607.54c1d6b8@lxorguk.ukuu.org.uk>
In-Reply-To: <20081015145606.2af3baf1.akpm@linux-foundation.org>
References: <20081015174015.GB8663@kroah.com>
	<20081015145606.2af3baf1.akpm@linux-foundation.org>
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

> first.  So everyone who has been changing stuff which is outside their
> area of responsibility and breaking other people's stuff would get to
> see the consequences of their actions instead of Stephen and I bearing
> the brunt of it all the time.
> 
> 
> I fear we've reached the stage now where people are merrily merging
> bright-and-shiny things into their local trees without giving much
> thought at all to the consequences for others.

Its not that simple. There are areas where the tree divides don't fit the
coding divides. ttydev was horribly entwined with USB and there really
wasn't a way to break that up at the time in question. Because -next
tries to assemble all the trees based on Linus tree it can't cope with
that case well at all and in fact there was some neccessary rule bending
to make next work out where some of the ttydev work was done with ttydev
on top of other subtrees.

So at times it would be very helpful with -next to be able to do limited
tree ordering. If I could have flagged tty as requiring USB first for
example there would have been a lot less pain involved.

Alan
