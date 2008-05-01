Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYEABgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYEABgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbYEABgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:36:13 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57291 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754727AbYEABgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:36:11 -0400
Date: Wed, 30 Apr 2008 21:35:05 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501013504.GF14192@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, rjw@sisk.pl,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	jirislaby@gmail.com
References: <20080429.190352.137408408.davem@davemloft.net> <200804302245.50817.rjw@sisk.pl> <alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org> <200805010023.32213.rjw@sisk.pl> <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org> <20080430154124.7ec08dd4.akpm@linux-foundation.org> <20080501005727.GO29330@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501005727.GO29330@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 03:57:27AM +0300, Adrian Bunk wrote:
> > 
> > We should be discussing how to raise the quality of our work.
> 
> One big problem I see is Linus wanting to merge all drivers regardless 
> of the quality.
> 
> Linus said in [1]:
> "I'd really rather have the driver merged, and then *other* people can 
>  send patches!"
> 
> The problem is that such "other people" do not exist (except perhaps Al) 
> for non-trivial stuff.

Sure, but that's not cause of the problems that people like DavidN
whine about, or problems that frustrate David Miller and/or Ingo
Molnar.  The problems that cause whining and/or frustration are when
changes in core code break other maintainer.  That is a TOTALLY
DIFFERENT problem from lower-quality device drivers getting merged.
In general, those device drivers don't cause problems who don't have
the relevant hardware, and worse case, the device driver can just be
CONFIG'ed out.

So this is a totally different issue, and whether or not we merge new
device drivers, and at what quality level (from "it compiles, ship
it!", to every single checkpatch, sparse, and Cristoph Hellwig nitpick
has to be addressed *AND* then the submitter has to give a bottle of
high-quality alcohol to a Maintainer :-) is completely orthoganal to
the question of whether we can, in a King Canute fashion, compel
developers from stopping to develop by command them not to send pull
requests or by refusing to merge their work into mainline.

If we don't merge their work, and it's really cool features that our
end users are demanding, it will just flow into the distros via
out-of-tree patches, much like it did during the 2.4/2.5 era.  And
maybe the current enterprise distro's will try to hold it back, but if
end users start saying things like's "We want containers!!" and start
voting with their feet to a distro that is willing to merge OpenVZ
patches, it doesn't how much we try to tell the tide to stop flowing
in.  So yes, we can apply some amount of backpressure, but the real
challenge is to figure out how we can work smarter and flush out the
bugs faster.

							- Ted
