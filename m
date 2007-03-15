Return-Path: <linux-kernel-owner+w=401wt.eu-S1751108AbXCOTGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108AbXCOTGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXCOTGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:06:41 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36613 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbXCOTGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:06:40 -0400
Date: Thu, 15 Mar 2007 11:06:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Keenan <tank.en.mate@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: copy_one_pte()
Message-Id: <20070315110634.a2d08dce.akpm@linux-foundation.org>
In-Reply-To: <45F7B3BB.1030404@gmail.com>
References: <45F6F84D.20302@free.fr>
	<20070313191844.GA4206@infradead.org>
	<45F7B3BB.1030404@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(cc restored.  Please always do reply-to-all).

> On Wed, 14 Mar 2007 08:35:07 +0000 Matt Keenan <tank.en.mate@gmail.com> wrote:
> Christoph Hellwig wrote:
> > On Tue, Mar 13, 2007 at 08:15:25PM +0100, Zoltan Menyhart wrote:
> >   
> >> I had a look at copy_one_pte().
> >> I cannot see any ioproc_update_page() call, not even for the COW pages.
> >> Is it intentional?
> >>     
> >
> > There is no such thing as ioproc_update_page in any mainline tree.
> > You must be looking at some vendor tree with braindead patches applied.
> >
> >   
> It looks like this function exists as a part of patches to support 
> Quadrics NICs / RDMA (HPC platforms).  The patches are there so the 
> driver doesn't need to pin pages, it can be informed of page updates 
> directly.  A patch was submitted to l-k sometime in 2005.

Oh Dear.

Which vendor's kernel are we talking about here?
