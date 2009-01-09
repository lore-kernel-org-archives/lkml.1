Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZAIODc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZAIODc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 09:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbZAIODU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 09:03:20 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:1138 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbZAIODT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 09:03:19 -0500
Message-ID: <49675920.4050205@hp.com>
Date: Fri, 09 Jan 2009 09:03:12 -0500
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
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
References: <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain> <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu>
In-Reply-To: <20090109130057.GA31845@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> One interpretation of the numbers would be that core kernel hackers are 
> more inline-happy, maybe because they think that their functions are more 
> important to inline.
> 
> Which is generally a fair initial assumption, but according to the numbers 
> it does not appear to pay off in practice as it does not result in a 
> smaller kernel image.

I think people over-use inline for the opposite reason.

They are taught:
    - use inline functions instead of macros
    - inlining functions makes your code run faster

They also know inlining may increase program object size.
That inlining will reduce object size on many architectures
if the function is small is just a happy side effect to them.

jim
