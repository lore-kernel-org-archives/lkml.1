Return-Path: <linux-kernel-owner+w=401wt.eu-S965527AbXCLK5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965527AbXCLK5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965533AbXCLK5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:57:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:60316 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965527AbXCLK5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:57:13 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Iz+9w0qqIG1Jdm1r1rMQSEqRzo2M5ZNR4E+/Te3
	K1HU/xkxDZkdak
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703122127.41942.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <200703122022.43021.kernel@kolivas.org>
	 <1173692286.20540.12.camel@Homer.simpson.net>
	 <200703122127.41942.kernel@kolivas.org>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 11:57:04 +0100
Message-Id: <1173697024.8014.19.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 21:27 +1100, Con Kolivas wrote:
> On Monday 12 March 2007 20:38, Mike Galbraith wrote:
> > 
> Now I think you're getting carried away because of your expectations from the 
> previous scheduler and its woefully unfair treatment towards interactive 
> tasks. Look at how you're loading up your poor P4 even with HT. You throw 2 
> cpu hogs only gently niced at it on top of your interactive tasks. If you're 
> happy to nice them +5, why not more? And you know as well as anyone that the 
> 2nd logical core only gives you ~25% more cpu power overall so you're asking 
> too much of it. Let's not even talk about how lovely this will (not) be once 
> SMT nice gets killed off come 2.6.21 and nice does less if "buyer beware" you 
> chose to enable HT in your own words.

The test scenario was one any desktop user might do with every
expectation responsiveness of the interactive application remain intact.
I understand the concepts here Con, and I'm not knocking your scheduler.
I find it to be a step forward on the one hand, but a step backward on
the other.

Tossing in the SMT nice comment was utter bullshit.  All kernels tested
were missing SMT nice.

> > When I looked into keeping interactive tasks responsive, I came to the
> > conclusion that I just couldn't get there from here across the full
> > spectrum of cpu usage without a scheduler hint.  Interactive feel is
> > absolutely dependent upon unfairness in many cases, and targeting that
> > unfairness gets it right where heuristics sometimes can't.
> 
> See above. Your expectations of what you should be able to do are simply 
> skewed. Find what cpu balance you loved in the old one (and I believe it 
> wasn't that much more cpu in favour of X if I recall correctly) and simply 
> change the nice setting on your lame encoder - since you're already setting 
> one anyway.
> 
> We simply cannot continue arguing that we should dish out unfairness in any 
> manner any more. It will always come back and bite us where we don't want it.

Unless you target accurately.

> We are getting good interactive response with a fair scheduler yet you seem 
> intent on overloading it to find fault with it.

I'm not trying to find fault, I'm TESTING AND REPORTING.  Was.

	bye,

	-Mike

