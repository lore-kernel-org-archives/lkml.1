Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbXJYWws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbXJYWws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbXJYWwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:52:41 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:12302 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751850AbXJYWwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:52:40 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <47211E2C.90301@am.sony.com>
Date: Thu, 25 Oct 2007 15:52:28 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Jon Smirl <jonsmirl@yahoo.com>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: IRQ off latency of printk is very high
References: <4720F21F.9090404@am.sony.com> <20071025222804.GA13954@Krystal>
In-Reply-To: <20071025222804.GA13954@Krystal>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2007 22:52:37.0507 (UTC) FILETIME=[BD460530:01C81759]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> It might help to read this thread I posted on LKML in January 2006
> explaining the problem, which led to some discussion about the issue.
> 
> http://lkml.org/lkml/2006/6/3/48

This is very helpful.  Jon Smirl's answer seems to give the
rationale for supporting printk output in interrupt context.
I'm not sure, however, if extending the interrupt off period
to cover the console output is required.  It didn't until
Ingo changed it in 2.6.17. Maybe this was intentional to
allow printk output to drain before another (printk in
interrupt context) could even possibly be generated, but it
seems like overkill.

I'll continue looking at this.  It helps a lot to know about
the issues discussed in the prior thread.

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

