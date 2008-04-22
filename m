Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbYDVTuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbYDVTuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757885AbYDVTty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:49:54 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34265 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620AbYDVTtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:49:53 -0400
Date: Tue, 22 Apr 2008 22:48:31 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] posix timers: don't discard the signal if the timer was explicitly destroyed
Message-ID: <20080422184831.GA105@tv-sign.ru>
References: <20080422153821.GA19903@tv-sign.ru> <20080422190849.6443E270381@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422190849.6443E270381@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22, Roland McGrath wrote:
>
> > I am not sure this patch is really needed, please review.
> 
> I don't think this is worth doing.
> 
> > The previous patch adds the user-visible change. It is not clear to me why
> > should we cancel the pending signal sent by the timer after timer_delete().
> > Suppose the signal is blocked, pending, the user checks sys_rt_sigpending(),
> > destroys the timer and then doesn't see the signal.
> 
> So?  POSIX says it's unspecified what happens to such a signal,

Ah, good!

> so an
> application can't rely on it one way or the other.  I don't see any reason
> to complicate it further.

Agreed, please ignore this patch.

Thanks! I really hoped you will nack this, I hate the additional complications
too.

Oleg.

