Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYLUQgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYLUQgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 11:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYLUQgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 11:36:37 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:52374 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbYLUQgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 11:36:37 -0500
Date: Sun, 21 Dec 2008 17:36:33 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 9/13] fs/xfs: Remove redundant test
In-Reply-To: <494E6846.8070800@sandeen.net>
Message-ID: <Pine.LNX.4.64.0812211736150.9555@pc-004.diku.dk>
References: <Pine.LNX.4.64.0812211640360.9555@pc-004.diku.dk>
 <494E6846.8070800@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Looks fine to me, though a similar test under the #ifdef DEBUG can
> probably also be removed.

Indeed.  I will send an updated patch.

julia

> -Eric
> 
> > ---
> >  fs/xfs/xfs_trans_buf.c              |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> > index 8ee2f8c..22afe29 100644
> > --- a/fs/xfs/xfs_trans_buf.c
> > +++ b/fs/xfs/xfs_trans_buf.c
> > @@ -307,7 +307,7 @@ xfs_trans_read_buf(
> >  			return (flags & XFS_BUF_TRYLOCK) ?
> >  					EAGAIN : XFS_ERROR(ENOMEM);
> >  
> > -		if ((bp != NULL) && (XFS_BUF_GETERROR(bp) != 0)) {
> > +		if (XFS_BUF_GETERROR(bp) != 0) {
> >  			xfs_ioerror_alert("xfs_trans_read_buf", mp,
> >  					  bp, blkno);
> >  			error = XFS_BUF_GETERROR(bp);
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
