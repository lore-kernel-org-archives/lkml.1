Return-Path: <linux-kernel-owner+w=401wt.eu-S1758985AbYFMMi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbYFMMi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 08:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbYFMMit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 08:38:49 -0400
Received: from www.tglx.de ([62.245.132.106]:39537 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460AbYFMMit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 08:38:49 -0400
Date: Fri, 13 Jun 2008 14:38:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>
Subject: Re: [patch 3/6] x86: use cpuinfo to check for interrupt pending
 message msr
In-Reply-To: <20080613065524.GE7763@alberich.amd.com>
Message-ID: <alpine.LFD.1.10.0806131436510.5735@apollo.tec.linutronix.de>
References: <20080610171639.551369443@linutronix.de> <20080610171712.304283554@linutronix.de> <20080613065524.GE7763@alberich.amd.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008, Andreas Herrmann wrote:
> > +	/* Family 0x0f models < rev F do not have this MSR */
> > +	if (c->x86 == 0x0f && c->x86_model < 0x40)
> > +		return 0;
> 
> Just some minor nitpicking.
> Older AMD family 0xf CPUs have this Interrupt Pending Message
> Register. But they do not support C1E and thus bits 27 and 28 of this
> MSR are reserved.

So the check can be simplified to always check the MSR for all 
family >= 0x0f CPUs ?

Thanks,

	tglx
