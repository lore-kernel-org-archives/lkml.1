Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbYEGAIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbYEGAIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 20:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYEGAIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 20:08:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751885AbYEGAIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 20:08:10 -0400
Date: Tue, 6 May 2008 17:06:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, Jeff Dike <jdike@linux.intel.com>
Subject: Re: [PATCH] fix UML on x86-64
In-Reply-To: <4820EC0E.1030603@redhat.com>
Message-ID: <alpine.LFD.1.10.0805061655590.32269@woody.linux-foundation.org>
References: <200805062304.m46N4h6d007206@devserv.devel.redhat.com> <alpine.LFD.1.10.0805061625090.32269@woody.linux-foundation.org> <4820EC0E.1030603@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 May 2008, Ulrich Drepper wrote:
> 
> Linus Torvalds wrote:
> > It breaks things how?
> 
> A crash on startup:

Some UML person should really take a look. It might be a compiler bug that 
is triggered by -fno-unit-at-a-time, but considering that x86 is the most 
tested architecture by far and apparently does *not* hit that problem, it 
sounds more likely that it's UML-related and the compiler just triggers a 
bug in UML.

Anybody?

Yes, I'll revert that commit, but just reverting it without somebody 
trying to figure out what is wrong with UML isn't good.

		Linus
