Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYFWHWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYFWHWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 03:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYFWHWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 03:22:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49173 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbYFWHWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 03:22:32 -0400
Date: Mon, 23 Jun 2008 03:22:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: [2.6.26-rc7] shrink_icache from pagefault locking (nee: nfsd
	hangs for a few sec)...
Message-ID: <20080623072227.GB11986@infradead.org>
References: <6278d2220806220256g674304ectb945c14e7e09fede@mail.gmail.com> <6278d2220806220258p28de00c1x615ad7b2f708e3f8@mail.gmail.com> <20080622221930.GA11558@disturbed> <20080623002415.GB21597@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623002415.GB21597@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 01:24:15AM +0100, Mel Gorman wrote:
> In that case, have you any theory as to why this circular dependency is
> being reported now but wasn't before 2.6.26-rc1? I'm beginning to wonder
> if the bisecting fingering the zonelist modifiation is just a
> co-incidence.

I've seen this traces since lockdep was added when running xfsqa.

