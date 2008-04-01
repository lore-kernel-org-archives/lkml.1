Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbYDAPa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbYDAPa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759933AbYDAPUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:20:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:56666 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759931AbYDAPUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:20:17 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+I2M1iMKiIWH7wIMOoY8dFyXDXNxsimqeXg3hJyK
	3thjiqkHME9vH+
Date: Tue, 1 Apr 2008 17:20:11 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] evdev: Release eventual input device grabs when
	getting disconnected
Message-ID: <20080401152011.GA3044@atjola.homenet>
References: <20080330184259.GB21375@atjola.homenet> <20080331190509.GA2876@atjola.homenet> <1207050678.5143.43.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1207050678.5143.43.camel@johannes.berg>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.04.01 13:51:18 +0200, Johannes Berg wrote:
> 
> On Mon, 2008-03-31 at 21:05 +0200, Björn Steinbrink wrote:
> > On 2008.03.30 20:42:59 +0200, Björn Steinbrink wrote:
> > > I can't reproduce the bug on my UP box and currently can't afford
> > > crashing my SMP box (all the oopses seem to come from SMP kernels, so I
> > > guess it needs SMP to crash), so while this doesn't show any new
> > > problems, I can't tell whether it actually fixes anything. Testers
> > > welcome!
> > 
> > Hm, crap, can't reproduce on my x86_64 SMP box either. Tried with
> > various preemption models as well as rcu classic and preempt. Johannes,
> > is there anything "special" in your configuration?
> 
> slab debugging turned on by default? without it, you'll most likely
> never notice.

I tried with slab+debugging, slub+debugging (SLUB_DEBUG_ON was set),
various preemption models, UP and SMP. No luck. I also wrote a test
program like yours to eliminate any effects caused by different X.org
versions, but it just doesn't want to crash :-/

Björn
