Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbZDQJof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbZDQJof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 05:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbZDQJo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 05:44:27 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:58875 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbZDQJoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:44:25 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Apr 2009 05:44:25 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=eYPiTLdrhyAkV4djrGnarEsBQPTYzCgvRet1X1dr2ouMYWhcLwCmdpnwor/vx4rnbJ
         C0LDo75TRlW3e0EZa60Wm7UTXuG3OSSb3Dpik0HGpBhKda2QR7RLbnNmVXhtbjItqZh3
         DQV97EUe9eYmwzhDX2+5bd8FT6Mvv34b5c6l0=
Date: Fri, 17 Apr 2009 11:44:20 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, menage@google.com,
       balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, chlunde@ping.uio.no, dave@linux.vnet.ibm.com,
       dpshah@google.com, eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, lizf@cn.fujitsu.com, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] bio-cgroup controller
Message-ID: <20090417094419.GC8689@linux>
Mail-Followup-To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Ryo Tsuruta <ryov@valinux.co.jp>, menage@google.com,
	balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
	agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
	baramsori72@gmail.com, chlunde@ping.uio.no, dave@linux.vnet.ibm.com,
	dpshah@google.com, eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
	taka@valinux.co.jp, lizf@cn.fujitsu.com, matt@bluehost.com,
	dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
	roberto@unbit.it, s-uchida@ap.jp.nec.com,
	subrata@linux.vnet.ibm.com, yoshikawa.takuya@oss.ntt.co.jp,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1239740480-28125-4-git-send-email-righi.andrea@gmail.com> <20090415111528.b796519a.kamezawa.hiroyu@jp.fujitsu.com> <20090415093716.GA5968@linux> <20090415.213850.226770691.ryov@valinux.co.jp> <20090415132356.GA19270@linux> <20090416085814.8b6d077f.kamezawa.hiroyu@jp.fujitsu.com> <20090416104234.GA6656@linux> <20090417090451.5ad9022f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417090451.5ad9022f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 09:04:51AM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 16 Apr 2009 12:42:36 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
> > On Thu, Apr 16, 2009 at 08:58:14AM +0900, KAMEZAWA Hiroyuki wrote:
> > > On Wed, 15 Apr 2009 15:23:57 +0200
> > > Andrea Righi <righi.andrea@gmail.com> wrote:
> > > 
> > > > On Wed, Apr 15, 2009 at 09:38:50PM +0900, Ryo Tsuruta wrote:
> > > > > Hi Andrea and Kamezawa-san,
> > > > > 
> > > > > > Ryo, it would be great if you can look at this and fix/integrate into
> > > > > > the mainstream bio-cgroup. Otherwise I can try to to schedule this in my
> > > > > > work.
> > > > > 
> > > > > O.K. I'll apply those fixes and post patches as soon as I can.
> > > > > 
> > > > 
> > > > Very good! I've just tested the bio_cgroup_id inclusion in
> > > > page_cgroup->flags. I'm posting the patch on-top-of my patchset.
> > > > 
> > > > If you're interested, it should apply cleanly to the original
> > > > bio-cgroup, except for the get/put_cgroup_from_page() part.
> > > > 
> > > > Thanks,
> > > > -Andrea
> > > > ---
> > > > bio-cgroup: encode bio_cgroup_id in page_cgroup->flags
> > > > 
> > > > Encode the bio_cgroup_id into the flags argument of page_cgroup as
> > > > suggested by Kamezawa.
> > > > 
> > > > Lower 16-bits of the flags attribute are used for the actual page_cgroup
> > > > flags. The rest is reserved to store the bio-cgroup id.
> > > > 
> > > > This allows to save 4 bytes (in 32-bit architectures) or 8 bytes (in
> > > > 64-bit) for each page_cgroup element.
> > > > 
> > > > Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> > > > ---
> > > >  include/linux/biotrack.h    |    2 +-
> > > >  include/linux/page_cgroup.h |   24 +++++++++++++++++++++---
> > > >  mm/biotrack.c               |   26 ++++++++++++--------------
> > > >  3 files changed, 34 insertions(+), 18 deletions(-)
> > > > 
> > > > diff --git a/include/linux/biotrack.h b/include/linux/biotrack.h
> > > > index 25b8810..4bd0242 100644
> > > > --- a/include/linux/biotrack.h
> > > > +++ b/include/linux/biotrack.h
> > > > @@ -28,7 +28,7 @@ struct bio_cgroup {
> > > >  
> > > >  static inline void __init_bio_page_cgroup(struct page_cgroup *pc)
> > > >  {
> > > > -	pc->bio_cgroup_id = 0;
> > > > +	page_cgroup_set_bio_id(pc, 0);
> > > >  }
> > > >  
> > > >  extern struct cgroup *get_cgroup_from_page(struct page *page);
> > > > diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> > > > index 00a49c5..af780a4 100644
> > > > --- a/include/linux/page_cgroup.h
> > > > +++ b/include/linux/page_cgroup.h
> > > > @@ -16,12 +16,30 @@ struct page_cgroup {
> > > >  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
> > > >  	struct mem_cgroup *mem_cgroup;
> > > >  #endif
> > > > -#ifdef CONFIG_CGROUP_BIO
> > > > -	int bio_cgroup_id;
> > > > -#endif
> > > >  	struct list_head lru;		/* per cgroup LRU list */
> > > >  };
> > > >  
> > > > +#ifdef CONFIG_CGROUP_BIO
> > > > +/*
> > > > + * use lower 16 bits for flags and reserve the rest for the bio-cgroup id
> > > > + */
> > > > +#define BIO_CGROUP_ID_SHIFT	(16)
> > > > +#define BIO_CGROUP_ID_BITS (8 * sizeof(unsigned long) - BIO_CGROUP_ID_SHIFT)
> > > > +
> > > > +static inline unsigned long page_cgroup_get_bio_id(struct page_cgroup *pc)
> > > > +{
> > > > +	return pc->flags >> BIO_CGROUP_ID_SHIFT;
> > > > +}
> > > > +
> > > > +static inline void page_cgroup_set_bio_id(struct page_cgroup *pc,
> > > > +				unsigned long id)
> > > > +{
> > > > +	WARN_ON(id >= (1UL << BIO_CGROUP_ID_BITS));
> > > > +	pc->flags &= (1UL << BIO_CGROUP_ID_SHIFT) - 1;
> > > > +	pc->flags |= (unsigned long)(id << BIO_CGROUP_ID_SHIFT);
> > > > +}
> > > > +#endif
> > > > +
> > > Ah, there is "Lock" bit in pc->flags and above "set" code does read-modify-write
> > > without lock_page_cgroup().
> > > 
> > > Could you use lock_page_cgroup() or cmpxchg ? (or using something magical technique ?)
> > 
> > If I'm not wrong this should guarantee atomicity without using
> > lock_page_cgroup().
> 
>   thread A                      thread B
> =================         ======================
>                           val = pc->flags
> lock_page_cgroup()
>                           pc->flags |= hogehoge
> unlock_page_cgroup()
> 
> 
> *And* we may add another flags to page_cgroup. plz avoid corner cases.

argh! right. So, better to use lock/unlock_page_cgroup(). I'll fix it or
wait Ryo if he'll decide to apply this to the mainstream bio-cgroup
(..or whatever name, I vote for blkio_cgroup BTW).

Thanks,
-Andrea
