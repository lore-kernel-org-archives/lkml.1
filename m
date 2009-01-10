Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbZAJGsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbZAJGsk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 01:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZAJGs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 01:48:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45053 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZAJGs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 01:48:28 -0500
Message-ID: <496843D7.4070900@zytor.com>
Date: Fri, 09 Jan 2009 22:44:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
References: <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu>
In-Reply-To: <20090110010125.GA31031@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
>  - Headers could probably go back to 'extern inline' again. At not small 
>    expense - we just finished moving to 'static inline'. We'd need to 
>    guarantee a library instantiation for every header include file - this 
>    is an additional mechanism with additional introduction complexities 
>    and an ongoing maintenance cost.
> 

I think I have a pretty clean idea for how to do this.  I'm going to
experiment with it over the next few days.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

