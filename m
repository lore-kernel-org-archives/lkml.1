Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYHCKeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYHCKeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 06:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbYHCKeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 06:34:23 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:43956 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbYHCKeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 06:34:22 -0400
Date: Sun, 3 Aug 2008 14:37:55 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: Oliver Pinter <pinter.oliver.villany@gmail.com>,
       linux-kernel@vger.kernel.org, w@1wt.eu,
       Roland McGrath <roland@redhat.com>, john stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Oliver Pinter <oliver.pntr@gmail.com>
Subject: Re: [RFC, 2.6.26.2-rc1] posix timers: release_posix_timer: kill the bogus put_task_struct(->it_process)
Message-ID: <20080803103755.GA79@tv-sign.ru>
References: <200808022345.20963.oliver.pntr@gmail.com> <alpine.LNX.1.10.0808030006040.2294@titan.stealer.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0808030006040.2294@titan.stealer.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Sven Wegener wrote:
>
> On Sat, 2 Aug 2008, Oliver Pinter wrote:
> 
> > It is an RFC for sending this patch for stable, when this patch needed, then send ACK and CC stable,
> > if not then send NAK.
> 
> I'd say big NAK. Have you ever looked at the full commit message and patch 
> at all? It says "release_posix_timer() can't be called with ->it_process 
> != NULL.". Point. The rest is the explanation why this can't happen. And 
> looking at the patch, we see that it just removes code that actually never 
> gets executed under the mentioned preconditions. It's a pure cleanup patch 
> and doesn't qualify for -stable. Same goes for the other posix timer patch 
> you mailed out.

I agree. Perhaps the changelog was badly written...

These 2 patches are just cleanups which remove the dead code,
this is not the -stable material.

Oleg.

