Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbXLIFJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbXLIFJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 00:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXLIFJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 00:09:21 -0500
Received: from waste.org ([66.93.16.53]:43061 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbXLIFJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 00:09:21 -0500
Date: Sat, 8 Dec 2007 23:08:31 -0600
From: Matt Mackall <mpm@selenic.com>
To: tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] random: improve variable naming, clear extract buffer
Message-ID: <20071209050831.GS19691@waste.org>
References: <2.753618428@selenic.com> <7.753618428@selenic.com> <20071209015154.GW17037@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209015154.GW17037@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 08:51:54PM -0500, Theodore Tso wrote:
> On Sat, Dec 08, 2007 at 05:21:00PM -0600, Matt Mackall wrote:
> > random: improve variable naming, clear extract buffer
> > 
> > - split the SHA variables apart into hash and workspace
> > - rename data to extract
> > - wipe extract and workspace after hashing
> > 
> > diff -r 924f9a441236 drivers/char/random.c
> > --- a/drivers/char/random.c	Sat Dec 08 16:22:29 2007 -0600
> > +++ b/drivers/char/random.c	Sat Dec 08 16:32:31 2007 -0600
> > @@ -461,7 +461,7 @@ static void __add_entropy_words(struct e
> >  	unsigned long flags;
> >  	/* rotate the add pointer more rapidly to span more of the
> >  	 * pool on a given add */
> > -	const int step = 5;
> > +	const int step = 13;
> >  
> >  	/* Taps are constant, so we can load them without holding r->lock.  */
> >  	tap1 = r->poolinfo->tap1;
> 
> This change has nothing to do with the patch comment.  If you want to
> change the step size from 5 to 13, why not just change patch 5/6 to
> just use a step size of 13 from the beginning?

Patch refresh gone wrong.
 
> Otherwise, yeah, this patch does make sense.

Twice, in fact. This patch as sent won't compile due to an extra &.

-- 
Mathematics is the supreme nostalgia of our time.
