Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbYEGBdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbYEGBdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbYEGBc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:32:56 -0400
Received: from [198.99.130.12] ([198.99.130.12]:43951 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbYEGBcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:32:55 -0400
Date: Tue, 6 May 2008 21:31:35 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] fix UML on x86-64
Message-ID: <20080507013135.GA14251@c2.user-mode-linux.org>
References: <200805062304.m46N4h6d007206@devserv.devel.redhat.com> <alpine.LFD.1.10.0805061625090.32269@woody.linux-foundation.org> <4820EC0E.1030603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4820EC0E.1030603@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 04:38:54PM -0700, Ulrich Drepper wrote:
> Linus Torvalds wrote:
> > It breaks things how?
> 
> A crash on startup:
> 
> #12 0x0000000060021917 in wait_stub_done (pid=4384) at
> arch/um/os-Linux/skas/process.c:94
> #13 0x00000000600210a0 in do_syscall_stub (mm_idp=0x61f4fd28,
> addr=0x61c1fd18) at arch/um/os-Linux/skas/mem.c:86

Can you send me the binary?  Preferably with symbols?

    	     	Jeff

-- 
Work email - jdike at linux dot intel dot com
