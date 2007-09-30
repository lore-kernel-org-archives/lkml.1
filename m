Return-Path: <linux-kernel-owner+w=401wt.eu-S1758968AbXI3Reb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968AbXI3Reb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758072AbXI3ReN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:34:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39601 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758016AbXI3ReM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:34:12 -0400
Date: Sun, 30 Sep 2007 19:33:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nickpiggin@yahoo.com.au,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Dinakar Guniguntala <dino@in.ibm.com>, cpw@sgi.com
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Message-ID: <20070930173340.GA13066@elte.hu>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Jackson <pj@sgi.com> wrote:

> Add a new per-cpuset flag called 'sched_load_balance'.
> 
> When enabled in a cpuset (the default value) it tells the kernel 
> scheduler that the scheduler should provide the normal load balancing 
> on the CPUs in that cpuset, sometimes moving tasks from one CPU to a 
> second CPU if the second CPU is less loaded and if that task is 
> allowed to run there.
> 
> When disabled (write "0" to the file) then it tells the kernel 
> scheduler that load balancing is not required for the CPUs in that 
> cpuset.

i like this, this feature would be quite useful for -rt and CPU 
shielding.

( a cpuset is a mandatory container for set_cpus_allowed(), so there is
  a material and app-visible difference between a 4-CPU cpuset that has 
  balancing disabled and 4x 1-CPU cpusets. )

	Ingo
