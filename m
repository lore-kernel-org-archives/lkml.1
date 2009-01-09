Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZAIRIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZAIRIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 12:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbZAIRIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 12:08:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33397 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZAIRID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 12:08:03 -0500
Date: Fri, 9 Jan 2009 12:07:59 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Dirk Hohndel <hohndel@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       jim owens <jowens@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
In-Reply-To: <49678095.2030803@zytor.com>
Message-ID: <alpine.DEB.1.10.0901091206460.17378@gandalf.stny.rr.com>
References: <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
 <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com>
 <20090109084620.3c711aad@infradead.org> <49678095.2030803@zytor.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 9 Jan 2009, H. Peter Anvin wrote:

> Dirk Hohndel wrote:
> > 
> > Does gcc actually follow the "promise"? If that's the case (and if it's
> > considered a bug when it doesn't), then we can get what Linus wants by
> > annotating EVERY function with either __always_inline or noinline.
> > 
> 
> __always_inline and noinline does work.

I vote for the, get rid of the current inline, rename __always_inline to 
inline, and then remove all non needed inlines from the kernel.

We'll, probably start adding a lot more noinlines.

-- Steve

