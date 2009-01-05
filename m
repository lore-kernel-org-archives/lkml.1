Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbZAEJSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbZAEJSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZAEJS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:18:27 -0500
Received: from brick.kernel.dk ([93.163.65.50]:26300 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbZAEJS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:18:26 -0500
Date: Mon, 5 Jan 2009 10:17:22 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alberto Bertogli <albertito@blitiri.com.ar>, linux-kernel@vger.kernel.org,
       trivial@kernel.org, corbet@lwn.net
Subject: Re: [PATCH] Fix small typo in bio.h's documentation
Message-ID: <20090105091722.GG32491@kernel.dk>
References: <1230591376-9001-1-git-send-email-albertito@blitiri.com.ar> <alpine.LNX.1.10.0901040028561.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0901040028561.5377@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04 2009, Jiri Kosina wrote:
> On Mon, 29 Dec 2008, Alberto Bertogli wrote:
> 
> > Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
> > ---
> >  include/linux/bio.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/bio.h b/include/linux/bio.h
> > index 6a64209..b29e2b3 100644
> > --- a/include/linux/bio.h
> > +++ b/include/linux/bio.h
> > @@ -135,7 +135,7 @@ struct bio {
> >   * bit 1 -- rw-ahead when set
> >   * bit 2 -- barrier
> >   *	Insert a serialization point in the IO queue, forcing previously
> > - *	submitted IO to be completed before this oen is issued.
> > + *	submitted IO to be completed before this one is issued.
> >   * bit 3 -- synchronous I/O hint: the block layer will unplug immediately
> >   *	Note that this does NOT indicate that the IO itself is sync, just
> >   *	that the block layer will not postpone issue of this IO by plugging.
> > -- 
> > 1.6.1.302.gccd4d
> 
> Has anyone merged this patch through his tree (Jens or Documentation 
> people?). If not, I will take it through trivial tree.

I'll throw it in, thanks Alberto!

-- 
Jens Axboe

