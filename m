Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbXKRSCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbXKRSCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 13:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXKRSCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 13:02:09 -0500
Received: from thunk.org ([69.25.196.29]:50971 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbXKRSCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 13:02:07 -0500
Date: Sun, 18 Nov 2007 13:01:10 -0500
From: Theodore Tso <tytso@mit.edu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Daniel Barkalow <barkalow@iabervon.org>,
       Romano Giannetti <romanol@upcomillas.es>,
       Benoit Boissinot <bboissin@gmail.com>, Mark Lord <liml@rtr.ca>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071118180110.GA7037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Adrian Bunk <bunk@kernel.org>,
	Daniel Barkalow <barkalow@iabervon.org>,
	Romano Giannetti <romanol@upcomillas.es>,
	Benoit Boissinot <bboissin@gmail.com>, Mark Lord <liml@rtr.ca>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Miller <davem@davemloft.net>, protasnb@gmail.com,
	linux-kernel@vger.kernel.org
References: <4739AFE0.20705@rtr.ca> <40f323d00711130752k19cab8eauc3456721274b3267@mail.gmail.com> <20071113171356.GA25824@thunk.org> <Pine.LNX.4.64.0711141810110.12193@iabervon.org> <20071115153057.GE17180@thunk.org> <Pine.LNX.4.64.0711151034340.12193@iabervon.org> <1195201202.13688.10.camel@localhost> <Pine.LNX.4.64.0711161303440.12193@iabervon.org> <20071116194617.GI11339@thunk.org> <20071117122010.GC4250@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071117122010.GC4250@stusta.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 01:20:10PM +0100, Adrian Bunk wrote:
> > But a bisect takes around 7 compiles.
> >...
> 
> I don't understand that number.
> 
> The common case are regressions in -rc1, and a bisection of
> at about 7000 commits takes around 13 compiles.

Worst case it would take 13.  In practice I've seen less.  Part of it
is I suspect that I'm starting with something more recent than the
previous 2.6.23, but rather a daily -git13 or -git14 tree.  Part of it
may be because git can sometimes be more efficient by cutting off
entire branches with trail builds, since git history isn't completely
linear, but rather pulls of various branches together.

	    	   	    	    - Ted
