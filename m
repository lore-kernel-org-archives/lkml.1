Return-Path: <linux-kernel-owner+w=401wt.eu-S932532AbXH0ScT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbXH0ScT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 14:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbXH0ScI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 14:32:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755686AbXH0ScG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 14:32:06 -0400
Date: Mon, 27 Aug 2007 11:26:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       =?ISO-8859-1?Q?Bj?= =?ISO-8859-1?Q?=F6rn?= Steinbrink 
	<B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: Who wants to maintain KR list for stable releases? (was Re:
 nmi_watchdog=2 regression in 2.6.21)
Message-Id: <20070827112607.aafdaee9.akpm@linux-foundation.org>
In-Reply-To: <1188234515.2435.243.camel@dhcp193.mvista.com>
References: <1186531609.22044.50.camel@imap.mvista.com>
	<20070808142059.GF30805@atjola.homenet>
	<1187628296.7732.14.camel@imap.mvista.com>
	<46CDE94A.7000600@googlemail.com>
	<1187904169.2435.83.camel@dhcp193.mvista.com>
	<46D21E8E.4000003@googlemail.com>
	<20070827005131.b93f5935.akpm@linux-foundation.org>
	<1188232008.2435.222.camel@dhcp193.mvista.com>
	<20070827094403.40b28836.akpm@linux-foundation.org>
	<1188234515.2435.243.camel@dhcp193.mvista.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 10:08:34 -0700
Daniel Walker <dwalker@mvista.com> wrote:

> On Mon, 2007-08-27 at 09:44 -0700, Andrew Morton wrote:
> 
> > It's a hassle when someone doesn't have a bugzilla account.  But there are
> > humans sitting behind bugzilla handling stuff (fsvo "human").  I've already
> > forwarded your bugzilla report to Stephane pointing out that he doesn't
> > have an account.
> > 
> > I screen 100% of new bugzilla reports and for those which I think need
> > attention (most), I will ensure that the appropriate parties get to see the
> > report.  I'll also verify that the "regression" state is correct and that
> > the provided info is sufficient-looking.  (It's amazing how many people
> > have trouble with the "Most recent kernel where this bug did not occur:"
> > question).
> 
> When I read that question, it sort of feels like a mind bender. It's the
> "did not occur" , most people are thinking "which version of the kernel
> did I find this in", but it's asking the opposite ..

We've already reworked that question once because poeple were mucking up
the answer.  Without a lot of success.

Maybe it should be "Is this bug a regression?  If so, what was the most
recent kernel which didn't have this bug?".  But that requires that people
know what "regression" means.

Bearing in mind that many reporters aren't native English speakers, I'm
really struggling to find a simple and robust way to ask this question.

Maybe "Did any previous kernel work OK?  If so, what was the most recent
version of the kernel which didn't have this bug?"

hrm.  It doesn't matter much, really.  When people muck it up (or just
fail to answer that question) I go back and ask them again.  It only
takes 30 seconds...

> For bug #8945 I really don't recall the version of the kernel I ran when
> it worked .. I had to do a bisect to get some clue about that ..
> nmi_watchdog isn't something I use every time I boot (I should tho), and
> I go through lots of kernels ..
> 
> > What I haven't been doing is ensuring that the Product and Component fields
> > are suitably set.  That's something which Natalie is now cleaning up.
> 
> In terms of regressions, it would be nice for the "Version" field to be
> the kernel where the regression first showed up .. Like on bug #8945 I
> put in 2.6.22 even tho I found the issue in 2.6.23-rc1 .. Is that
> typically what the "Version" field is used for?

Natalie is spending quite a bit of time with the bugzilla metadata,
queries, etc.  I'll shut up and let her tell us what changes we need in
this area.

