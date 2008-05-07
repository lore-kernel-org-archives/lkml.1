Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbYEGBuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbYEGBuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbYEGBuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:50:35 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:44073 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYEGBue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:50:34 -0400
Date: Tue, 6 May 2008 21:48:57 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de
Subject: Re: [PATCH] fix UML on x86-64
Message-ID: <20080507014857.GB14912@c2.user-mode-linux.org>
References: <200805062304.m46N4h6d007206@devserv.devel.redhat.com> <alpine.LFD.1.10.0805061625090.32269@woody.linux-foundation.org> <4820EC0E.1030603@redhat.com> <alpine.LFD.1.10.0805061655590.32269@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805061655590.32269@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 05:06:40PM -0700, Linus Torvalds wrote:
> Some UML person should really take a look. It might be a compiler bug that 
> is triggered by -fno-unit-at-a-time, but considering that x86 is the most 
> tested architecture by far and apparently does *not* hit that problem, it 
> sounds more likely that it's UML-related and the compiler just triggers a 
> bug in UML.
> 
> Anybody?

I think that's likely true.

  	       	      Jeff

-- 
Work email - jdike at linux dot intel dot com
