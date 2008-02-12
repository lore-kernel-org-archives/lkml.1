Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbYBLFz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbYBLFz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 00:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYBLFzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 00:55:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60671 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbYBLFzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 00:55:31 -0500
Date: Mon, 11 Feb 2008 21:56:48 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-ID: <20080212055648.GB5631@kroah.com>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080212042133.GA4625@kroah.com> <20080212160704.77354af9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212160704.77354af9.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 04:07:04PM +1100, Stephen Rothwell wrote:
> On Mon, 11 Feb 2008 20:21:33 -0800 Greg KH <greg@kroah.com> wrote:
> > I think the only way to fix this is not going to just "drop the tree"
> > like you are suggesting, but to let both people know (the person who
> > caused the change, and the person who's tree broke after the merge), and
> > then either add a "fixup patch" for the build like Andrew has been
> > doing, or disabling something from the build section.
> 
> Right. Except that "drop the tree" will probably only mean for a day or
> so i.e. it will be taken out of the current round but will reappear
> automatically when the conflict/dependency is sorted out.

See my response to Arjan for how this is going to be very difficult to
do, unless you are willing to have patches in -next that are not in any
other tree.

> > As I know I'm going to be changing more driver core apis[1] this week,
> > I'm sure we will get a very good set of examples of this for you to see
> > in action :)
> 
> Excellent!
> 
> However, I am hoping that these global api changes may be introduced in a
> more orderly fashion (some of which is happening already) by creating new
> api's and then switching to them (and them maybe changing the names back
> if necessary).  And, yes, I realise that this is sometimes not possible
> (or at least not worth the extra effort).

It's possible to do in a series of patches, yes, but again, development
happens in parallel, with no one stopping for anyone else, and that's
fine, we work it out when we send stuff to Linus at merge time.

So with that parallel development effort, there are problems like this,
I just want you to be aware of it and plan properly for it, as it is
going to happen...

thanks,

greg k-h
