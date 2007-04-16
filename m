Return-Path: <linux-kernel-owner+w=401wt.eu-S1030668AbXDPOft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030668AbXDPOft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030672AbXDPOft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:35:49 -0400
Received: from [212.12.190.15] ([212.12.190.15]:33002 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030668AbXDPOfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:35:48 -0400
From: Al Boldi <a1426z@gawab.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
Date: Mon, 16 Apr 2007 17:38:47 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200704150931.42268.a1426z@gawab.com> <200704161342.34498.a1426z@gawab.com> <46237483.6010801@bigpond.net.au>
In-Reply-To: <46237483.6010801@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704161738.47956.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Williams wrote:
> Al Boldi wrote:
> > Reducing the prio-level granularity may also be helpful;
>
> Because of some of the bit operations code makes it a bad idea to have
> more than 160 priority levels, you're more or less limited to 60
> priority levels for SCHED_OTHER tasks (as 100 are used for real time)
> and you need 40 of these to pay some attention to niceness leaving you
> about 20 priority levels to use for fiddling.  Is that enough?
>
> With spa_ebs (now that CPU rate caps have been removed), you have all 60
> priorities available for fiddling with as niceness is taken care of when
> calculating each task's entitlement.

Ok, increasing the number of prio-levels is one thing, but I was more 
thinking of reducing the effective difference between each prio-level. For 
example, this would allow max_tpt_bonus=18, while the effective range would 
be 3, thus reducing granularity.  Would this be easily introduceable?


Thanks!

--
Al

