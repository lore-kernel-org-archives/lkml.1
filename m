Return-Path: <linux-kernel-owner+w=401wt.eu-S1765583AbYBNIUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765583AbYBNIUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 03:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYBNIUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 03:20:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56727 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbYBNIUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 03:20:36 -0500
Date: Thu, 14 Feb 2008 08:14:05 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-ID: <20080214081405.GA20791@flint.arm.linux.org.uk>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
	linux-arch@vger.kernel.org, Linus <torvalds@linux-foundation.org>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080212042133.GA4625@kroah.com> <20080211203146.3d28d1a0@laptopd505.fenrus.org> <1202791555.20739.6.camel@heimdal.trondhjem.org> <20080212051136.GA12802@mit.edu> <20080211221535.bc0dc9cf.akpm@linux-foundation.org> <20080212225716.cf695fe4.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212225716.cf695fe4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:57:16PM +1100, Stephen Rothwell wrote:
> We need to ask Linus to promise that he will pull the stable branch from
> linux-next first in the merge window.  For that to happen, I would expect
> that Linus would also review and sign off (or ack) these commits to the
> linux-next tree.

Changing the commits in git in anyway changes their ID, which has the
same effects as a rebase.

With this idea, Linus only has two choices:

1. pull the entire set of linux-next changes whether he likes them or not,
   because he's going to get them either from the linux-next tree or someone
   elses tree which is based upon that.

2. don't pull the changes, nor anyone elses tree if he hates the changes
   in linux-next.

So really, Linus needs to ack the changes _before_ they go into linux-next.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
