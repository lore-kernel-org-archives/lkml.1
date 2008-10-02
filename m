Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbYJBGj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbYJBGj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 02:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbYJBGjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 02:39:18 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45504 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbYJBGjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 02:39:18 -0400
Date: Thu, 2 Oct 2008 08:38:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John Jolly <jjolly@novell.com>, JBlunck@novell.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] block: installing include/linux/blktrace_api.h
Message-ID: <20081002063858.GS19428@kernel.dk>
References: <48DA5317.9030705@novell.com> <20081001231138.266452cc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001231138.266452cc.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01 2008, Andrew Morton wrote:
> > On Wed, 24 Sep 2008 08:47:51 -0600 John Jolly <jjolly@novell.com> wrote:
> > From: John Jolly <jjolly@novell.com>
> > 
> > Added line to install include/linux/blktrace_api.h during 'make headers_install'
> > 
> > Signed-off-by: John Jolly <jjolly@novell.com>
> > CC: Jan Blunck <JBlunck@novell.com>
> > ---
> >  include/linux/Kbuild |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> > index b68ec09..f1e5fa1 100644
> > --- a/include/linux/Kbuild
> > +++ b/include/linux/Kbuild
> > @@ -41,6 +41,7 @@ header-y += baycom.h
> >  header-y += bfs_fs.h
> >  header-y += blkpg.h
> >  header-y += bpqether.h
> > +header-y += blktrace_api.h
> >  header-y += can.h
> >  header-y += cdk.h
> >  header-y += chio.h
> 
> The two basic and almost always necessary parts of a patch changelog are
> 
> a) what was changed and
> 
> b) why the change was made
> 
> Your changelog had no b), hence nobody is likely to apply the patch.

A similar patch is already merged for 2.6.28 as well.

-- 
Jens Axboe

