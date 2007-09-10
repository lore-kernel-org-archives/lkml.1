Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbXIJMoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbXIJMoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbXIJMoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:44:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52617 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340AbXIJMoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:44:10 -0400
Date: Mon, 10 Sep 2007 13:43:58 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       perex@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070910124358.GB21089@ftp.linux.org.uk>
References: <20070909202527.GT3563@stusta.de> <20070909203920.GA11764@infradead.org> <20070909145940.0b41c8a5.akpm@linux-foundation.org> <20070910090808.GA31204@infradead.org> <20070910022324.c69e1897.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910022324.c69e1897.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 02:23:24AM -0700, Andrew Morton wrote:
> > And I think almost everyone disagrees with you.  We just carry too much
> > crap around because of your subborness in this issue, and it gets really
> > annoying to have some high up on the food chain fighting his longly flight
> > against the other people.
> 
> I would like to see "everyone" explain what we lose by giving developers a
> bit of warning before we break their stuff.
> 
> 
> And it would need to be a good explanation, Christoph.  A measured one
> which recognises and then weighs the tradeoffs involved, and the costs.  An
> inebriated-sounding rant will not impress, sorry.

Fine, then.  Just how much of a warning is needed in this particular case?
Normally I'm the last one to support Adrian's exportectomy binges, but in
case of sys_open() it's _way_ overdue.  There had been warnings for quite
a while; moreover, fixing the breakage in any case that is not already
badly broken is going to take a few minutes.  People who had not found
spare ten minutes during the last few years have my sincere condolences,
but they bloody can do that when it hits the fan and I see no reason to
believe that a warning in build time or modprobe time would do more than
multiple warnings on maillists.
