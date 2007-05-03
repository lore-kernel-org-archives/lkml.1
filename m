Return-Path: <linux-kernel-owner+w=401wt.eu-S1767489AbXECQXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767489AbXECQXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767490AbXECQXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:23:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:47253 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767489AbXECQXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:23:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F4wuQyGyyfdc2l5QQjBgi6lmf/o5X7dL4aOj6EDBmHY0QoCPNLGcWkJPluRToz6tgtcVww5oa5oHOVUfNOlw9ZLiHTrGJ+i9eGk0jfC1+iCBm5ATwkogyD0Or+A+nP5GNPk7Wg5O3NxsmFKMLm+zz1K6G9c8Np0K92FkNPJj0fU=
Message-ID: <6bffcb0e0705030923v737bf18fi35b8299874ad565b@mail.gmail.com>
Date: Thu, 3 May 2007 18:23:08 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: swap-prefetch: 2.6.22 -mm merge plans
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Con Kolivas" <kernel@kolivas.org>
In-Reply-To: <6bffcb0e0705030915r7c169f1cnd3b21413255a5c1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	 <20070503155407.GA7536@elte.hu>
	 <6bffcb0e0705030915r7c169f1cnd3b21413255a5c1f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Hi,
>
> On 03/05/07, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > > - If replying, please be sure to cc the appropriate individuals.
> > >   Please also consider rewriting the Subject: to something
> > >   appropriate.
> >
> > i'm wondering about swap-prefetch:
> >
> >   mm-implement-swap-prefetching.patch
> >   swap-prefetch-avoid-repeating-entry.patch
> >   add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
> >
> > The swap-prefetch feature is relatively compact:
> >
> >    10 files changed, 745 insertions(+), 1 deletion(-)
> >
> > it is contained mostly to itself:
> >
> >    mm/swap_prefetch.c            |  581 ++++++++++++++++++++++++++++++++
> >
> > i've reviewed it once again and in the !CONFIG_SWAP_PREFETCH case it's a
> > clear NOP, while in the CONFIG_SWAP_PREFETCH=y case all the feedback
> > i've seen so far was positive. Time to have this upstream and time for a
> > desktop-oriented distro to pick it up.
> >
> > I think this has been held back way too long. It's .config selectable
> > and it is as ready for integration as it ever is going to be. So it's a
> > win/win scenario.
>
> I'm using SWAP_PREFETCH since 2.6.17-mm1 (I don't have earlier configs)

since 2.6.14-mm2 :)
http://lkml.org/lkml/2005/11/11/260

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
