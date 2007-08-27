Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbXH0HwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbXH0HwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 03:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbXH0HwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 03:52:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50837 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbXH0HwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 03:52:03 -0400
Date: Mon, 27 Aug 2007 00:51:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Daniel Walker <dwalker@mvista.com>,
       =?ISO-8859-1?B?Qmr2cm4=?= Steinbrink <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: Who wants to maintain KR list for stable releases? (was Re:
 nmi_watchdog=2 regression in 2.6.21)
Message-Id: <20070827005131.b93f5935.akpm@linux-foundation.org>
In-Reply-To: <46D21E8E.4000003@googlemail.com>
References: <1186531609.22044.50.camel@imap.mvista.com>
	<20070808142059.GF30805@atjola.homenet>
	<1187628296.7732.14.camel@imap.mvista.com>
	<46CDE94A.7000600@googlemail.com>
	<1187904169.2435.83.camel@dhcp193.mvista.com>
	<46D21E8E.4000003@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 02:45:02 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Daniel Walker pisze:
> [snip]
> > Have you considered maintaining all the lists in Bugzilla?
> 
> Yes, I have considered it.
> 
> Bugzilla sucks when it comes to tracking things. There is
> a regression field, but there are no difference between
> 2.6.22 and 2.6.23 regression.
> 
> Most people are reporting bugs through LKML:
> - 23 regressions with reference to LKML
> - 4 regressions with reference to Bugzilla

Presumably that's fixable.

But I think bugzilla is more appropriate for tracking longer-term bugs.  If
some problem has just popped up (or has just been discovered) then it's
best to try to knock it over with a quick email discussion.  If that
doesn't work out then the bug should be captured in bugzilla so that it
doesn't get lost.

The really important data which bugzilla will record are

a) the fact that the bug exists and

b) the identity of the person who can reproduce it and who will hopefully
work with us on fixing it.

> > If you had a
> > search of open bugs they would just fall of the list as they get
> > closed.. 
> 
> Unfortunately, the world is not perfect.
> 
> Is anyone interested in maintaining KR list for stable releases?

I'm not sure that we need one, really.  Any bugs in a stable release can be
handled via email and/or bugzilla as we are presently doing?

What I'm concerned about is that regressions which we didn't fix are just
getting lost.  Is anyone taking care to ensure that they are getting
transitioned into bugzilla for tracking?


