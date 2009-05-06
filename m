Return-Path: <linux-kernel-owner+w=401wt.eu-S1760304AbZEFQ7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304AbZEFQ7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZEFQ71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:59:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112AbZEFQ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:59:26 -0400
Date: Wed, 6 May 2009 09:48:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matt Mackall <mpm@selenic.com>
cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged
 processes
In-Reply-To: <20090506162543.GT31071@waste.org>
Message-ID: <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain>
References: <alpine.LFD.2.01.0905041159480.4983@localhost.localdomain> <20090504125124.0f469970@infradead.org> <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain> <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu>
 <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 May 2009, Matt Mackall wrote:

> On Wed, May 06, 2009 at 12:30:34PM +0200, Ingo Molnar wrote:
> > (Also, obviously "only" covering 95% of the Linux systems has its 
> > use as well. Most other architectures have their own cycle counters 
> > as well.)
> 
> X86 might be 95% of desktop. But it's a small fraction of Linux
> systems once you count cell phones, video players, TVs, cameras, GPS
> devices, cars, routers, etc. almost none of which are x86-based. In
> fact, just Linux cell phones (with about an 8% share of a 1.2billion
> devices per year market) dwarf Linux desktops (maybe 5% of a
> 200m/y market).

Matt, are you willing to ack my suggested patch which adds history to the 
mix? Did somebody test that? I have this memory of there being an 
"exploit" program to show the non-randomness of the values, but I can't 
recall details, and would really want to get a second opinion from 
somebody who cares about PRNG's.

			Linus
