Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbXDWRkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbXDWRkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 13:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbXDWRkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 13:40:46 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076AbXDWRkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 13:40:45 -0400
Date: Mon, 23 Apr 2007 10:40:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Hopper <hopper@omnifarious.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
Message-Id: <20070423104042.87b50bb3.akpm@linux-foundation.org>
In-Reply-To: <20070423135216.GA2744@omnifarious.org>
References: <20070423020046.GA28477@omnifarious.org>
	<462C2E5B.1080008@redhat.com>
	<Pine.LNX.4.64.0704230353000.25153@server.thyself>
	<462C4858.3050006@redhat.com>
	<Pine.LNX.4.64.0704230555020.25153@server.thyself>
	<462C4D32.4000909@redhat.com>
	<Pine.LNX.4.64.0704230611430.25153@server.thyself>
	<462C5034.9090403@redhat.com>
	<Pine.LNX.4.64.0704230640540.25153@server.thyself>
	<20070423010445.454eda63.akpm@linux-foundation.org>
	<20070423135216.GA2744@omnifarious.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 06:52:16 -0700
Eric Hopper <hopper@omnifarious.org> wrote:

> On Mon, Apr 23, 2007 at 01:04:45AM -0700, Andrew Morton wrote:
> > The namesys engineers continue to maintain reiser4 and I continue to
> > receive patches for it.
> > 
> > Right now I'd say that the main blockages for reiser4 are a) the developers
> > aren't presently asking for inclusion (afaik) and b) lack of reviewing
> > effort from other kernel developers.  
> 
> If someone else started asking for it to be included and responded to
> requests for the various code changes required to increase its quality
> to the required level, wouldn't that be enough?  Basically, if someone
> forked it.
> 
> Or does it specifically have to be namesys engineers?

That's not where the problem lies - the namesys guys are responsive and play
well with others.  But they haven't received any "requests for the various code
changes" in over a year.

And I'm in the same boat as most everyone else: I haven't looked at the reiser4
code in ages.  Right now I don't have anything like a list of outstanding
technical issues.

To get it unstuck we'd need a general push, get people looking at and testing
the code, get the vendors to have a serious think about it, etc.  We could do
that - it'd require that the namesys people (and I) start making threatening
noises about merging it, I guess.

Or we could move all the reiser4 code into kernel/sched.c - that seems to get
people fired up.
