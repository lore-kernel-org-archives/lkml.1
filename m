Return-Path: <linux-kernel-owner+w=401wt.eu-S1760390AbYB2REw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390AbYB2REw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYB2REg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:04:36 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317AbYB2REe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:04:34 -0500
Date: Fri, 29 Feb 2008 09:03:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 ia32 syscall restart fix
In-Reply-To: <20080229164510.GA6850@elte.hu>
Message-ID: <alpine.LFD.1.00.0802290855230.17889@woody.linux-foundation.org>
References: <20080229035707.EAE862700FD@magilla.localdomain> <20080229155207.GC27248@elte.hu> <alpine.LFD.1.00.0802290814320.17889@woody.linux-foundation.org> <20080229164510.GA6850@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Ingo Molnar wrote:
> 
> currently the reality is that i have to fix over 90% of the commit 
> messages that go towards you :-/

Heh, yeah. My percentage ends up being much lower, mostly because patches 
that come through Andrew are generally already cleaned-up (I edit those 
too, but it tends to be one or two per batch, not more than that).

I'm happy you do edit them, because not everybody does, and I do think 
it's part of being a subsystem maintainer, but I also end up occasionally 
sending emails to the parties involved to try to keep editing to a mimumum 
in the future - I personally suspect that it's to a large degree because 
people don't think about the effect in the logs..

(Some other projects also tend to have very different models for what a 
commit message should look like, so much of it is probably "cultural" too. 

I've seen projects that consistently had totally unreadable one-liner 
commit messages because (a) nobody ever read them anyway (because the log 
just isn't useful when it's per-file) and (b) people were encouraged to 
just use things like 'cvs ci -m"Fix bug"' to check in their stuff.

So the kernel is probably fairly odd in generally not asking for any 
fixed-format stuff at all (like the GNU changelogs do) but instead writing 
a small human-readable novella ;)

			Linus
