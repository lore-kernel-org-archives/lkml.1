Return-Path: <linux-kernel-owner+w=401wt.eu-S1762495AbYHDTnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762495AbYHDTnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922AbYHDTm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:42:57 -0400
Received: from mail.fieldses.org ([66.93.2.214]:54781 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757528AbYHDTmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:42:55 -0400
Date: Mon, 4 Aug 2008 15:42:39 -0400
To: Matt Mackall <mpm@selenic.com>
Cc: Tim Bird <tim.bird@am.sony.com>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, matthew@wil.cx,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
Message-ID: <20080804194239.GN25940@fieldses.org>
References: <20080731092703.661994657@free-electrons.com> <20080731093220.969460336@free-electrons.com> <20080802163848.GB30454@fieldses.org> <20080804155237.1f64892d@surf> <20080804181641.GE25940@fieldses.org> <48974973.6000408@am.sony.com> <20080804182532.GF25940@fieldses.org> <1217876041.3657.119.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1217876041.3657.119.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 01:54:01PM -0500, Matt Mackall wrote:
> 
> On Mon, 2008-08-04 at 14:25 -0400, J. Bruce Fields wrote:
> > On Mon, Aug 04, 2008 at 11:24:51AM -0700, Tim Bird wrote:
> > > J. Bruce Fields wrote:
> > > > On Mon, Aug 04, 2008 at 03:52:37PM +0200, Thomas Petazzoni wrote:
> > > >> Le Sat, 2 Aug 2008 12:38:48 -0400,
> > > >> "J. Bruce Fields" <bfields@fieldses.org> a écrit :
> > > >>
> > > >>> Out of curiosity, why does the nfs client need disabling, but not
> > > >>> nfsd, gfs2, fuse, etc.?
> > > >> Then also need disabling.
> > > > 
> > > > OK by me, but again, why exactly?  Since you're replacing the locking
> > > > calls they used by stubs that just return errors, in theory nfs, nfsd,
> > > > gfs2, and the rest should still compile and run, just without locking
> > > > support, right?
> > > 
> > > I think so, but haven't tested this myself.
> > > 
> > > However, I would still be inclined to NOT add the extra config
> > > dependencies.  Just my 2 cents.
> > 
> > OK.  My fear was that there was some good reason that the nfs dependency
> > was added in the first place, and that it's since been lost....
> 
> I vaguely remember there was some compile issue here, but that would
> have been back in the 2.6.10 era.

Sounds plausible.  I've got no objection to the patch either way, but if
we could at least just add a comment documenting the issue (if it
exists), that might be helpful.

--b.
