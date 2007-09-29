Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbXI2Wxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbXI2Wxg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 18:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbXI2Wx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 18:53:29 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:42036 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbXI2Wx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 18:53:28 -0400
Date: Sat, 29 Sep 2007 15:51:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Brownell <david-b@pacbell.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       khali@linux-fr.org, akpm@linux-foundation.org
Subject: Re: [PATCH] CodingStyle: Printing numbers in parentheses is fine
Message-Id: <20070929155101.43079713.randy.dunlap@oracle.com>
In-Reply-To: <20070929223015.7F052236A50@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20070929122530.5c45f743@hyperion.delvare>
	<20070929035156.cd6fe860.akpm@linux-foundation.org>
	<20070929112928.56a04641.randy.dunlap@oracle.com>
	<20070929185306.183D72399D7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20070929131317.6a8609dc.randy.dunlap@oracle.com>
	<20070929223015.7F052236A50@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2007 15:30:15 -0700 David Brownell wrote:

> > > > Let's kill it, please.  (i.e., ACK)
> > > 
> > > But ... why?  What value could needless parens provide?
> >
> > Who says that needless parens could provide value?
> 
> Jean, which is why he submitted the patch.
> You, implicitly, by acking a patch saying those parens are bad.
> But not me ... I don't think this patch is merge-worthy.

Thanks for clearing that up.  Yes, you did have me confused.

Sure, if something is needless, it doesn't provide value.
So we disagree that some parens are needless.  OK.

> > > "Yet Another Subtle And Hard To Fix Source Of Bloat" is
> > > not a plus.
> >
> > ISTM that we agree.
> 
> Evidently not, since removing it would promote such bloat.
> Explicitly removing disapproval is a form of approval...
> 
> 
> > > I'd kind of think a change like this should have some
> > > positive motivation.
> >
> > "Me, I agree that numbers in parens don't usually make sense for
> > kernel messages."
> >
> > It's too trivial to be included in CodingStyle.
> 
> So the reason to remove that guideline, and thereby encourage
> proliferation of needless parens, is ... that some OTHER way
> to get rid of them is working?

Andrew listed some cases where parens make sense.  He didn't say
(and I don't say) [oops, parens] that they always make sense,
but the statement in CodingStyle is too strict.  Sometimes they
make sense.

> I would agree that line could be improved to say that messages
> should not be needlessly large.  Excess parens are one example;
> wordiness is another (including printing 8 bit fields as 0x%08x),
> and I'm sure there are more.

---
~Randy
