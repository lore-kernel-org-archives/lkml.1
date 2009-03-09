Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbZCIQSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbZCIQSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZCIQSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:18:14 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:56899 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbZCIQSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:18:13 -0400
From: Frans Pop <elendil@planet.nl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG,2.6.29-rc7,s390] System goes into endless loop during boot or logon
Date: Mon, 9 Mar 2009 17:18:08 +0100
User-Agent: KMail/1.9.9
Cc: linux-s390@vger.kernel.org,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903080835.14032.elendil@planet.nl> <200903091643.13803.elendil@planet.nl> <1236613902.8389.675.camel@laptop>
In-Reply-To: <1236613902.8389.675.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903091718.10045.elendil@planet.nl>
X-OriginalArrivalTime: 09 Mar 2009 16:18:10.0472 (UTC) FILETIME=[A393D280:01C9A0D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 March 2009, Peter Zijlstra wrote:
> > Hmmm. Your commit log message for
> > ca109491f612aab5c8152207631c0444f63da97f does explicitly mention the
> > risk of an infinite loop, as does a comment in
> > hrtimer_enqueue_reprogram().
> >
> > Any chance the cause is there? Any way to test for that?
>
> a6037b61c2f5fc99c57c15b26d7cfa58bbb34008 should have fixed the
> mentioned issue (along with the deadlock mentioned in the changelog).

OK. Thanks for explaining.

> Doesn't this s390 thing have a sysrq key you can press to get some
> traces out?

As mentioned in my first reply this morning, AFAIK I have no way to 
trigger the kernel's sysrq function.

The emulator does have an option to trace what's running on it. The 
problem is that I have no idea myself how to translate that output to 
what the kernel is doing, nor what would be needed to be able to do such 
a translation. If someone else does know how to use it, I'd be happy to 
provide the info.

Note that the last few days I've been tracing two other issues that 
appeared since 2.6.26 in the same environment, both of which are timing 
related. See:
- http://lkml.org/lkml/2009/3/9/112
  which fixes http://marc.info/?t=123629272600002&r=1&w=2
- http://lkml.org/lkml/2009/3/9/166

Hope that helps,
FJP
