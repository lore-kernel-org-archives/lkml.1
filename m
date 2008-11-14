Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbYKNRfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbYKNRfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYKNRe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:34:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYKNRe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:34:58 -0500
Date: Fri, 14 Nov 2008 12:34:22 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       Christoph Hellwig <hch@infradead.org>, Peter Cordes <peter@cordes.ca>,
       Bodo Eggert <7eggert@gmx.de>, David Newall <davidn@davidnewall.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 2.6.28?] don't unlink an active swapfile
Message-ID: <20081114173422.GA22868@infradead.org>
References: <bnJFK-3bu-7@gated-at.bofh.it> <bnR0A-4kq-1@gated-at.bofh.it> <E1KqkZK-0001HO-WF@be1.7eggert.dyndns.org> <Pine.LNX.4.64.0810171250410.22374@blonde.site> <20081018003117.GC26067@cordes.ca> <20081018051800.GO24654@1wt.eu> <Pine.LNX.4.64.0810182058120.7154@blonde.site> <20081018204948.GA22140@infradead.org> <20081018205647.GA29946@1wt.eu> <Pine.LNX.4.64.0811140234300.5027@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811140234300.5027@blonde.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 02:37:22AM +0000, Hugh Dickins wrote:
> Peter Cordes is sorry that he rm'ed his swapfiles while they were in use,
> he then had no pathname to swapoff.  It's a curious little oversight, but
> not one worth a lot of hackery.  Kudos to Willy Tarreau for turning this
> around from a discussion of synthetic pathnames to how to prevent unlink.
> Mimic immutable: prohibit unlinking an active swapfile in may_delete()
> (and don't worry my little head over the tiny race window).

Looks good (but I think I already said this before)

