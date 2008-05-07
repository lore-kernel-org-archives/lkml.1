Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYEGAQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYEGAQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 20:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYEGAQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 20:16:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295AbYEGAQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 20:16:00 -0400
Date: Tue, 6 May 2008 17:15:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, Jeff Dike <jdike@linux.intel.com>
Subject: Re: [PATCH] fix UML on x86-64
In-Reply-To: <alpine.LFD.1.10.0805061655590.32269@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805061712380.32269@woody.linux-foundation.org>
References: <200805062304.m46N4h6d007206@devserv.devel.redhat.com> <alpine.LFD.1.10.0805061625090.32269@woody.linux-foundation.org> <4820EC0E.1030603@redhat.com> <alpine.LFD.1.10.0805061655590.32269@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 May 2008, Linus Torvalds wrote:
> 
> Yes, I'll revert that commit

And btw, a revert is what I'm going to do, not just bump the gcc version 
up as in Uli's patch. As mentioned, if it was about gcc versions, matching 
the x86 choice should have been the much better tested one than picking 
another version at random.

		Linus
