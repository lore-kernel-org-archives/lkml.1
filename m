Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbZHCQtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbZHCQtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbZHCQtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:49:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39516 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbZHCQta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:49:30 -0400
Date: Mon, 3 Aug 2009 18:48:59 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Izik Eidus <ieidus@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 1/12] ksm: rename kernel_pages_allocated
Message-ID: <20090803164859.GG23385@random.random>
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
 <Pine.LNX.4.64.0908031308590.16754@sister.anvils>
 <4A76F27E.5070407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A76F27E.5070407@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 05:21:50PM +0300, Izik Eidus wrote:
> Hugh Dickins wrote:
> > We're not implementing swapping of KSM pages in its first release;
> > but when that follows, "kernel_pages_allocated" will be a very poor
> > name for the sysfs file showing number of nodes in the stable tree:
> > rename that to "pages_shared" throughout.
> >
> > But we already have a "pages_shared", counting those page slots
> > sharing the shared pages: first rename that to... "pages_sharing".
> >
> > What will become of "max_kernel_pages" when the pages shared can
> > be swapped?  I guess it will just be removed, so keep that name.
> >
> > Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > ---
> >
> >
> >   
> ACK.

Not sure if it worth doing the subtraction between the number of user
mappings pointing to the ksm_pages_shared.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
