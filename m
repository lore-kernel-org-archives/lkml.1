Return-Path: <linux-kernel-owner+w=401wt.eu-S965885AbXCLOew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965885AbXCLOew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965890AbXCLOew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:34:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:42620 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965885AbXCLOev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:34:51 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18c7adDPDMcKeFUn7pDvtMTDorhZUWuQ1KHHqgiTI
	OfzrHi80d1tIFq
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703122223.07048.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <1173697024.8014.19.camel@Homer.simpson.net>
	 <20070312110833.GA12835@elte.hu>  <200703122223.07048.kernel@kolivas.org>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 15:34:42 +0100
Message-Id: <1173710082.6326.49.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 22:23 +1100, Con Kolivas wrote:

> Mike the cpu is being proportioned out perfectly according to fairness as I 
> mentioned in the prior email, yet X is getting the lower latency scheduling. 
> I'm not sure within the bounds of fairness what more would you have happen to 
> your liking with this test case?

It has been said that "perfection is the enemy of good".  The two
interactive tasks receiving 40% cpu while two niced background jobs
receive 60% may well be perfect, but it's damn sure not good.

	-Mike

