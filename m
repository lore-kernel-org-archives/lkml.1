Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYJCGkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYJCGkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 02:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYJCGkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 02:40:33 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:42674 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753649AbYJCGkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 02:40:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oW6jwOEV/hIm9PNxpouzxk6fASERStFe7D7PfhhPW59xw5DOP1GjLI8VtJFQIoMZkOF+Vs2aWlECBukhmjpKf7+A6W28FQlnttWWuaMzs/Quqn4x9wqt/l6q4VgJpmzR67dqlkS9cO6z8HJJooWoe2Xyt6YkYLXFDwA6vt1Bxd4=  ;
X-YMail-OSG: zmnQbxEVM1kaNC32ebOuddWDCNiCS41rnbpj0t8xvAdljQWDJ.gqcPsCj.r.Du.g_j0mdesXbpGpIvAm3bz0ucBhdQTPT8eOLfmYvABv7xDAbpvcl3Bi0.lvZPQ75BWukkL4mE1RBi7JcIcdRCP.rrOOgLElcQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Keith Packard <keithp@keithp.com>
Subject: Re: [patch] mm: pageable memory allocator (for DRM-GEM?)
Date: Fri, 3 Oct 2008 16:40:23 +1000
User-Agent: KMail/1.9.5
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Nick Piggin <npiggin@suse.de>, "hugh@veritas.com" <hugh@veritas.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "airlied@linux.ie" <airlied@linux.ie>,
       "thomas@tungstengraphics.com" <thomas@tungstengraphics.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080923091017.GB29718@wotan.suse.de> <200810021015.55880.jbarnes@virtuousgeek.org> <1223011071.21240.64.camel@koto.keithp.com>
In-Reply-To: <1223011071.21240.64.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031640.24158.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2008 15:17, Keith Packard wrote:
> On Thu, 2008-10-02 at 10:15 -0700, Jesse Barnes wrote:
> > At this point I think we should go ahead and include Eric's earlier
> > patchset into drm-next, and continue to refine the internals along the
> > lines of what you've posted here in the post-2.6.28 timeframe.
>
> Nick, in case you missed the plea here, we're asking if you have any
> objection to shipping the mm changes present in Eric's patch in 2.6.28.
> When your new pageable allocator becomes available, we'll switch over to
> using that instead and revert Eric's mm changes.

So long as we don't have to support the shmem exports for too long,
I'm OK with that. The pageable allocator probably is probably not a
2.6.28 merge candidate at this point, so I don't want to hold things
up if we have a definite way forward.


> We're ready to promise to support the user-land DRM interface going
> forward, and we've got lots of additional work queued up behind this
> merge. We'd prefer to push stuff a bit at a time rather than shipping a
> lot of new code in a single kernel release.

I would have liked to see more effort going towards building the user
API starting with a pseudo filesystem rather than ioctls, but that's
just my opinion after squinting at the problem from 100 metres away..
So I don't have a strong standing to demand a change here ;)

So, I'm OK with it for 2.6.28.

I think Christoph had some concerns with the patches, and I'd like to
hear that he's happy now. Christoph? Does the pageable allocator API
satisfy your concerns, or did you have other issues with it?

Thanks,
Nick
