Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbZJGNyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbZJGNyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758596AbZJGNx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:53:59 -0400
Received: from thunk.org ([69.25.196.29]:34713 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758492AbZJGNx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:53:58 -0400
Date: Wed, 7 Oct 2009 09:52:33 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
Message-ID: <20091007135233.GK17883@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Airlie <airlied@gmail.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <1254864803.6035.25.camel@pasglop> <alpine.LFD.2.01.0910061513510.3432@localhost.localdomain> <21d7e9970910061822i429344amb47b0bceb552abc6@mail.gmail.com> <alpine.LFD.2.01.0910062015200.3432@localhost.localdomain> <alpine.LFD.2.01.0910062025300.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910062025300.3432@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 08:31:46PM -0700, Linus Torvalds wrote:
> 
> Btw, that doesn't mean that I'm married to the exact details of the syntax 
> etc. I like CONFIG_LOCALVERSION_AUTO, but I can also see why Ingo would 
> prefer a "+" there instead of a "-".
> 
> And the zero-padding to five digits of the number of commits may make 
> things line up nicely, and I think there was even some odd technical 
> reason for it too (some package manager or other that was unhappy with 
> "simple" numbers like "-1" and thought that they were a build number or 
> something), but it's admittedly silly too.

I really like CONFIG_LOCALVERSION_AUTO the way it is, and changing it
will break things.  It probably wouldn't be that hard to fix things,
although the fix probably would involve post-processing the version
number to bring it back to using '-' for all of the spearators, so
that '+' could be used for separating the packaging-specific version
details.

The one thing that I wish we *could* do is make
CONFIG_LOCALVERSION_AUTO mandatory, or at least making it the strong
default and forcing people to work to turn it off, since the problem
really is with users smart enough to use git, but not quite smart
enough to turn on CONFIG_LOCALVERSION_AUTO.

					- Ted
