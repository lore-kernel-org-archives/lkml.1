Return-Path: <linux-kernel-owner+w=401wt.eu-S1759116AbZASGW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116AbZASGW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 01:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758210AbZASGWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 01:22:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:52295 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051AbZASGWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 01:22:15 -0500
Date: Mon, 19 Jan 2009 07:22:12 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Bernd Schmidt <bernds_cb1@t-online.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Message-ID: <20090119062212.GC22584@wotan.suse.de>
References: <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org> <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain> <496BBE27.2020206@t-online.de> <20090119001345.GA9880@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119001345.GA9880@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 01:13:45AM +0100, Ingo Molnar wrote:
> 
> * Bernd Schmidt <bernds_cb1@t-online.de> wrote:
> 
> > Linus Torvalds wrote:
> > > But you'll need some background to it:
> > 
> > You paint a somewhat one-sided picture bordering on FUD.
> 
> Type based aliasing should at most have been an opt-in for code that 
> cares, not a turned-on-by-default feature for everyone.

I want to know what is the problem with the restrict keyword?
I'm sure I've read Linus ranting about how bad it is in the
past... it seems like a nice opt-in thing that can be used where
the aliases are verified and the code is particularly performance
critical...

