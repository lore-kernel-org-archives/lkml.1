Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbZALPXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbZALPXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZALPXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:23:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:34871 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752493AbZALPXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:23:11 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+eV8xT69ied/pE7CfTatUJlH3fVCKGNu3ssSQKRU
	TdVUpqUv1zfwvl
Subject: Re: [BUG] How to get real-time priority using idle priority
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Brian Rogers <brian@xyzw.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090112131406.GB670@elte.hu>
References: <4969D0D7.2060401@xyzw.org>
	 <1231736941.6003.7.camel@marge.simson.net>
	 <1231765433.5789.35.camel@marge.simson.net>  <20090112131406.GB670@elte.hu>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 16:23:06 +0100
Message-Id: <1231773786.10060.0.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 14:14 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > > I haven't been able to reproduce complete hangs, but with your proggy 
> > > adapted to my quad, _and_ the addition of a SCHED_NORMAL hog, I can 
> > > reproduce some very bad interactivity, including massive character 
> > > repeats while attempting to type, and general "lurchiness" (_bad_ 
> > > wakeup latency).  I'll poke it with a sharp stick or two.
> > 
> > Would you mind trying the below?
> 
> i've applied your fix to tip/sched/urgent and merged it into tip/master.

BTW, I forgot the Reported-by: Brian Rogers <brian@xyzw.org> :-/

