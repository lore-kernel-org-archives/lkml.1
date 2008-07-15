Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYGOL4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYGOL4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 07:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbYGOL4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 07:56:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35235 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138AbYGOL4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 07:56:23 -0400
Date: Tue, 15 Jul 2008 12:56:20 +0100 (IST)
From: Dave Airlie <airlied@skynet.ie>
To: Oliver Pinter <oliver.pntr@gmail.com>
cc: stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: [git pull] drm radeon fix for 2.6.27-rc1
In-Reply-To: <6101e8c40807150356t5ecb0885ud0249eff1ec03e77@mail.gmail.com>
Message-ID: <alpine.DEB.0.82.0807151256030.6038@skynet.skynet.ie>
References: <alpine.DEB.0.82.0807150702330.6038@skynet.skynet.ie>
 <6101e8c40807150356t5ecb0885ud0249eff1ec03e77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi David,
> 
> it affects stable (2.6.26) too?

yes I've already sent a patch to stable maintainers.

Dave.

> 
> On 7/15/08, Dave Airlie <airlied@skynet.ie> wrote:
> >
> > Hi Linus,
> >
> > Please pull the 'drm-fixes' branch from
> > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> > drm-fixes
> >
> > It appears we have a PAT incomPATibility, with how the radeon driver was
> > mapping some VRAM.
> >
> > Dave.
> >
> >  drivers/gpu/drm/drm_memory.c       |    5 +++++
> >  drivers/gpu/drm/radeon/radeon_cp.c |    2 +-
> >  include/drm/drmP.h                 |    1 +
> >  3 files changed, 7 insertions(+), 1 deletions(-)
> >
> > commit 242e3df80b8d25ed681c278512df0993725f25dd
> > Author: Dave Airlie <airlied@linux.ie>
> > Date:   Tue Jul 15 15:48:05 2008 +1000
> >
> >     drm/radeon: fixup issue with radeon and PAT support.
> >
> >     With new userspace libpciaccess we can get a conflicting mapping
> >     on the PCIE GART table in the video RAM. Always try and map it _wc.
> >
> >     Signed-off-by: Dave Airlie <airlied@redhat.com>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> 
