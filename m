Return-Path: <linux-kernel-owner+w=401wt.eu-S935378AbYBGVYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935378AbYBGVYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935388AbYBGVVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:21:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37643 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935793AbYBGVVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:21:14 -0500
Date: Thu, 7 Feb 2008 13:21:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: jirislaby@gmail.com, stephen.neuendorffer@xilinx.com,
       linux-kernel@vger.kernel.org, paulus@samba.org, galak@gate.crashing.org,
       benh@kernel.crashing.org, torvalds@linux-foundation.org
Subject: Re: Xilinx: hwicap driver comments
Message-Id: <20080207132106.ec5ebf1d.akpm@linux-foundation.org>
In-Reply-To: <fa686aa40802071254p172103f0w423f4591583ca3ef@mail.gmail.com>
References: <47AB6552.7040503@gmail.com>
	<20080207124203.147ce300.akpm@linux-foundation.org>
	<fa686aa40802071254p172103f0w423f4591583ca3ef@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 13:54:06 -0700
"Grant Likely" <grant.likely@secretlab.ca> wrote:

> On 2/7/08, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Thu, 07 Feb 2008 21:08:50 +0100
> > How it got from there into Linux is also a mystery.  I see a batch of
> > powerpc updates just went into mainline but I don't know whose tree was
> > pulled - I wasn't copied on any pull request and I can't find one on the
> > kernel mailing list.
> >
> > Perhaps Paul has just done a stealth merge, but the patch to which you
> > refer doesn't have his signoff.  Very confused.
> 
> It went through my tree.  Paul pulls from Josh Boyer's tree for
> powerpc-4xx patches, and Josh pulls from mine for xilinx virtex
> powerpc 405 patches.
> 
> My screw up, sorry I broke the rules.  What is the best way to resolve this?
> 

Well I think we'd like to see the patches appear in Paul's tree well before
the merge window if poss - that way they'll get a little bit of tyre-kicking
and perhaps review via -mm.  Kamalesh and I (at least) do perform build-
and runtime testing of powerpc.

I would request that Paul copy myself and the main mailing list on pull
requests.

It seems wrong that the signoff trail for that patch didn't actually
reflect reality - it should have had both Josh's and Paul's signoffs.  That
would require that the changelog be altered during git->git transfers which
I expect is just incompatible with the way git works (as far as I dimly
understand it).

It never hurts to send a patch to lkml even if you believe it isn't of
general interest.  People will pass an idle eye across it, and things might
get picked up, yielding improvements.  Plus more people know about its
existence.  Probably this is more the case for something which resides
under drivers/char/ than with something which resides in arch/powerpc/...
