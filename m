Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbYDJR6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbYDJR6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbYDJR6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:58:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42253 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718AbYDJR6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:58:09 -0400
Message-ID: <47FE541C.90704@zytor.com>
Date: Thu, 10 Apr 2008 10:53:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Pinski <pinskia@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Whitcroft <apw@shadowen.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] pop previous section in alternative.c
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com>	 <20080410094637.GW17915@shadowen.org>	 <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com>	 <20080410144114.GH10019@one.firstfloor.org>	 <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org>	 <20080410150544.GI10019@one.firstfloor.org>	 <alpine.LFD.1.00.0804100811400.3143@woody.linux-foundation.org>	 <47FE3B24.4020301@zytor.com>	 <Pine.LNX.4.58.0804101219170.7952@gandalf.stny.rr.com>	 <47FE493C.2010709@zytor.com> <de8d50360804101032p6c82ed33i686c13f0bfc70e8a@mail.gmail.com>
In-Reply-To: <de8d50360804101032p6c82ed33i686c13f0bfc70e8a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Pinski wrote:
> On Thu, Apr 10, 2008 at 10:07 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>  Of course, The Right Thing[TM] would be for gcc to emit .pushsection ...
>> .popsection around #APP ... #NO_APP.
> 
> Why??  GCC assumes that people don't do crazy things in their
> inline-asm and the source did in this case.

Because even good people do bad things sometimes.

	-hpa

