Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYDJRM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYDJRM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbYDJRMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:12:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60231 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbYDJRMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:12:18 -0400
Message-ID: <47FE493C.2010709@zytor.com>
Date: Thu, 10 Apr 2008 10:07:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Whitcroft <apw@shadowen.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com> <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com> <87wsn6m6zt.fsf@basil.nowhere.org> <20080410094637.GW17915@shadowen.org> <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com> <20080410144114.GH10019@one.firstfloor.org> <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org> <20080410150544.GI10019@one.firstfloor.org> <alpine.LFD.1.00.0804100811400.3143@woody.linux-foundation.org> <47FE3B24.4020301@zytor.com> <Pine.LNX.4.58.0804101219170.7952@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0804101219170.7952@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> 
> Looking at the output below, shows that testing .sections in between
> #APP and #NO_APP would in fact catch this bug.
> 

Of course, The Right Thing[TM] would be for gcc to emit .pushsection ... 
.popsection around #APP ... #NO_APP.

	-hpa
