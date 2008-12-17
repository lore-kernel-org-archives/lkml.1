Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759279AbYLQCwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbYLQCwY (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 21:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbYLQCwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 21:52:07 -0500
Received: from sh.osrg.net ([192.16.179.4]:56596 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbYLQCwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 21:52:06 -0500
Date: Wed, 17 Dec 2008 11:51:26 +0900
To: jeremy@goop.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        x86@kernel.org, ian.campbell@citrix.com, jbeulich@novell.com
Subject: Re: [PATCH 04 of 14] swiotlb: consistently use
 address_needs_mapping	everywhere
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081217113804F.fujita.tomonori@lab.ntt.co.jp>
References: <patchbomb.1229458644@abulafia.goop.org>
	<aba0c734944520d4b892.1229458648@abulafia.goop.org>
	<20081217113804F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081217115217G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 11:48:41 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Tue, 16 Dec 2008 12:17:28 -0800
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > ---
> >  lib/swiotlb.c |   10 +++-------
> >  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> This patch is wrong.
> 
> dma_mask and coherent_dma_mask represent different restrictions.
> 
> You can't use coherent_dma_mask for alloc_coherent.

Oops, "you can't use dma_mask for alloc_coherent."
