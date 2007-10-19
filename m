Return-Path: <linux-kernel-owner+w=401wt.eu-S936033AbXJSTlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936033AbXJSTlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758349AbXJSTl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:41:29 -0400
Received: from www.tglx.de ([62.245.132.106]:39425 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758804AbXJSTl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:41:28 -0400
Date: Fri, 19 Oct 2007 21:41:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] Remove 'irq' argument from all irq handlers
In-Reply-To: <m1wstigan8.fsf@ebiederm.dsl.xmission.com>
Message-ID: <alpine.LFD.0.9999.0710192139590.22770@localhost.localdomain>
References: <20071019075443.GA6407@havoc.gtf.org> <alpine.LFD.0.9999.0710191649120.22770@localhost.localdomain> <m1bqavgdbf.fsf@ebiederm.dsl.xmission.com> <20071019190721.GA1514@elte.hu> <m1wstigan8.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Eric W. Biederman wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> >> > thanks for doing this.
> >> 
> >> Yes.  keeping this alive is good.
> >> 
> >> The practical question is how do we make this change without breaking 
> >> the drivers that use their irq argument.
> >
> > the get_irq_regs() approach worked out really well. We should do a 
> > get_irq_nr() and be done with it?
> 
> The problem are some drivers today pass in 0 for their irq number
> to flag that they are calling the interrupt handler in a polling
> mode (not from interrupt context?) so the same logic doesn't quite apply.
> 
> Do what you suggest would likely break those drivers.

How many of them do we have ? This is a wilful abuse of the API, so
its not a big damage if they break.

    tglx
