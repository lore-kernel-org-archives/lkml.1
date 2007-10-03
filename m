Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbXJCK7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbXJCK7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbXJCK7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:59:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41948 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755916AbXJCK7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:59:06 -0400
Date: Wed, 3 Oct 2007 03:58:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Torvalds, Linus" <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: remove zero_page (was Re: -mm merge plans for 2.6.24)
Message-Id: <20071003035853.c5a777e2.akpm@linux-foundation.org>
In-Reply-To: <200710030345.10026.nickpiggin@yahoo.com.au>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	<200710030345.10026.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2007 03:45:09 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > mm-use-pagevec-to-rotate-reclaimable-page.patch
> > mm-use-pagevec-to-rotate-reclaimable-page-fix.patch
> > mm-use-pagevec-to-rotate-reclaimable-page-fix-2.patch
> > mm-use-pagevec-to-rotate-reclaimable-page-fix-function-declaration.patch
> > mm-use-pagevec-to-rotate-reclaimable-page-fix-bug-at-include-linux-mmh220.p
> >atch
> > mm-use-pagevec-to-rotate-reclaimable-page-kill-redundancy-in-rotate_reclaim
> >able_page.patch
> > mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drai
> >n.patch
> >
> >   I guess I'll merge this.  Would be nice to have wider perfromance testing
> >   but I guess it'll be easy enough to undo.
> 
> Care to give it one more round through -mm? Is it easy enough to
> keep?

Yup.  Nobody has done much with that code in ages.

> I haven't had a chance to review it, which I'd like to do at some
> point (and I don't think it would hurt to have a bit more testing).

Sure.
