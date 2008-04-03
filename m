Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbYDCBng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbYDCBng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 21:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757869AbYDCBn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 21:43:28 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:36040 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668AbYDCBn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 21:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TWdwUgI/3RJ3d80ROU6CZ/dqopnliP+UaPUjetit6rWv9nYZSPAN8Tsr9X8ZZC1pSjYZvmfMUOQTlHuEckHTEyDbiAtz7z8Ckc5n6AIxE1+m2oHv/C/7ImyLk9y3qKo/LVsQzFxH9twcIRgdpEagK3eOHNruOV17UOQU0ZU5L80=
Message-ID: <86802c440804021843i57f5e82fsee5121bf97d65909@mail.gmail.com>
Date: Wed, 2 Apr 2008 18:43:24 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: allocate usemap at first instead of mem_map in sparse_init
Cc: "Yinghai Lu" <yhlu.kernel.send@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Badari Pulavarty" <pbadari@us.ibm.com>, michael@ellerman.id.au,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org, "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440804021744m7c6e3d94vcb6af3ebcaa71b5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804021525.48799.yhlu.kernel@gmail.com>
	 <20080402155247.5e746be7.akpm@linux-foundation.org>
	 <86802c440804021744m7c6e3d94vcb6af3ebcaa71b5b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 5:44 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Wed, Apr 2, 2008 at 3:52 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>  >
>  > On Wed, 2 Apr 2008 15:25:48 -0700 Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>  >
>  >  > [PATCH] mm: allocate usemap at first instead of mem_map in sparse_init
>  >  >
>  >  > on powerpc,
>  >  >
>  >  > On Wed, Apr 2, 2008 at 12:22 PM, Badari Pulavarty <pbadari@us.ibm.com> wrote:
>  >  > >
>  >  > > On Wed, 2008-04-02 at 18:17 +1100, Michael Ellerman wrote:
>  >  > >  > On Wed, 2008-04-02 at 12:38 +0530, Kamalesh Babulal wrote:
>  >  > >  > > Andrew Morton wrote:
>  >  > >  > > > On Wed, 02 Apr 2008 11:55:36 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>  >  > so try to allocate usemap at first altogether.
>  >
>  >  I have to turn all the above crud into a proper changelog.  I'd prefer that
>  >  you do it.
>  >
>  >  Unless this patch should be folded into another one, in which case it
>  >  doesn't matter.
>  >
>  >
>  >  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>  >  >
>  >  > diff --git a/mm/sparse.c b/mm/sparse.c
>  >  > index d3cb085..782ebe5 100644
>  >  > --- a/mm/sparse.c
>  >  > +++ b/mm/sparse.c
>  >
>  >  We shouldn't merge this patch on its own because then that will leave a
>  >  non-bisectable region in the powerpc history.
>  >
>  >  So which patch is this patch fixing?  Lexically it applies to
>  >  mm-allocate-section_map-for-sparse_init.patch (and its updates).  But is
>  >  that where it logically lies?
>
>  yes. we should fold
>
>
>  mm-make-mem_map-allocation-continuous.patch
>
> mm-allocate-section_map-for-sparse_init.patch
>  and this one
>

please check the big one.
http://lkml.org/lkml/2008/4/2/650

YH
