Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbYFLSo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbYFLSo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 14:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbYFLSoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 14:44:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:34656 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbYFLSoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 14:44:16 -0400
Subject: Re: workqueue cpu affinity
From: Peter Zijlstra <peterz@infradead.org>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, mingo@elte.hu,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       menage@google.com, linux-kernel@vger.kernel.org,
       Mark Hounschell <dmarkh@cfl.rr.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4850214A.8090100@qualcomm.com>
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>
	 <20080605152953.dcfefa47.pj@sgi.com>
	 <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com>
	 <484D99AD.4000306@qualcomm.com> <1213080240.31518.5.camel@twins>
	 <484E9FE8.9040504@qualcomm.com>  <20080610170005.GA6038@tv-sign.ru>
	 <1213118386.19005.9.camel@lappy.programming.kicks-ass.net>
	 <484EE303.9070007@qualcomm.com> <1213166964.31518.62.camel@twins>
	 <4850214A.8090100@qualcomm.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 20:44:00 +0200
Message-Id: <1213296240.31518.163.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for being late,.. and I'm afraid most will have to wait a bit
longer :-(

On Wed, 2008-06-11 at 12:02 -0700, Max Krasnyansky wrote:
> Peter Zijlstra wrote:

> > Please don't take this too personal - I'm glad you're working on this.
> > I'm just trying to see what we can generalize.

> Oh, no worries, I'm not taking this personally, except maybe the "most your
> ideas suck" part which got me a little bit ;-). I'm definitely all for making
> it suitable for more general usage.
> This is actually first constructive criticism (except for the "most of your
> ideas suck" part :). 

No, no, you understand me wrong (or I expressed myself wrong). Your
ideas are good, its just the implementation / execution I have issues
with.

Like with extending the isolation map, what didn't leave any room for
hard-rt smp schedulers or multiple rt domains. Whereas the cpuset stuff
does.



