Return-Path: <linux-kernel-owner+w=401wt.eu-S1763476AbYBMC0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763476AbYBMC0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbYBMCZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:25:57 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54679 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754268AbYBMCZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:25:56 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, jeff@garzik.org, arjan@infradead.org,
       greg@kroah.com, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080212.172051.58554658.davem@davemloft.net>
References: <47B1CB08.4020101@garzik.org>
	 <20080212.155853.193190548.davem@davemloft.net>
	 <alpine.LFD.1.00.0802121610220.2920@woody.linux-foundation.org>
	 <20080212.172051.58554658.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 20:25:50 -0600
Message-Id: <1202869550.3137.182.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 17:20 -0800, David Miller wrote:
> What would be really cool is if you could do the rebase thing, push
> that to a remote tree you were already pushing into and others could
> pull from that and all the right things happen.
> 
> A rebase is just a series of events, and those could propagate to
> people who are pulling from the tree.  I'm pretty sure GIT could
> support this.

Yes, this is exactly the feature I'm looking for.  It would allow the
downstream users of a rebased tree to rebase themselves correctly.

All the information about the rebase is in the reflog ... it can't be
too difficult to pass it through on a pull and allow the downstream tree
to do the right thing.

James


