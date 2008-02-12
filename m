Return-Path: <linux-kernel-owner+w=401wt.eu-S1762432AbYBLRjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762432AbYBLRjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:39:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759200AbYBLRiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:38:55 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:31004 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbYBLRiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:38:52 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
X-Message-Flag: Warning: May contain useful information
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>
	<20080212044314.GA4888@kroah.com>
	<20080211211751.3e265754@laptopd505.fenrus.org>
	<20080211.221126.230471463.davem@davemloft.net>
	<47B1CB08.4020101@garzik.org>
	<alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 12 Feb 2008 09:38:40 -0800
In-Reply-To: <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> (Linus Torvalds's message of "Tue, 12 Feb 2008 09:09:34 -0800 (PST)")
Message-ID: <adar6fivzvj.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Feb 2008 17:38:42.0828 (UTC) FILETIME=[1C5E94C0:01C86D9E]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > The other is that once somebody says "ok, I *really* need to cause this 
 > breakage, because there's a major bug or we need it for fundamental reason 
 > XYZ", then that person should
 > 
 >  (a) create a base tree with _just_ that fundamental infrastructure change,
 >      and make sure that base branch is so obviously good that there is no 
 >      question about merging it.

I don't disagree with this, but I think I should point out that making
something "obviously good" may be pretty hard.  It's clearly a common
case that the infrastructure change goes through several rounds of
change -- perhaps prompted by exposure in -mm that shows a subtle
issue.  So then if all other maintainers based their trees on this
tree, we're left with two not-so-great alternatives:

 1) merge the original, broken infrastructure change into your
    (Linus's) tree, leaving a known problem for bisecters to trip
    over.

 2) rebase the world.

I don't know if there's really a perfect answer here.  I hope that
tree-wide infrastructure breakage is uncommon enough that we can just
handle these issues "by hand" as they come up.

 - R.
