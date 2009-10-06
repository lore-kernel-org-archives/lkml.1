Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbZJFTEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbZJFTEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 15:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758236AbZJFTEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 15:04:54 -0400
Received: from thunk.org ([69.25.196.29]:47148 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757817AbZJFTEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 15:04:54 -0400
Date: Tue, 6 Oct 2009 15:03:38 -0400
From: Theodore Tso <tytso@mit.edu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] kbuild: Improve version string logic
Message-ID: <20091006190338.GG24677@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Johannes Berg <johannes@sipsolutions.net>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu> <1254854227.22426.37.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254854227.22426.37.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 08:37:07PM +0200, Johannes Berg wrote:
> 
> I really don't see how it improves visibility (unless you're oblivious
> to the difference between long and short strings), but I do know that I
> have a few parsers that this will break.
> 
> I think adding the + unconditionally will also break things like
> debian's make-kpkg, for instance, since the + would get propagated into
> the package version which reserves the + for something else.
> 
> Etc. Can we please make this stuff optional?

That's exactly what I'm afraid of.  I'd really like to keep the long
version AUTOVERSION strings the same, please.

						- Ted
