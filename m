Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZI3PG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZI3PG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZI3PG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:06:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbZI3PG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:06:26 -0400
Date: Wed, 30 Sep 2009 17:05:49 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] itimers: fix racy writes to cpu_itimer fields
Message-ID: <20090930150548.GA22195@dhcp-lab-161.englab.brq.redhat.com>
References: <1253802903-979-1-git-send-email-sgruszka@redhat.com> <1253803687.18939.26.camel@laptop> <20090924195732.384bea26@dhcp-lab-109.englab.brq.redhat.com> <1253815467.18939.168.camel@laptop> <20090924201943.GA19969@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924201943.GA19969@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 10:19:43PM +0200, Ingo Molnar wrote:
> > [ there is no reason to rely on the tick though, we can program the 
> > hrtimer on sched in to expire on at the right moment, and do so on 
> > each schedule for as long as an itimer is active - re-setting whatever 
> > pending timer the cpu still had. ]
> 
> we should think about the simplest approach: switching itimers to 
> hrtimers.

I agree we need better implementation of posix-cpu-timers, however as
far we have this not perfect code and two patches fix bugs on it.
Not critical bugs, but I think they should be applied. Have I resend
them ?

Stanislaw
