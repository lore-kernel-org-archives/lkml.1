Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYCKVIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYCKVIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbYCKVH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:07:57 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:44463 "EHLO
	QMTA08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158AbYCKVH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:07:56 -0400
X-Authority-Analysis: v=1.0 c=1 a=w_3Tt_6PZGEA:10 a=6I5d2MoRAAAA:8
 a=g6u13gMq2JqFQw2tB7kA:9 a=1SGVHmNTQGVQ_JZAwmIA:7
 a=c2DFZaH4TijDx0o5EVQUSUdj2ScA:4 a=si9q_4b84H0A:10 a=LY0hPdMaydYA:10
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
From: Nicholas Miell <nmiell@comcast.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Molnar, Ingo" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200803111749.29143.nickpiggin@yahoo.com.au>
References: <200803111749.29143.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 14:07:54 -0700
Message-Id: <1205269674.12854.16.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-11 at 17:49 +1100, Nick Piggin wrote:

> So PostgreSQL performance profile is actually much more interesting.
> To my dismay, I found that Linux 2.6.25-rc5 performs really badly
> after saturating the runqueues and subsequently increasing threads.
> 2.6.22 drops a little bit, but basically settles near the peak
> performance. With 2.6.25-rc5, throughput seems to be falling off
> linearly with the number of threads.
> 

The FreeBSD folks have a whole host of benchmark results (MySQL,
PostgreSQL, BIND, NSD, ebizzy, SPECjbb, etc.) located at
http://people.freebsd.org/~kris/scaling/ that demonstrate that the
2.6.23+ scheduler is worse than the 2.6.22 scheduler and both are worse
than FreeBSD 7.

The interesting thing is that they've been running these tests
constantly for years now to demonstrate that their new scheduler hasn't
regressed compared to their old scheduler and as a benchmark against the
competition (i.e. Linux).

Does anybody even do this at all for Linux?

(Also, ignoring MySQL because it's a terrible piece of software at least
when regarding it's scalability is a bad idea. It's the M in LAMP, it
has a huge user base, and FreeBSD manages to outperform Linux with the
same unscalable piece of software.)

-- 
Nicholas Miell <nmiell@comcast.net>

