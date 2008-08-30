Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbYH3Npt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbYH3Npt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 09:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYH3Npl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 09:45:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33480 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbYH3Npl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 09:45:41 -0400
Date: Sat, 30 Aug 2008 09:45:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] utrace core
Message-ID: <20080830134537.GD17566@infradead.org>
References: <20080826220102.89635154233@magilla.localdomain> <20080826220157.397C7154233@magilla.localdomain> <20080826225519.GC27724@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826225519.GC27724@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 02:55:19AM +0400, Alexey Dobriyan wrote:
> On Tue, Aug 26, 2008 at 03:01:57PM -0700, Roland McGrath wrote:
> > This adds the utrace facility, a new modular interface in the kernel for
> > implementing user thread tracing and debugging.  This fits on top of the
> > tracehook_* layer, so the new code is well-isolated.
> 
> I'll says this again: tracehook_* is pointless abstraction because
> there will be no second generic tracing facility. The author of second
> one will be asked what is bad in utrace with very high odds.

Yes, I've also said this went the old monolithic utrace was first posted
(probably over a year ago) and it was conveniently ignored..

