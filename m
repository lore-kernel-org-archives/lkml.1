Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbYGTN0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbYGTN0B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 09:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbYGTNZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 09:25:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:59133 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbYGTNZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 09:25:52 -0400
Subject: Re: [PATCH] Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Woodhouse <dwmw2@infradead.org>, rth@twiddle.net,
       rmk@arm.linux.org.uk, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
       matthew@wil.cx, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       chris@zankel.net
In-Reply-To: <20080720131727.GA22822@linux-mips.org>
References: <1216544940.12650.13.camel@jaswinder.satnam>
	 <20080720100039.GA12514@linux-mips.org>
	 <1216556263.2707.2.camel@jaswinder.satnam>
	 <20080720131727.GA22822@linux-mips.org>
Content-Type: text/plain
Date: Sun, 20 Jul 2008 18:54:45 +0530
Message-Id: <1216560285.2707.12.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ralf,

On Sun, 2008-07-20 at 14:17 +0100, Ralf Baechle wrote:
> On Sun, Jul 20, 2008 at 05:47:43PM +0530, Jaswinder Singh wrote:
> 
> > index 7cd25b8..af24926 100644
> > --- a/include/asm-generic/Kbuild.asm
> > +++ b/include/asm-generic/Kbuild.asm
> > @@ -27,6 +27,7 @@ unifdef-y += socket.h
> >  unifdef-y += sockios.h
> >  unifdef-y += stat.h
> >  unifdef-y += statfs.h
> > +unifdef-y += syscalls.h
> >  unifdef-y += termbits.h
> >  unifdef-y += termios.h
> >  unifdef-y += types.h
> > 
> > Thank you,
> 
> No.  Why would userspace want to know about these entry points?
> 

Yes, I am totally agree with you, I also point this in my previous email.

Thank you,

Jaswinder Singh.

