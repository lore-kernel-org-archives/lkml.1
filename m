Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYDMWKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYDMWKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYDMWK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:10:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55973 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030AbYDMWKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:10:21 -0400
Message-ID: <48028305.8040104@zytor.com>
Date: Sun, 13 Apr 2008 15:02:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Erik Bosman <ejbosman@cs.vu.nl>
CC: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl> <20080412124947.146865e4@laptopd505.fenrus.org> <48012002.8030701@zytor.com> <Pine.GSO.4.56.0804132320260.6537@keg.few.vu.nl>
In-Reply-To: <Pine.GSO.4.56.0804132320260.6537@keg.few.vu.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erik Bosman wrote:
> 
> It took me a while, but I have done some tests om my system with and
> without my patch applied.
> 
> All deamons but klogd/syslogd were shut down andI used the following
> command:
> 
> LMBENCH_SCHED="SINGLE" \
> /usr/lib/lmbench/bin/{i686-pc,x86_64}-linux-gnu/lat_ctx -s 0 2
> 
> The variation was quite high so I ran it a 1000 times for each
> configuration.
> 
> x86_32, patch applied,     1000x repeated, avg: 1.319, rmse: 0.081
> x86_32, patch not applied, 1000x repeated, avg: 1.335, rmse: 0.107
> 
> x86_64, patch applied,     1000x repeated, avg: 1.417, rmse: 0.0716
> x86_64, patch not applied, 1000x repeated, avg: 1.423, rmse: 0.0745
> 
> This is on a core 2 duo E6300.
> 

OK, so it sounds like there is no measurable difference.  Good.

	-hpa
