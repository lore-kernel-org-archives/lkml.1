Return-Path: <linux-kernel-owner+w=401wt.eu-S1761063AbXGNSG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063AbXGNSG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 14:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758610AbXGNSGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 14:06:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758563AbXGNSGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 14:06:21 -0400
Date: Sat, 14 Jul 2007 11:04:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nish Aravamudan" <nish.aravamudan@gmail.com>
Cc: "Joe Jin" <joe.jin@oracle.com>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org, gurudas.pai@oracle.com,
       "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-Id: <20070714110444.48927e27.akpm@linux-foundation.org>
In-Reply-To: <29495f1d0707141040q7bf0deb5m21f9151fdee66558@mail.gmail.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	<20070712221842.f5e47065.akpm@linux-foundation.org>
	<20070713064004.GA21833@joejin-pc.cn.oracle.com>
	<20070712234938.c77f3a48.akpm@linux-foundation.org>
	<20070713080336.GB21833@joejin-pc.cn.oracle.com>
	<20070713011543.22797645.akpm@linux-foundation.org>
	<20070713121846.GA25236@joejin-pc.cn.oracle.com>
	<29495f1d0707141040q7bf0deb5m21f9151fdee66558@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007 10:40:25 -0700 "Nish Aravamudan" <nish.aravamudan@gmail.com> wrote:

> On 7/13/07, Joe Jin <joe.jin@oracle.com> wrote:
> > >
> > > Patch gone too ;) I deleted it.  I was hoping that you'd send me the final
> > > finished product (please).
> > >
> >
> > Ha.., the patch against 2.6.22, at your patch have use htlb_alloc_mask, but I
> > cannot found it at 2.6.22 kernel tree, I think you must use difference kernel
> > tree :)
> 
> I believe this patch will be unnecessary if my "Fix hugetlb pool
> allocation with empty nodes" patch gets pulled into -mm.
> alloc_fresh_huge_page() now takes a mempolicy which is created by the
> two callers, rather than reinventing interleaving itself. I believe
> this will avoid the oops you saw. I am still waiting on some test
> results (annoying -mm config changes) before I repost them (and they
> depend on Christoph's fixes for memoryless nodes).

Could be so, but the patch which I have queued is nice and simple and
can be backported into 2.6.22.x.
