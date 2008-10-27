Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbYJ0JhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbYJ0JhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYJ0JhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:37:04 -0400
Received: from sh.osrg.net ([192.16.179.4]:33610 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbYJ0JhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:37:03 -0400
Date: Mon, 27 Oct 2008 18:36:13 +0900
To: jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu,
       jens.axboe@oracle.com
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with
 BIOVEC_PHYS_MERGEABLE
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49058774.3030506@goop.org>
References: <49057A15.7030007@goop.org>
	<20081027173739Q.fujita.tomonori@lab.ntt.co.jp>
	<49058774.3030506@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081027183604V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 20:18:44 +1100
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> FUJITA Tomonori wrote:
> > I'm not familiar with what Xen does but why can't Xen just override
> > BIOVEC_PHYS_MERGEABLE?
> >
> > Why does Xen need to hook BIOVEC_PHYS_MERGEABLE to the iommu_bio_merge
> > parameter (as this patch does)? BIOVEC_PHYS_MERGEABLE and the
> > iommu_bio_merge parameter are not related at all.
> >   
> 
> No, it doesn't.  It was convenient to reuse that mechanism, but I can 
> easily re-add something else (which would be more or less identical).

I still don't see how Xen needs something like the virtual merge
(sounds that overriding BIOVEC_PHYS_MERGEABLE perfectly works for Xen)
or why Xen needs a new boot parameter for it. The virtual merge just
defines how IOMMUs should work.
