Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbYG2MIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbYG2MIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 08:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbYG2MIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 08:08:11 -0400
Received: from web32606.mail.mud.yahoo.com ([68.142.207.233]:43458 "HELO
	web32606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756137AbYG2MIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:08:10 -0400
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Tue, 29 Jul 2008 05:08:06 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: Linux v2.6.27-rc1
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <320122.81433.qm@web32606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Peter Zijlstra <peterz@infradead.org>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>; Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Sent: Tuesday, July 29, 2008 1:57:38 PM
> Subject: Re: Linux v2.6.27-rc1
> 
> On Tue, 2008-07-29 at 04:23 -0700, Martin Knoblauch wrote:
> > ----- Original Message ----
> > 
> > > From: Linus Torvalds 
> > > To: Linux Kernel Mailing List 
> > > Sent: Tuesday, July 29, 2008 5:23:21 AM
> > > Subject: Linux v2.6.27-rc1
> > > 
> > > 
> > > It's two weeks (and one day), and the merge window is over.
> > > 
> > 
> >   CHK     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   CALL    scripts/checksyscalls.sh
> >   CHK     include/linux/compile.h
> >   CC      arch/x86/kernel/ldt.o
> > arch/x86/kernel/ldt.c: In function `alloc_ldt':
> > arch/x86/kernel/ldt.c:67: error: invalid lvalue in unary `&'
> > make[1]: *** [arch/x86/kernel/ldt.o] Error 1
> > make: *** [arch/x86/kernel] Error 2
> > 
> > This is a x86_64 build on a RHEL4U3 userland (gcc version 3.4.5
> > 20051201 (Red Hat 3.4.5-2)). Config is taken from 2.6.26.
> 
> Its due to your ancient compiler - fix can be found here:
>

 That are the joys of "Enterprise Distributions" :-)

>   http://lkml.org/lkml/2008/7/29/48

 Thanks. Seems to fix it. 

Cheers
Martin

