Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbZFKMjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbZFKMjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZFKMjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:39:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54638 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbZFKMjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:39:06 -0400
Date: Thu, 11 Jun 2009 13:38:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: swetland@google.com, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611123852.GM795@n2100.arm.linux.org.uk>
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611.050030.169859977.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 05:00:30AM -0700, David Miller wrote:
> From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Date: Thu, 11 Jun 2009 12:49:12 +0100
> 
> > I can not keep up with the number of patches that need to be
> > reviewed and ultimately merged.  I know this, and I freely admit it,
> > and I have done so on many occasions.
> 
> Then split up the responsibilities to other people instead of being
> the choke point.  Controlling everything isn't so important.

Don't you think that I've been trying to get other people to be more
involved?

- I've been pushing people to send patches to the relevent mailing
  list(s) and maintainer(s) for years.

- I've been pushing people to send their ARM patches to the ARM
  mailing list rather than directly into the patch system for review
  (it even has a comment telling people this) so that others can get
  involved in reviewing them, and sharing that work load.

Do you think either have been anywhere near successful?

For the most part, the answer is no.  People concentrate on their own
areas, and won't look at someone with a new class of platforms (eg,
the STMP or W90x900 stuff).

I'd absolutely love it if the review load could be shared, but for the
most part it just doesn't happen.  Everyone's far too busy with their
own stuff to help out (and that's a reason that they'll give if tackled
head on about it.)

As I've already said, akpm tried to setup a mutual review between
several ARM folk, but as far as I'm aware, it has so far been 
unsuccessful (exactly why I don't know.)

So to somehow level an accusation at me that I'm tightly controlling this
stuff is way off the mark.  I've been trying to get greater participation
but it's just not happening.

> Or, alternatively, experiment with tools that could potentially make
> you more efficient (patchwork has worked wonders for me).

If patchwork can replace what my patch system does for me (which is
basically to help ensure that patches don't get lost which need
applying - that's different from logging every single patch) then
I'll gladly look at it.  It will mean that some of the sanity checks
on the patch content, which happen automatically with the patch system,
will need to be done manually.

If patchwork just gathers up every patch which has ever been seen on
a mailing list, then stuff will get lost at a higher rate than today
and it will have a negative impact.
