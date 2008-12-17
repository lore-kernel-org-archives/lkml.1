Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756542AbYLQQpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbYLQQpy (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758042AbYLQQnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:43:53 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:54638 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028AbYLQQnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:43:50 -0500
X-IronPort-AV: E=Sophos;i="4.36,238,1228107600"; 
   d="scan'208";a="32478913"
Subject: Re: [PATCH 04 of 14] swiotlb: consistently use
	address_needs_mapping	everywhere
From: Ian Campbell <Ian.Campbell@citrix.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, x86@kernel.org, jbeulich@novell.com
In-Reply-To: <20081217115217G.fujita.tomonori@lab.ntt.co.jp>
References: <patchbomb.1229458644@abulafia.goop.org>
	 <aba0c734944520d4b892.1229458648@abulafia.goop.org>
	 <20081217113804F.fujita.tomonori@lab.ntt.co.jp>
	 <20081217115217G.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Wed, 17 Dec 2008 16:43:38 +0000
Message-Id: <1229532218.25701.127.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Dec 2008 16:43:48.0325 (UTC) FILETIME=[A2561150:01C96066]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 11:51 +0900, FUJITA Tomonori wrote:
> On Wed, 17 Dec 2008 11:48:41 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > On Tue, 16 Dec 2008 12:17:28 -0800
> > Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > 
> > > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > > ---
> > >  lib/swiotlb.c |   10 +++-------
> > >  1 file changed, 3 insertions(+), 7 deletions(-)
> > 
> > This patch is wrong.
> > 
> > dma_mask and coherent_dma_mask represent different restrictions.
> > 
> > You can't use coherent_dma_mask for alloc_coherent.
> 
> Oops, "you can't use dma_mask for alloc_coherent."

You are right, I completely overlooked that it was coherent_dma_mask in
one place and just dma_mask in the other, sorry for the noise.

Ian.


