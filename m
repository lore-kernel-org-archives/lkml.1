Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbYIDQPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbYIDQPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 12:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbYIDQPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:15:04 -0400
Received: from www.tglx.de ([62.245.132.106]:42017 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYIDQPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:15:03 -0400
Date: Thu, 4 Sep 2008 18:14:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Andreas Herrmann <andreas.herrmann3@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert commit e8aa4667baf74dfd85fbaab86861465acb811085
In-Reply-To: <20080904153206.GB7120@elte.hu>
Message-ID: <alpine.LFD.1.10.0809041812450.3243@apollo.tec.linutronix.de>
References: <20080904144657.GC15987@alberich.amd.com> <20080904153206.GB7120@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008, Ingo Molnar wrote:

> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > This reverts commit e8aa4667baf74dfd85fbaab86861465acb811085
> >  (x86: enable hpet=force for AMD SB400)
> > 
> > Since ATI/AMD decided not to support HPET on SB4xx it doesn't
> > make sense to enable this unsupported feature.
> > (I was not aware of this when submitting the quirk.)
> > 
> > If a system with SB4xx chipset provides an ACPI HPET table and does
> > not boot, "nohpet" should be used as kernel parameter.
> > 
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> 
> applied to tip/x86/urgent, thanks Andreas. I guess a system broke due to 
> this commit?

Hmm, why do we remove something which needs to be force enabled by the
user anyway ?  

Is the HPET on these systems not working at all so the force enable
code is useless ?

Thanks,
	
	tglx
