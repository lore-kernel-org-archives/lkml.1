Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbYDJPBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbYDJPBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759041AbYDJPBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:01:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59975 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758668AbYDJPBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:01:10 -0400
Date: Thu, 10 Apr 2008 17:05:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       Andy Whitcroft <apw@shadowen.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
Message-ID: <20080410150544.GI10019@one.firstfloor.org>
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com> <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com> <87wsn6m6zt.fsf@basil.nowhere.org> <20080410094637.GW17915@shadowen.org> <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com> <20080410144114.GH10019@one.firstfloor.org> <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 07:46:25AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 10 Apr 2008, Andi Kleen wrote:
> > 
> > So in summary valid section patterns are either
> > .section / .previous or .pushsection .section .popsection
> 
> The thing is, we'd be much better off with some sanity checking in the 
> assembler.
> 
> Which is likely not going to happen - oh well.

A simple way to detect it on the assembler level would be checking
that the section is the same after #NO_APP as before #APP

-Andi
