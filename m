Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbZAIUav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbZAIUav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854AbZAIUaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:30:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173AbZAIUaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:30:16 -0500
Date: Fri, 9 Jan 2009 12:29:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nicholas Miell <nmiell@comcast.net>
cc: Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Mason <chris.mason@oracle.com>,
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
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
In-Reply-To: <1231532276.2081.12.camel@entropy>
Message-ID: <alpine.LFD.2.00.0901091227040.6528@localhost.localdomain>
References: <20090108141808.GC11629@elte.hu>  <1231426014.11687.456.camel@twins>  <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>  <1231434515.14304.27.camel@think.oraclecorp.com>  <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> 
 <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com>  <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain>  <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com>  <20090109153508.GA4671@elte.hu>  <alpine.LFD.2.00.0901090817470.6528@localhost.localdomain>
 <1231532276.2081.12.camel@entropy>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Nicholas Miell wrote:
> 
> Maybe the kernel's backtrace code should be fixed instead of blaming
> gcc.

And maybe people who don't know what they are talking about shouldn't 
speak?

You just loaded the whole f*cking debug info just to do that exact 
analysis. Guess how big it is for the kernel?

Did you even read this discussion? Did you see my comments about why 
kernel backtrace debugging is different from regular user mode debugging?

			Linus
