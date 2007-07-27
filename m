Return-Path: <linux-kernel-owner+w=401wt.eu-S1762329AbXG0SNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762329AbXG0SNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbXG0SNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:13:41 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58984 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbXG0SNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:13:40 -0400
Date: Fri, 27 Jul 2007 11:11:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <ak@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Message-ID: <20070727181157.GI3672@sequoia.sous-sol.org>
References: <1184970779.4012.38.camel@chaos> <200707210740.19227.ak@suse.de> <Pine.LNX.4.58.0707210147340.29129@gandalf.stny.rr.com> <200707210806.12880.ak@suse.de> <20070727105034.GB11895@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070727105034.GB11895@ucw.cz>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek (pavel@ucw.cz) wrote:
> I believe there's still a lot that can be merged, and I'm responsible
> for some of it. Parts of suspend code should be shared, yet they are
> in differently named files in differently named directories.
> 
> Ok, I guess I should fix it, arch/x86 or not.

Funny, I was just looking at that code specifically.  Yes, it would be
useful to share.  It will need some wrappers for the asm which are now
paravirt on i386 and still raw on x86_64 (have those handy if you need
them).

thanks,
-chris
