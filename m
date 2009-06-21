Return-Path: <linux-kernel-owner+w=401wt.eu-S1751841AbZFUEIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbZFUEIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 00:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbZFUEIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 00:08:04 -0400
Received: from iabervon.org ([66.92.72.58]:48446 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbZFUEID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 00:08:03 -0400
Date: Sun, 21 Jun 2009 00:08:05 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Frans Pop <elendil@planet.nl>
cc: Sean MacLennan <smaclennan@pikatech.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Badness on the Warp
In-Reply-To: <200906210126.09049.elendil@planet.nl>
Message-ID: <alpine.LNX.2.00.0906202323580.2147@iabervon.org>
References: <20090620154824.72b5cd50@lappy.seanm.ca> <200906202256.46073.elendil@planet.nl> <20090620191034.48fa085a@lappy.seanm.ca> <200906210126.09049.elendil@planet.nl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jun 2009, Frans Pop wrote:

> On Sunday 21 June 2009, Sean MacLennan wrote:
> > On Sat, 20 Jun 2009 22:56:45 +0200 Frans Pop <elendil@planet.nl> wrote:
> > > The fact that your bisect ended at a merge essentially means that it
> > > is invalid. As a merge does not introduce any actual change (unless
> > > it includes changes to resolve conflicts), it normally cannot be the
> > > cause of a regression.
> >
> > Makes sense I messed up somewhere. This is the commit that causes
> > problems:
> >
> > Merge branch 'topic/slab/earlyboot' of
> > git://git./linux/kernel/git/penberg/slab-2.6
> >
> > * 'topic/slab/earlyboot' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6:
> 
> Hmmm. That's b640f042faa2, which is another merge...
> So you're still not there.

It's not implausible that this is, in fact, the first bad commit. The 
early slab topic could easily have been correct for everything in the tree 
when it was written, but cause problems with some other patch developed 
simultaneously.

It's worth rechecking that both 871fa90 and b8ec757 are good and 
b640f042faa2 is bad, since it's also pretty likely that the test isn't 
reproducing perfectly.

	-Daniel
*This .sig left intentionally blank*
