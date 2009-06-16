Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbZFPIoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbZFPIoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbZFPIny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:43:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39369 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751605AbZFPInx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:43:53 -0400
Date: Tue, 16 Jun 2009 09:44:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] WARNING: at drivers/char/tty_io.c:1266
 tty_open+0x1ea/0x388()
Message-ID: <20090616094430.75bbbee2@lxorguk.ukuu.org.uk>
In-Reply-To: <20090616071057.GA29862@elte.hu>
References: <20090614081052.GA9276@elte.hu>
	<20090614115428.1127ed2d@lxorguk.ukuu.org.uk>
	<20090616071057.GA29862@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I split the ldisc and tty apart and redid the ldisc locking so its a fair
> > bet I know what changeset is to blame, will just need to hunt it down a
> > bit. kmemcheck found one leak case on Friday which I've fixed but not yet
> > scribbles.
> > 
> > >  c65c9bc: tty: rewrite the ldisc locking
> > 
> > Almost certainly that one and will investigate on Monday
> 
> I have applied your patch from yesterday (attached further below for 
> reference) and the SLAB corruption has not triggered - instead i'm 
> now getting this warning, after 96 reboots:

That's progress

> Another test-box has produced this warning too. (Same config and 
> same hw as i sent the details for earlier in this thread.)
> 
> So there's still something fishy going on.

Are you using a standard udev/fedora setup or something different (I know
the devtmpfs proposal stuff produces crashes like that one all the time
which are not seen anywhere else)

And is it reproducable this time - and always 96 ?
