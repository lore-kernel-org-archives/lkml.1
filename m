Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbZFWKHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbZFWKHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZFWKH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:07:27 -0400
Received: from www.tglx.de ([62.245.132.106]:54496 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbZFWKH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:07:26 -0400
Date: Tue, 23 Jun 2009 12:05:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: kerneloops.org report for the week of June 14 2009
In-Reply-To: <20090614173331.18f01123@infradead.org>
Message-ID: <alpine.LFD.2.00.0906231201430.2767@localhost.localdomain>
References: <20090614173331.18f01123@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Arjan van de Ven wrote:
> Rank 3: getnstimeofday (warning)
> 	Reported 309 times (2446 total reports)
> 	[suspend resume] getnstimeofday() is called before timekeeping is
        resumed

> Rank 6: hres_timers_resume (warning)
> 	Reported 188 times (1024 total reports)
> 	[suspend resume] hres_timers_resume() is incorrectly called with
>       interrupts on

Both have the same root cause. Something enables interrupts in the
early resume path. IIRC, there was a culprit identified
recently. Rafael ?

Thanks,

	tglx
