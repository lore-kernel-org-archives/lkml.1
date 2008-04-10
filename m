Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbYDJR6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbYDJR6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbYDJR5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:57:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42247 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718AbYDJR5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:57:53 -0400
Message-ID: <47FE53E2.5070204@zytor.com>
Date: Thu, 10 Apr 2008 10:52:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com> <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com> <87wsn6m6zt.fsf@basil.nowhere.org> <20080410094637.GW17915@shadowen.org> <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com> <20080410144114.GH10019@one.firstfloor.org> <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org> <20080410150544.GI10019@one.firstfloor.org> <alpine.LFD.1.00.0804100811400.3143@woody.linux-foundation.org> <47FE3B24.4020301@zytor.com> <Pine.LNX.4.58.0804101219170.7952@gandalf.stny.rr.com> <47FE493C.2010709@zytor.com> <alpine.LFD.1.00.0804101031421.3143@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804101031421.3143@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Obviously, it would have been really nice if something like the assembler 
> had caught it with some simple sanity-test (ie I think the .size thing 
> would be a good sanity check _regardless_), so in that sense it's our bug 
> that might have been avoided with soem sanity testing, but on the other 
> hand, I can well understand that gas didn't do it - since it would matter 
> only for totally buggy code that was never emitted by the compiler.
> 

Agreed.

> Gas historically used to not do any sanity-checking what-so-ever, and was 
> very much meant to be just for compiler output (which is why #APP exists 
> in the first place - to mark places that aren't pure compiler input). It's 
> actually improved immensely in that area and now is useful as a 
> traditional human-usable assembler with lots of support like macros etc.

Indeed it has.

	-hpa

