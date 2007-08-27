Return-Path: <linux-kernel-owner+w=401wt.eu-S1758995AbXH0RQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995AbXH0RQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbXH0RQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:16:20 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:21531 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbXH0RQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:16:20 -0400
Subject: Re: Who wants to maintain KR list for stable releases? (was Re:
	nmi_watchdog=2 regression in 2.6.21)
From: Daniel Walker <dwalker@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <20070827094403.40b28836.akpm@linux-foundation.org>
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
	 <1187628296.7732.14.camel@imap.mvista.com>
	 <46CDE94A.7000600@googlemail.com>
	 <1187904169.2435.83.camel@dhcp193.mvista.com>
	 <46D21E8E.4000003@googlemail.com>
	 <20070827005131.b93f5935.akpm@linux-foundation.org>
	 <1188232008.2435.222.camel@dhcp193.mvista.com>
	 <20070827094403.40b28836.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 10:08:34 -0700
Message-Id: <1188234515.2435.243.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 09:44 -0700, Andrew Morton wrote:

> It's a hassle when someone doesn't have a bugzilla account.  But there are
> humans sitting behind bugzilla handling stuff (fsvo "human").  I've already
> forwarded your bugzilla report to Stephane pointing out that he doesn't
> have an account.
> 
> I screen 100% of new bugzilla reports and for those which I think need
> attention (most), I will ensure that the appropriate parties get to see the
> report.  I'll also verify that the "regression" state is correct and that
> the provided info is sufficient-looking.  (It's amazing how many people
> have trouble with the "Most recent kernel where this bug did not occur:"
> question).

When I read that question, it sort of feels like a mind bender. It's the
"did not occur" , most people are thinking "which version of the kernel
did I find this in", but it's asking the opposite ..

For bug #8945 I really don't recall the version of the kernel I ran when
it worked .. I had to do a bisect to get some clue about that ..
nmi_watchdog isn't something I use every time I boot (I should tho), and
I go through lots of kernels ..

> What I haven't been doing is ensuring that the Product and Component fields
> are suitably set.  That's something which Natalie is now cleaning up.

In terms of regressions, it would be nice for the "Version" field to be
the kernel where the regression first showed up .. Like on bug #8945 I
put in 2.6.22 even tho I found the issue in 2.6.23-rc1 .. Is that
typically what the "Version" field is used for?

Daniel

