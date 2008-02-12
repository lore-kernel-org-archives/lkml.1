Return-Path: <linux-kernel-owner+w=401wt.eu-S1764333AbYBLTlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764333AbYBLTlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764098AbYBLTli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:41:38 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52825 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbYBLTlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:41:36 -0500
Date: Tue, 12 Feb 2008 19:41:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212194100.GH27894@ZenIV.linux.org.uk>
References: <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <1202838082.3137.54.camel@localhost.localdomain> <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org> <1202840682.3137.83.camel@localhost.localdomain> <alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org> <alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:59:00AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 12 Feb 2008, Linus Torvalds wrote:
> > 
> > In other words, I'm perfectly happy to be an a*hole and tell people that I 
> > simply won't merge things that cause undue API churn at all, and that were 
> > not thought out sufficiently.
> 
> .. btw: I'd need to know this in advance. I usually don't see the problem 
> until it's too late.

We could simply decide that API changes affecting more than one subsystem
Must Be Serialized(tm).  Explicitly.  As in "any such change is posted
and discussed in advance, order of merges decided upon and we have merge
window for one decided set of API changes + fallout *ONLY*".  With merge
window in question normally taking a few days.
