Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZGJTbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZGJTbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZGJTb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:31:27 -0400
Received: from vena.lwn.net ([206.168.112.25]:41401 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbZGJTb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:31:26 -0400
Date: Fri, 10 Jul 2009 13:31:27 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: David Newall <davidn@davidnewall.com>,
       Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       tridge@samba.org, Jan Engelhardt <jengelh@medozas.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090710133127.6839dc87@bike.lwn.net>
In-Reply-To: <200907102049.12427.Martin@lichtvoll.de>
References: <20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<200907100023.48039.Martin@lichtvoll.de>
	<4A569D36.3060707@davidnewall.com>
	<200907102049.12427.Martin@lichtvoll.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009 20:49:00 +0200
Martin Steigerwald <Martin@lichtvoll.de> wrote:

> To me your thoughts appear to be *within* the patent approach and *thus* 
> implicitely saying "yes" software patents as such. Going this way I think 
> actually strengthen patents. 

One deals with reality on reality's terms.  For the moment, software
patents exist in some parts of the world.  People are working on that,
but one cannot just stick one's fingers into one's ears and wish the
problem away.

> The FAT patents have not yet been tested. 
> They might easily just be void and invalid.

The FAT patents *have* been tested, invalidated, and then revalidated.
Yes, they might still be invalid - I believe they are.  This helps a
Linux user whose products have been seized at the US border exactly
how? 

> But going the way you outline would be giving in to the patent claim 
> *before* it has even been tried and tested for validity. And thus IMHO 
> this strengthens the patent and it holder. If you change the upstream 
> kernel Microsoft can always say: "Look Linux kernel developers think that 
> the kernel infringed our patents." 

The point is not to give in to the claim; the point is to make it
irrelevant.  That "invalidates" the patent in a way which (1) doesn't
cost several million dollars and (2) is rather more certain in its
outcome.

> The linux kernel has not yet been proven to infringe any FAT patent. 
> Microsoft claims that it does. But so did SCO claim that it contains 
> source of UNIX that they said they have a license for. SCO could never 
> prove that claim. The linux kernel community ignored SCO for exactly that 
> reason. 

The Linux community did not ignore SCO.  We looked very hard at our
code and our processes, and adopted things like the DCO very much in
response to SCO.  The whole SCO affair has, IMO, made us a lot
stronger.

SCO is a very different story, though.  Copyright infringement is
usually pretty easy to avoid - just do your own work.  Patent
infringement happens regardless of how original your work is.

> Why on Earth should it handle Microsoft differently?  Just due to 
> its sheer size and weight in capital? The trial with TomTom just proves 
> nothing right now.

The TomTom trial proves that companies like TomTom have no real hope of
withstanding patent attacks and nicely invalidating obnoxious patents
as a favor for the rest of us.

Perhaps (a future version of) this patch isn't the right solution to
the VFAT patent problem.  Be we do need to figure out how we can
respond to patents which are being used to attack our users.  Telling
them to take the bullet and try to invalidate the patent for us isn't
going to fly.  Neither is ignoring the problem.

I have a lot of sympathy for Alan's assertion that we can't muck up our
upstream code with hackarounds for every bit of legal obnoxiousness we
encounter.  But outright refusal of things like patent workarounds does
not help us either.  Linux is a pragmatic system; somehow, I believe,
we can find a way to minimize our patent hassles without messing up the
system as a whole.

jon
