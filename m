Return-Path: <linux-kernel-owner+w=401wt.eu-S1762666AbYEOUKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762666AbYEOUKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYEOUKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:10:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbYEOUKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:10:43 -0400
Date: Thu, 15 May 2008 16:09:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080515200923.GC9718@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com> <20080514205204.GJ30469@redhat.com> <1210818762.23707.102.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1210818762.23707.102.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[..]
> > > +2:
> > > +	call	*%edx
> > 
> > > +	movl	%edi, %edx
> > > +	popl	%edi
> > > +	pushl	%edx
> > > +	jmp	2b
> > > +
> > 
> > What does above piece of code do? Looks like redundant for switching
> > between the kernels? After call *%edx, we never return here. Instead
> > we come back to "kexec_jump_back_entry"?
> 
> For switching between the kernels, this is redundant. Originally another
> feature of kexec jump is to call some code in physical mode. ﻿This is
> used to provide a C ABI to called code.
> 

Hi Huang,

Ok, You want to make BIOS calls. We already do that using vm86 mode and
use bios real mode interrupts. So why do we need this interface? Or, IOW,
how is this interface better?

Do you have something in mind where/how are you going to use it?

Thanks
Vivek
