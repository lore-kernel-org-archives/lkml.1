Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157Ab0AZUD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0AZUD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 15:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033Ab0AZUD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 15:03:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab0AZUD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 15:03:57 -0500
Date: Tue, 26 Jan 2010 15:03:32 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH 19/41] union-mount: Introduce MNT_UNION and MS_UNION flags
Message-ID: <20100126200332.GB10855@shell>
References: <1256152779-10054-20-git-send-email-vaurora@redhat.com> <200911300802.nAU82iLC022867@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911300802.nAU82iLC022867@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 03:02:44AM -0500, Erez Zadok wrote:
> In message <1256152779-10054-20-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> > From: Jan Blunck <jblunck@suse.de>
> > 
> > Add per mountpoint flag for Union Mount support. You need additional patches
> > to util-linux for that to work - see:
> > 
> > git://git.kernel.org/pub/scm/utils/util-linux-ng/val/util-linux-ng.git
> > 
> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> > ---
> >  fs/namespace.c        |    5 ++++-
> >  include/linux/fs.h    |    1 +
> >  include/linux/mount.h |    1 +
> >  3 files changed, 6 insertions(+), 1 deletions(-)
> [...]
> 
> > diff --git a/include/linux/mount.h b/include/linux/mount.h
> > index 5d52753..e175c47 100644
> > --- a/include/linux/mount.h
> > +++ b/include/linux/mount.h
> > @@ -35,6 +35,7 @@ struct mnt_namespace;
> >  #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
> >  #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
> >  #define MNT_PNODE_MASK	0x3000	/* propagation flag mask */
> > +#define MNT_UNION	0x4000	/* if the vfsmount is a union mount */
> 
> I it correct to just add another flag here?  How does it relate to this
> 'propagation mask' right above it?  If there's some code out there which
> masks out which MNT flags get propagated and which don't, then you need to
> make a decision whether MNT_UNION needs to be propagated as well.  Either
> way, please document your decision in a comment here so no one will have to
> ask the same question again.

I sat down and puzzled this out and sent a separate patch to clean up
and comment this part of the code.

-VAL
