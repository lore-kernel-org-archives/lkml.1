Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbZASM71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbZASM71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbZASM7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:59:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39242 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759598AbZASM7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:59:05 -0500
Date: Mon, 19 Jan 2009 07:59:01 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace based hard lockup detector
In-Reply-To: <4973cff5.05a0660a.650c.2f54@mx.google.com>
Message-ID: <alpine.DEB.1.10.0901190757330.17050@gandalf.stny.rr.com>
References: <4973cff5.05a0660a.650c.2f54@mx.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 18 Jan 2009, Frederic Weisbecker wrote:

> Like the NMI watchdog, this feature try to detect hard lockups by
> lurking at the non-progress of the timer interrupts.
> 
> You can enable it at boot time by passing the ftrace_hardlockup parameter.
> I plan to add a debugfs file to enable/disable at runtime.
> 
> When a hardlockup is detected, it will print a backtrace. Perhaps it
> would be good to print the locks held from lockdep too?
> 
> It only support x86 for the moment, because a kind of generic timer interrupt
> counter is needed on all archs to have it generic.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Hi Frederic,

This seems like a rewrite of the NMI lockup code. In my debugging, I 
simply put ftrace_dump in the NMI lockup, which gives me a ftrace dump as 
soon as NMI detects a lockup. I'm a bit confused at what this gives us 
over that?

-- Steve
