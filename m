Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbZAKRve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbZAKRve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 12:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZAKRvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 12:51:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57481 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbZAKRvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 12:51:22 -0500
Date: Sun, 11 Jan 2009 19:05:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Snitzer <snitzer@gmail.com>, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       jim owens <jowens@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, sam@ravnborg.org,
       Dave Anderson <anderson@redhat.com>
Subject: Re: source line numbers with x86_64 modules? [Was: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact]
Message-ID: <20090111180545.GL26290@one.firstfloor.org>
References: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com> <20090110153446.GA13976@elte.hu> <170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com> <20090111012811.GG12885@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111012811.GG12885@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 'kdump light' perhaps that dumps the most important data structures like 
> registers of all CPUs, task struct and the symbol tables, the current task 
> itself including the kernel stack plus the surrounding 4K of all pointers 
> that are in current registers and that point into kernel memory - maybe 
> straight to kerneloops.org [if the user agrees] - or something like that.

All you would need for that would be a new custom level in makedumpfile
that dumps only this data (except that for live dumps it can be difficult to get 
the full register contents) No kernel changes needed.

-Andi
-- 
ak@linux.intel.com
