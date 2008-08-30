Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbYH3NlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbYH3NlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 09:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbYH3NlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 09:41:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56102 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYH3NlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 09:41:04 -0400
Date: Sat, 30 Aug 2008 09:40:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] utrace
Message-ID: <20080830134057.GB17566@infradead.org>
References: <20080826220102.89635154233@magilla.localdomain> <20080826223402.GB27724@x200.localdomain> <y0m7ia3xqev.fsf@ton.toronto.redhat.com> <20080827135453.GA31240@infradead.org> <20080827164055.GA22236@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080827164055.GA22236@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 10:10:55PM +0530, Ananth N Mavinakayanahalli wrote:
> Uprobes is just one user of utrace. It is intended for use for simple
> tracing where we need a kernel+userspace look at the problem at hand.
> The intention is for use in simple cases (when condition x is met, what
> is the value of variable y, etc).
> 
> For more advanced tracing though, there are other ideas being proposed
> (see ntrace discussions on utrace-devel, but I guess now lkml is the
> right place for that discussion too).
> 
> However, there are components of uprobes such as breakpoint
> insertion/removal and single-stepping infrastructure that are
> potentially useful to other userspace debuggers. We are working on
> factoring those out to live independent of uprobes. You should be seeing
> those patches soon.

I hope my original mail was clear that I'm not principially against
utrace.  I think having a generic trace even dispatcher is a good thing
if it is a) not overly complicated (see Alexeyús mails for that) and b)
actually has a user.  A better debugger interface as the ntrace idea
would be the prime candidate for that.
