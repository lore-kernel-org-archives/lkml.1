Return-Path: <linux-kernel-owner+w=401wt.eu-S933220AbXGTXFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbXGTXFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbXGTXE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:04:56 -0400
Received: from [192.102.209.1] ([192.102.209.1]:46823 "EHLO
	laptopd505.fenrus.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752715AbXGTXEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:04:55 -0400
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
From: Arjan van de Ven <arjan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1184970779.4012.38.camel@chaos>
References: <1184970779.4012.38.camel@chaos>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Jul 2007 16:01:39 -0700
Message-Id: <1184972499.2692.9.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 00:32 +0200, Thomas Gleixner wrote:
> We are pleased to announce a project we've been working on for some 
> time: the unified x86 architecture tree, or "arch/x86" - and we'd like 
> to solicit feedback about it.



I really like the idea of a unified source tree for the 2 x86 variants.
The technical differences are really small (of course there are
differences, especially in the boot sequence), and striving to unify as
much as possible while having a clean way to do per 32/64 bit parts as
well is something that imo is the right thing.

I'm more than happy to help with this effort, and have people in my
group at Intel help test and engineer this as well.

The technical approach of first moving (in an automated way) everything
into one directory, and then merge pieces one by one is appealing since
it can be done incrementally and carefully, while testing the "can we do
separate bits" from the start.

So in short, way to go, I hope we can get this thing done as soon as
possible. Heck it looks like the infrastructure (not the unification)
can make it into 2.6.23 merge window still, so that the entire 2.6.23
window can be used to develop merged-functionality pieces...

Greetings,
    Arjan van de Ven


