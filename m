Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbYG2L5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbYG2L5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 07:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbYG2L5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 07:57:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50000 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbYG2L5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 07:57:42 -0400
Subject: Re: Linux v2.6.27-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <406267.89338.qm@web32605.mail.mud.yahoo.com>
References: <406267.89338.qm@web32605.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 13:57:38 +0200
Message-Id: <1217332658.7563.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 04:23 -0700, Martin Knoblauch wrote:
> ----- Original Message ----
> 
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> > To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> > Sent: Tuesday, July 29, 2008 5:23:21 AM
> > Subject: Linux v2.6.27-rc1
> > 
> > 
> > It's two weeks (and one day), and the merge window is over.
> > 
> 
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC      arch/x86/kernel/ldt.o
> arch/x86/kernel/ldt.c: In function `alloc_ldt':
> arch/x86/kernel/ldt.c:67: error: invalid lvalue in unary `&'
> make[1]: *** [arch/x86/kernel/ldt.o] Error 1
> make: *** [arch/x86/kernel] Error 2
> 
> This is a x86_64 build on a RHEL4U3 userland (gcc version 3.4.5
> 20051201 (Red Hat 3.4.5-2)). Config is taken from 2.6.26.

Its due to your ancient compiler - fix can be found here:

  http://lkml.org/lkml/2008/7/29/48

