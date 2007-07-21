Return-Path: <linux-kernel-owner+w=401wt.eu-S937927AbXGULg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937927AbXGULg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 07:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933235AbXGULgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 07:36:06 -0400
Received: from quark.didntduck.org ([69.55.226.66]:42695 "EHLO
	quark.didntduck.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761853AbXGULgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 07:36:01 -0400
Message-ID: <46A1EF57.2020304@didntduck.org>
Date: Sat, 21 Jul 2007 07:34:47 -0400
From: Brian Gerst <bgerst@didntduck.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
References: <1184970779.4012.38.camel@chaos> <200707210737.59552.ak@suse.de> <1185005750.4012.100.camel@chaos>
In-Reply-To: <1185005750.4012.100.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sat, 2007-07-21 at 07:37 +0200, Andi Kleen wrote: 
>> On Saturday 21 July 2007 00:32, Thomas Gleixner wrote:
>>> As an initial matter, we made it painstakingly sure that the resulting
>>> .o files in a 32-bit build are bit for bit equal.
>> You got not a single line less code duplication then, so i don't really
>> see the point of this.
> 
> Really ? 
> 
> The script detected 15 identical files with a simple cmp.
> 
> It also unified another 10 by simply looking at the only line in there
> "include <the other arch/file>"
> 
> And there is more of that, when you take the time and look closely at
> the _32.[ch] _64.[ch] files which are created by the merge.

Looking at the include files, many more are near-identical in trivial
ways, such as whitespace, comments, local variable names, or guard #ifdefs.

--
				Brian Gerst
