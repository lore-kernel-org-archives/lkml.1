Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbXGWRAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbXGWRAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbXGWRAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:00:05 -0400
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:38247 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753443AbXGWRAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:00:04 -0400
X-Greylist: delayed 1392 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jul 2007 13:00:04 EDT
Date: Mon, 23 Jul 2007 18:36:49 +0200
From: Jan Hubicka <jh@suse.cz>
To: Andi Kleen <ak@suse.de>
Cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, jh@suse.cz
Subject: Re: [PATCH 2/8] i386: bitops: Rectify bogus "Ir" constraints
Message-ID: <20070723163649.GL1758@kam.mff.cuni.cz>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <200707231810.08445.ak@suse.de> <Pine.LNX.4.64.0707232145270.22155@cselinux1.cse.iitk.ac.in> <200707231830.40331.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707231830.40331.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > Whoa, thanks for explaining that to me -- I didn't know, obviously. I had
> > just written a test program that used "Ir" with an automatic variable
> > defined in the inline function (as is the case with these bitops) and
> > observed that even when I gave > 32 values, it would still work -- hence
> > my conclusion.
> > 
> > However, the patch still stands, does it not? [ I will modify the
> > changelog, obviously. ] The thing is that we don't want to limit
> > @nr to <= 31 in the first place, or am I wrong again? :-)
> 
> These bit operations only allow 8 bit immediates, so 0..255 would
> be correct. N might work from the 4.1 docs, but I don't know if it works 
> in all old supported gccs (3.2+)

'N' constraint was there pretty much forever, originally intended for
in/out operands.  It is in 2.95 docs
http://gcc.gnu.org/onlinedocs/gcc-2.95.3/gcc_16.html#SEC175

Honza
