Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbYDQGvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbYDQGvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 02:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYDQGvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 02:51:08 -0400
Received: from mail2.shareable.org ([80.68.89.115]:57348 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYDQGvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 02:51:06 -0400
Date: Thu, 17 Apr 2008 07:50:59 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080417065059.GA21524@shareable.org>
Mail-Followup-To: Szabolcs Szakacsits <szaka@ntfs-3g.org>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <1208121358.2700.4.camel@shinybook.infradead.org> <E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu> <20080414094215.GD2076@shareable.org> <E1JlLRt-0005JD-QR@pomaz-ex.szeredi.hu> <20080414115540.GA5802@shareable.org> <E1JlNly-0005bt-2v@pomaz-ex.szeredi.hu> <20080414223556.GA21340@shareable.org> <E1JljQD-0008Ae-5H@pomaz-ex.szeredi.hu> <20080415152313.GB8513@shareable.org> <Pine.LNX.4.61.0804170357290.4657@dhcppc2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0804170357290.4657@dhcppc2>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Szabolcs Szakacsits wrote:
> > > > > How old?  The out of tree fuse module (hoping to get rid of it soon)
> > > > > works down to 2.6.9.  Beyond that it does probably require a fair
> > > > > amount of porting work.
> > > > 
> > > > I imagine that backporting FUSE to 2.4 no-mmu will be more work than
> > > > backporting a filesystem, but I could be mistaken.  Moving my project
> > > > to a 2.6 kernel (*any* 2.6 kernel) would be much more work than
> > > > either.
> > > 
> > > Fuse-2.5 still supported linux-2.4.  Although I have no idea if it
> > > works with no-mmu, maybe it's worth a try.
> > > 
> > > Backporting ntfs-3g to an older version of fuse shouldn't be a big
> > > problem, as the fuse interface didn't change very much since then.
> > 
> > Thanks for your advice.  I will look into all these possibilities.
> > Fuse working would be quite useful in many other ways too.
> 
> ntfs-3g was reported to work on 2.4 no-mmu kernels six months ago (though 
> it had no our QA). Please see http://ntfs-3g.org/support.html#kernel24 and 
> search for nommu on fuse-devel for the details.

Ah, wonderful!  2.4 kernel support has been _added_ to NTFS-3g's
"FUSE-lite" since I last looked!

Nice to see 2.4 kernel support is still an active priority ;-)

Thanks for the info, it's really useful.  I would never have thought
to check for 2.4 support being added back, since an earlier
announcement said it was no longer supported.

(Btw, The NTFS-3g release notes, on it's decision to replace the FUSE
userspace libs (which is what makes it work with 2.4 kernels too),
suggest there may be serious problems in the standard FUSE libs,
especially on small devices.  It doesn't bother me, as I only need
NTFS-3g, not other FUSE capabilities, but perhaps FUSE developers
would like to take a look at those problems.)

Thanks again,
-- Jamie
