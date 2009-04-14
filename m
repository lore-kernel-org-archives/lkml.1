Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbZDNHBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbZDNHBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZDNHBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:01:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbZDNHBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:01:37 -0400
Date: Tue, 14 Apr 2009 09:01:35 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "yinghan@google.com" <yinghan@google.com>
Subject: Re: [PATCH] readahead: enforce full sync mmap readahead size
Message-ID: <20090414070135.GA23528@wotan.suse.de>
References: <20090410060957.442203404@intel.com> <20090410061254.719205499@intel.com> <20090410163413.a014bde0.akpm@linux-foundation.org> <20090412070943.GB5737@localhost> <alpine.LFD.2.00.0904120808040.4583@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904120808040.4583@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 12, 2009 at 08:15:12AM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 12 Apr 2009, Wu Fengguang wrote:
> >
> > Now that we do readahead for sequential mmap reads, here is
> > a simple evaluation of the impacts, and one further optimization.
> 
> Hmm.
> 
> Wu, I just went through your latest (?) series of 1-9 and they all looked 
> (a) quite small and (b) all of them looked like good cleanups. 
> 
> And not only do they look good, you seem to have numbers to back it all up 
> too.

They look pretty good to me too.

 
> In other words, I'd really prefer to merge this sooner rather than later. 
> There just doesn't seem to be any reason _not_ to. Is there any reason to 
> not just take this? I realize that it's past -rc1, but this is way smaller 
> and saner-looking than the average patch that makes it in past -rc1.
> 
> Besides, it was originally posted before -rc1, and the last series didn't 
> have the much more intrusive page-fault-retry patches. I'd leave those for 
> the next merge window, but the read-ahead series (1-9 plus this final 
> one-liner) seem to be pure improvement - both in code readability _and_ in 
> numbers - with no real contentious issues.
> 
> No?

I guess untested code, especially with heuristics, can always cause non
intuitive problems for some people. So the other side of the argument
is what's the harm in putting them in -mm until next merge window?

That said, I like these kinds of things, so I don't object :)

