Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbZDEUGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbZDEUGw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 16:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbZDEUGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 16:06:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754625AbZDEUGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 16:06:42 -0400
Date: Sun, 5 Apr 2009 13:02:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [GIT PULL] SLAB include file dependency fixes + kmemtrace
 updates
In-Reply-To: <alpine.LFD.2.00.0904051251390.4023@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904051257190.4023@localhost.localdomain>
References: <20090405193944.GA12691@elte.hu> <alpine.LFD.2.00.0904051251390.4023@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Apr 2009, Linus Torvalds wrote:
> 
> so rebase isn't bad, it's often a great way to fix things as you go along. 
> It just goes with a few basic caveats.

Btw, rebasing gets a really bad name exactly because when those rules are 
violated, it ends up being _really_ painful and almost impossible for 
people to work together because the end result just ends up being some 
kind of patch-queue thing, and that just doesnt' work once the number of 
queue entries reach a certain pain threshold.

And it's happened in ACPI, DRI, ALSA, x86, etc, so those few basic caveats 
are easy to violate and then have everybody hate you. 'git rebase' is very 
useful (especially with '-i'), but it's really a dangerous tool in that it 
can really wreak havoc too.

			Linus
