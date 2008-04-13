Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbYDMQzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbYDMQzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 12:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYDMQzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 12:55:04 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:65060 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751959AbYDMQzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 12:55:02 -0400
X-Greylist: delayed 3166 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Apr 2008 12:55:01 EDT
Date: Sun, 13 Apr 2008 16:27:05 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andy Whitcroft <apw@shadowen.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
In-Reply-To: <20080410150544.GI10019@one.firstfloor.org>
Message-ID: <Pine.LNX.4.55.0804131621100.12591@cliff.in.clinika.pl>
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com>
 <87wsn6m6zt.fsf@basil.nowhere.org> <20080410094637.GW17915@shadowen.org>
 <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com>
 <20080410144114.GH10019@one.firstfloor.org>
 <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org>
 <20080410150544.GI10019@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008, Andi Kleen wrote:

> A simple way to detect it on the assembler level would be checking
> that the section is the same after #NO_APP as before #APP

 Not as simple as the section stack would have to be traversed to check
whether there are any differences.  And in the end, either such a complete
check or a simple one you have proposed may not be desirable, because I
can imagine in some scenarios the change of a section in an asm may be
deliberate.  Let's not limit the tools.

  Maciej
