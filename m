Return-Path: <linux-kernel-owner+w=401wt.eu-S1761297AbZEFU5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297AbZEFU5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759223AbZEFU4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:56:52 -0400
Received: from waste.org ([66.93.16.53]:47659 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756466AbZEFU4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:56:51 -0400
Date: Wed, 6 May 2009 15:52:43 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
Message-ID: <20090506205243.GC31071@waste.org>
References: <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain> <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <20090506202517.GA27544@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506202517.GA27544@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 10:25:17PM +0200, Ingo Molnar wrote:
> 
> * Matt Mackall <mpm@selenic.com> wrote:
> 
> > On Wed, May 06, 2009 at 12:30:34PM +0200, Ingo Molnar wrote:
> > > (Also, obviously "only" covering 95% of the Linux systems has its 
> > > use as well. Most other architectures have their own cycle counters 
> > > as well.)
> > 
> > X86 might be 95% of desktop. But it's a small fraction of Linux 
> > systems once you count cell phones, video players, TVs, cameras, 
> > GPS devices, cars, routers, etc. almost none of which are 
> > x86-based. In fact, just Linux cell phones (with about an 8% share 
> > of a 1.2billion devices per year market) dwarf Linux desktops 
> > (maybe 5% of a 200m/y market).
> 
> Firstly, the cycle counter is just one out of several layers there. 
> So it's a hyperbole to suggest that i'm somehow not caring about 
> architectures that dont have a cycle counter. I'm simply making use 
> of a cheaply accessed and fast-changing variable on hw that has it.

Whatever, I've never argued against TSC being beneficial. But it sure
as hell is not sufficient. Your original claim that this attack was
not possible in your original code: still bogus.
 
> Also, are those systems really going to be attacked locally, 
> brute-forcing a PRNG? 

Yes[1], even though my point was mostly to shoot down your bogus
statistic for reasons unrelated to this discussion. If you want to
make a new claim that '95% of Linux systems interesting to Ingo are
x86', I won't argue with that.

[1] 95% of security holes are caused by developer failures of imagination.
-- 
Mathematics is the supreme nostalgia of our time.
