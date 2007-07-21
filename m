Return-Path: <linux-kernel-owner+w=401wt.eu-S935786AbXGUGh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935786AbXGUGh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXGUGhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:37:13 -0400
Received: from il.qumranet.com ([82.166.9.18]:36816 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbXGUGhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:37:12 -0400
Message-ID: <46A1A993.202@qumranet.com>
Date: Sat, 21 Jul 2007 09:37:07 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
References: <1184970779.4012.38.camel@chaos>
In-Reply-To: <1184970779.4012.38.camel@chaos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Sat, 21 Jul 2007 09:37:07 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> We are pleased to announce a project we've been working on for some 
> time: the unified x86 architecture tree, or "arch/x86" - and we'd like 
> to solicit feedback about it.
>   

kvm will really like this.  while kvm will always have #ifdefs for i386
and x86_64, this work will reduce them, and will make kvm code cleaner. 
Of course, I also believe it makes sense from the non-kvm-centric point
of view.

Thanks for doing this!

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

