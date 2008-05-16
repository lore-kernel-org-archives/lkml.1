Return-Path: <linux-kernel-owner+w=401wt.eu-S1763549AbYEPSx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763549AbYEPSx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760346AbYEPSxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:53:40 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:38918 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763449AbYEPSxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:53:38 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: spontaneous reboots and hangs on x86_64
Date: Fri, 16 May 2008 20:53:36 +0200
User-Agent: KMail/1.9.7
Cc: Adrian Bunk <bunk@kernel.org>, kernel-testers@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200805152201.49154.m.kozlowski@tuxland.pl> <200805160737.50373.m.kozlowski@tuxland.pl> <20080516174452.6fff3a3e.sfr@canb.auug.org.au>
In-Reply-To: <20080516174452.6fff3a3e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805162053.36390.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> >> > Hm it can be that I did something wrong ...
> > 
> > and I did :/ I think I just started this repo in wrong way - according to linux-next FAQ.
> > I'll just start from scratch then.
> 
> OK, let me know how you go.

Ok I got bisection working finally, now I'm at d5be23e2 I have something like 80 revisions left and
I'm stuck with this:

In file included from kernel/sched.c:1861:
kernel/sched_rt.c: In function 'check_preempt_curr_rt':
kernel/sched_rt.c:653: error: implicit declaration of function 'cpupri_find'
kernel/sched_rt.c:653: error: 'struct root_domain' has no member named 'cpupri'
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2

Another (dumb I guess) git question: how can I move forward with this?

	Mariusz
