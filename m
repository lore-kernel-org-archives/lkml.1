Return-Path: <linux-kernel-owner+w=401wt.eu-S1763946AbYBLR5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763946AbYBLR5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761960AbYBLR5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:57:14 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:53289 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760262AbYBLR5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:57:11 -0500
Message-ID: <47B1DD17.2030204@panasas.com>
Date: Tue, 12 Feb 2008 19:53:27 +0200
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>	 <20080212044314.GA4888@kroah.com>	 <20080211211751.3e265754@laptopd505.fenrus.org>	 <20080211.221126.230471463.davem@davemloft.net>	 <47B1CB08.4020101@garzik.org>	 <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <1202838082.3137.54.camel@localhost.localdomain>
In-Reply-To: <1202838082.3137.54.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb. 12, 2008, 19:41 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Tue, 2008-02-12 at 09:09 -0800, Linus Torvalds wrote:
>>  (a) create a base tree with _just_ that fundamental infrastructure change,
>>      and make sure that base branch is so obviously good that there is no 
>>      question about merging it.
> 
> The problem is how do we use a?  Usually we need to track your -rc tree
> as our fixes go in ... some of which affect our development trees.
> 
> If we stick with (a) as the base, we don't get to pull in the fixes in
> your tree.  If we use your tree we have to pull in (a) creating n
> different merge points for the n different upstream trees..

IMHO, this base tree should typically be based off of linus' tree
and kept rebased on top of it.  This way you get the mainline fixes
through the integration base tree.

Benny

