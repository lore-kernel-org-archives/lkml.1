Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbYKWT46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbYKWT46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYKWT4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:56:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54984 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbYKWT4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:56:44 -0500
Date: Sun, 23 Nov 2008 14:56:42 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/4] trace: profile all if conditionals
In-Reply-To: <87iqqei5ys.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.1.10.0811231455090.13888@gandalf.stny.rr.com>
References: <20081121071213.365288293@goodmis.org> <20081121071328.462456268@goodmis.org> <87iqqei5ys.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 23 Nov 2008, Andi Kleen wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:

> > This adds a significant amount of overhead and should only be used
> > by those analyzing their system.
> 
> Often this can be also done using CPU performance counters. Might 
> be a cheaper option. 

I'd love to add an option that could hook into any arch with HW support 
for this. We could dump out the same information, but just a different way 
to gather it.  But I'm still ignorant to the use of CPU performance 
counters and how to find which branch matches which if.

-- Steve

