Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab0CDTLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:11:40 -0500
Received: from www.tglx.de ([62.245.132.106]:49987 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab0CDTLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:11:39 -0500
Date: Thu, 4 Mar 2010 20:08:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 06/12] genericirq: make irq_chip related function to take
 desc
In-Reply-To: <4B900250.8020100@kernel.org>
Message-ID: <alpine.LFD.2.00.1003042005000.2014@localhost.localdomain>
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org> <1267697339-5491-7-git-send-email-yinghai@kernel.org> <alpine.LFD.2.00.1003041142460.2014@localhost.localdomain> <4B900250.8020100@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010, Yinghai Lu wrote:
> On 03/04/2010 06:31 AM, Thomas Gleixner wrote:
> > The code which uses the chip functions needs to be changed:
> > 
> > -	desc->chip->fun(irq);
> > +	desc->chip->fun(desc);
> > 
> > That's mostly in kernel/irq/* but there are some users in arch/*
> > lowlevel irq handling code as well.
> 
> that is our -v2 version.

I know, but the difference is that it is done by a machine.

I have been involved in more than one large scale overhaul projects in
the kernel and most of the time I spent on those was to figure out the
right way to do it to limit the risks.

Automated conversion is the best thing you can do and if Julia can
whip up that rules, I'm less worried about the wholesale switchover on
a per function basis, than I'm scared about the fully manual approach
you took.

Thanks,

	tglx
