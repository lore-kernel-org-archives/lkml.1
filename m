Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbZCXOrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbZCXOrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZCXOq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:46:59 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50191 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZCXOq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:46:58 -0400
Date: Tue, 24 Mar 2009 20:16:57 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, tglx@linutronix.de, mhiramat@redhat.com,
       systemtap@sources.redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/kprobes] x86: kretprobe-booster interrupt
	emulation code fix
Message-ID: <20090324144657.GH3891@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <49C7995C.2010601@redhat.com> <tip-b9dad0d2955db059cd92c81c37ddcbef0abc8bf8@git.kernel.org> <20090324131359.GA13210@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324131359.GA13210@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 02:13:59PM +0100, Ingo Molnar wrote:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> >  	regs->ip = trampoline_address;
> >  	regs->orig_ax = ~0UL;
> > +	regs->gs = 0;
> 
> hm, this wont build on 32-bit.

I guess you meant 64 bit. Yes I see that it fails to build on x86_64.

Regards,
Bharata.
