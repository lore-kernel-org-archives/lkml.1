Return-Path: <linux-kernel-owner+w=401wt.eu-S1751852Ab0AQLIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab0AQLIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 06:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313Ab0AQLIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 06:08:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34061 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab0AQLIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 06:08:53 -0500
Date: Sun, 17 Jan 2010 06:08:47 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, davem@davemloft.net
Subject: Re: [PATCH] register MADV_HUGEPAGE
Message-ID: <20100117110847.GA32212@infradead.org>
References: <20100116184642.GA5687@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100116184642.GA5687@random.random>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 07:46:42PM +0100, Andrea Arcangeli wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> In order to allow early shipping transparent hugepage feature enabled
> only inside MADV_HUGEPAGE and not globally to diminish the risk of
> unexpected performance regressions on non-hypervisor related usages
> I'd need this little define registered. This is also to avoid things
> like this:

NACK, usespace ABIs only go in when features are added.  There's a more
than large enough chance that it will change for one reason or another.

And while transparent hugepages are a good feature to add, it's still in
a far to early stage to go on with it.

