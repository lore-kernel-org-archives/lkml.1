Return-Path: <linux-kernel-owner+w=401wt.eu-S1761991AbYBLRlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761991AbYBLRlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbYBLRlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:41:31 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53857 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754042AbYBLRla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:41:30 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>
	 <20080212044314.GA4888@kroah.com>
	 <20080211211751.3e265754@laptopd505.fenrus.org>
	 <20080211.221126.230471463.davem@davemloft.net>
	 <47B1CB08.4020101@garzik.org>
	 <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 11:41:22 -0600
Message-Id: <1202838082.3137.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 09:09 -0800, Linus Torvalds wrote:
>  (a) create a base tree with _just_ that fundamental infrastructure change,
>      and make sure that base branch is so obviously good that there is no 
>      question about merging it.

The problem is how do we use a?  Usually we need to track your -rc tree
as our fixes go in ... some of which affect our development trees.

If we stick with (a) as the base, we don't get to pull in the fixes in
your tree.  If we use your tree we have to pull in (a) creating n
different merge points for the n different upstream trees..

> (b) tell other people about the reason for the infrastructure change, and 
>      simply allow others to merge it. You don't have to wait for *me* to 
>      open the merge window, you need to make sure that the people that get 
>      impacted most can continue development!

Yes, this is effectively what I did with the post merge SCSI tree.
However, if you do this rebasing becomes a fact of life because you need
to rebase out all the dependencies you have before you merge (in fact,
it's a good way of checking whether your dependencies have been merged
yet or not, seeing what survives a rebase).

James


