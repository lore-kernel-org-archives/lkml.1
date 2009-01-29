Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbZA2Ibk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbZA2Ibk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbZA2IbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:31:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41891 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716AbZA2IbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:31:06 -0500
Date: Thu, 29 Jan 2009 08:30:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, tony@atomide.com,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: OMAP clock fast-forward: an introduction to six series
Message-ID: <20090129083049.GB11519@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.00.0901281310590.14710@utopia.booyaka.com> <20090128211844.GI23301@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0901282357560.32081@utopia.booyaka.com> <20090129081117.GA11519@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129081117.GA11519@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 08:11:17AM +0000, Russell King - ARM Linux wrote:
> On Thu, Jan 29, 2009 at 12:05:13AM -0700, Paul Walmsley wrote:
> > Hello Russell,
> > 
> > On Wed, 28 Jan 2009, Russell King - ARM Linux wrote:
> > 
> > > On Wed, Jan 28, 2009 at 01:22:22PM -0700, Paul Walmsley wrote:
> > > > Per rmk's preferences, some patches have been 'compressed.' That is, some 
> > > > fix patches have been rolled into a single patch with the original.  To 
> > > > ease cross-referencing with the linux-omap git tree, original commit IDs 
> > > > have been inserted into the patch messages.  Also, what would have been an 
> > > > extremely long series has been split into six smaller, cumulative, roughly 
> > > > thematic patch series.  If requested, I would be pleased to simply send 
> > > > one large series of the original, uncompressed patches.  Thanks to the git 
> > > > and stgit authors and contributors: without those tools, this process 
> > > > would have been nearly impossible.
> > > 
> > > Since this patch series was only really meant for me to do some follow-on
> > > work on it (to merge it into my tree) is it really necessary to submit
> > > this 70 patch series via slow email via several mailing lists?
> > 
> > I posted the patches for final review and upstream merging.
> > 
> > Not sure what the follow-on work is that you mention.  But if it's 
> > additional development work, such as modifying the linux-omap clock code 
> > to use your recent clkdev code, that should really be discussed 
> > separately, and patches posted for comment to linux-omap, so the OMAP 
> > community has a chance to test it first.  People on that list seem to be 
> > pretty reasonable...
> 
> If that's what you thought I was offering, forget it.  I wasn't.

I'll expand on that.  When clockdomain and powerdomain support was added
to the mainline kernel about six months ago, I specifically asked the
question "Is this everything for this new code" and got told "yes".

I wanted to ensure that the new code I was merging was 100% up to date
with mainline so we wouldn't have a constant drip of old patches to it.

A few weeks later I pulled the omapzoom tree, which contains tony's tree
and diffed the new code, finding some unmerged patches which I added
_before_ that stuff went to Linus.

Since then, I've asked Tony whether the clock code was 100% up to date and
if not send me the patches.  No patches ever came forward.

So, with my work on OMAP first to sort out some of the utter crappyness
in there (which Tony had accepted.)  Tony whinged about it clashing with
your work, but still no clock patches from you or Tony were forthcoming.

Subsequent to that acceptance, and as a result of me getting utterly
pissed off with waiting for something to happen, I converted OMAP over
to use clkdev (so that OMAP can stop abusing the API and being used
as a reason why new implementations should continue this abuse.)

Again, Tony whinged about the big merge problem that this was creating.
So I made an offer to manipulate _your_ changes to apply with my changes.

That's the offer.  The offer is not to merge your code and then think
about what to do with mine possibly in a year or two's time.  OMAP
_is_ going to use the API correctly as soon as possible, no iffs or buts.

Not taking the offer means that you and Tony have to deal with the merging
issues.  Accepting the offer means I do that work for you and publish the
results back to you for your comment.

Your call.
