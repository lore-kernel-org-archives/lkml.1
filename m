Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbYEPULd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbYEPULd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbYEPULT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:11:19 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:48138 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbYEPULS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:11:18 -0400
Message-ID: <482DEA5F.7020201@isomerica.net>
Date: Fri, 16 May 2008 16:11:11 -0400
From: =?ISO-8859-2?Q?Dan_No=E9?= <dpn@isomerica.net>
Reply-To: dpn@isomerica.net
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Adrian Bunk <bunk@kernel.org>,
       kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: spontaneous reboots and hangs on x86_64
References: <200805152201.49154.m.kozlowski@tuxland.pl> <200805160737.50373.m.kozlowski@tuxland.pl> <20080516174452.6fff3a3e.sfr@canb.auug.org.au> <200805162053.36390.m.kozlowski@tuxland.pl>
In-Reply-To: <200805162053.36390.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski wrote:
> Ok I got bisection working finally, now I'm at d5be23e2 I have something like 80 revisions left and
> I'm stuck with this:
> 
> In file included from kernel/sched.c:1861:
> kernel/sched_rt.c: In function 'check_preempt_curr_rt':
> kernel/sched_rt.c:653: error: implicit declaration of function 'cpupri_find'
> kernel/sched_rt.c:653: error: 'struct root_domain' has no member named 'cpupri'
> make[1]: *** [kernel/sched.o] Error 1
> make: *** [kernel] Error 2
> 
> Another (dumb I guess) git question: how can I move forward with this?

git bisect skip

-- 
                     /--------------- - -  -  -   -   -
                     |  Dan Noé
                     |  http://isomerica.net/~dpn/
