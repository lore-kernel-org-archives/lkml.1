Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbZAGS4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbZAGS4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZAGS4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:56:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57056 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbZAGS4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:56:33 -0500
Date: Wed, 7 Jan 2009 19:56:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: i8259.c fix style problems
Message-ID: <20090107185614.GD16193@elte.hu>
References: <1231067032.27852.34.camel@jaswinder.satnam> <alpine.LFD.1.10.0901071814580.11407@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0901071814580.11407@ftp.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> > @@ -323,7 +323,7 @@ void init_8259A(int auto_eoi)
> >  	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
> >  
> >  	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 on x86-64,
> > -	                       to 0x20-0x27 on i386 */
> > +	   to 0x20-0x27 on i386 */
> >  	outb_pic(IRQ0_VECTOR, PIC_MASTER_IMR);
> >  
> >  	/* 8259A-1 (the master) has a slave on IR2 */
> 
>  I think the original formatting is more readable; I would align the two 
> 'to's vertically even.  You can fix the comment to adhere to the Linux 
> coding standard though and the whitespace "problem" will vanish 
> automagically.

yep, this should be:

  	/*
	 * ICW2: 8259A-1 IR0-7 mapped to:
	 *
	 * - 0x20-0x27 on 32-bit
	 * - 0x30-0x37 on 64-bit
	 */

	Ingo
