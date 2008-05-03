Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbYECUUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbYECUUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 16:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYECUT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 16:19:59 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:50498 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbYECUT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 16:19:58 -0400
Date: Sat, 3 May 2008 23:19:08 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] posix timers: sigqueue_free: don't free sigqueue if it is queued
Message-ID: <20080503191908.GA92@tv-sign.ru>
References: <20080503173553.GA8106@tv-sign.ru> <alpine.LFD.1.10.0805031039430.5994@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805031039430.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03, Linus Torvalds wrote:
> 
> On Sat, 3 May 2008, Oleg Nesterov wrote:
> > 
> > Note: I am not sure we shouldn't do the opposite, free sigqueue + cancel the
> > pending signal, but this needs some ugly changes. Perhaps we should reconsider
> > this change later. See also http://bugzilla.kernel.org/show_bug.cgi?id=10460
> 
> You know what, I think there might be an even simple solution.
> 
> How about just setting a bit saying it is canceled

I see the light! Will return on May 10.

(Damn, you have proved I'm stupid twice on the same issue! OK, OK, thanks ;)

Oleg.

