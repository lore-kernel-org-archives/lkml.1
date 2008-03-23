Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbYCWLQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbYCWLQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 07:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761006AbYCWLQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 07:16:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59547 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760977AbYCWLQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 07:16:32 -0400
Subject: Re: [PATCH 120/148] include/asm-x86/suspend_32.h: checkpatch
	cleanups - formatting only
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080323085726.GA4216@martell.zuzino.mipt.ru>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
	 <1206259443-13210-121-git-send-email-joe@perches.com>
	 <20080323085726.GA4216@martell.zuzino.mipt.ru>
Content-Type: text/plain
Date: Sun, 23 Mar 2008 12:16:08 +0100
Message-Id: <1206270968.6437.97.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-23 at 11:57 +0300, Alexey Dobriyan wrote:
> On Sun, Mar 23, 2008 at 01:03:35AM -0700, Joe Perches wrote:
> > --- a/include/asm-x86/suspend_32.h
> > +++ b/include/asm-x86/suspend_32.h
> > @@ -32,11 +32,11 @@ extern unsigned long saved_edi;
> >  static inline void acpi_save_register_state(unsigned long return_point)
> >  {
> >  	saved_eip = return_point;
> > -	asm volatile ("movl %%esp,%0" : "=m" (saved_esp));
> > -	asm volatile ("movl %%ebp,%0" : "=m" (saved_ebp));
> > -	asm volatile ("movl %%ebx,%0" : "=m" (saved_ebx));
> > -	asm volatile ("movl %%edi,%0" : "=m" (saved_edi));
> > -	asm volatile ("movl %%esi,%0" : "=m" (saved_esi));
> > +	asm volatile("movl %%esp,%0" : "=m" (saved_esp));
> > +	asm volatile("movl %%ebp,%0" : "=m" (saved_ebp));
> > +	asm volatile("movl %%ebx,%0" : "=m" (saved_ebx));
> > +	asm volatile("movl %%edi,%0" : "=m" (saved_edi));
> > +	asm volatile("movl %%esi,%0" : "=m" (saved_esi));
> 
> Since when "volatile" became a function?

Agreed, this is crack.

Joe, please find something useful to contribute. Having a few cleanup
patches at the beginning of a useful series isn't an issue, but such
series as posted here are utterly annoying, and by the above just plain
stupid.

checkpatch.pl is a guide, not a replacement for common sense.

