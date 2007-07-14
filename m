Return-Path: <linux-kernel-owner+w=401wt.eu-S1764407AbXGNUrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764407AbXGNUrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762325AbXGNUrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:47:16 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:26089 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762762AbXGNUrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:47:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oiXc97oWAHdDcJItGxTQNXIec1Hig1SaGZwRrWDSACyfQLQDzQC4WP6xybwXh1zCRhIiHv9GpPEjCCb/tOAbZZIRE4pTaY9E3lt/1QtKDiVDnhYa9Om3Tq/kCtlI+7i6mKYESDpY85+vYiDvTFdHsOhT9HSDI1n2AORhlDSP+vc=
Message-ID: <29495f1d0707141347g4f09f9c6pc4068f0fe4d2a6ae@mail.gmail.com>
Date: Sat, 14 Jul 2007 13:47:14 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Cc: "Joe Jin" <joe.jin@oracle.com>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org, gurudas.pai@oracle.com,
       "Paul Jackson" <pj@sgi.com>
In-Reply-To: <20070714110444.48927e27.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	 <20070712221842.f5e47065.akpm@linux-foundation.org>
	 <20070713064004.GA21833@joejin-pc.cn.oracle.com>
	 <20070712234938.c77f3a48.akpm@linux-foundation.org>
	 <20070713080336.GB21833@joejin-pc.cn.oracle.com>
	 <20070713011543.22797645.akpm@linux-foundation.org>
	 <20070713121846.GA25236@joejin-pc.cn.oracle.com>
	 <29495f1d0707141040q7bf0deb5m21f9151fdee66558@mail.gmail.com>
	 <20070714110444.48927e27.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/14/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 14 Jul 2007 10:40:25 -0700 "Nish Aravamudan" <nish.aravamudan@gmail.com> wrote:
>
> > On 7/13/07, Joe Jin <joe.jin@oracle.com> wrote:
> > > >
> > > > Patch gone too ;) I deleted it.  I was hoping that you'd send me the final
> > > > finished product (please).
> > > >
> > >
> > > Ha.., the patch against 2.6.22, at your patch have use htlb_alloc_mask, but I
> > > cannot found it at 2.6.22 kernel tree, I think you must use difference kernel
> > > tree :)
> >
> > I believe this patch will be unnecessary if my "Fix hugetlb pool
> > allocation with empty nodes" patch gets pulled into -mm.
> > alloc_fresh_huge_page() now takes a mempolicy which is created by the
> > two callers, rather than reinventing interleaving itself. I believe
> > this will avoid the oops you saw. I am still waiting on some test
> > results (annoying -mm config changes) before I repost them (and they
> > depend on Christoph's fixes for memoryless nodes).
>
> Could be so, but the patch which I have queued is nice and simple and
> can be backported into 2.6.22.x.

Fair enough. FWIW, just finished testing my patches and have posted
the current incarnation to linux-mm.

Thanks,
Nish
