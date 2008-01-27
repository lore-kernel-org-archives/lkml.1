Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbYA0WOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbYA0WOt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 17:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbYA0WOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 17:14:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35339 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbYA0WOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 17:14:40 -0500
Date: Sun, 27 Jan 2008 23:14:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Benjamin K. Stuhl" <benjamin.stuhl@colorado.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "sched: add vslice" causes horrible interactivity under load
Message-ID: <20080127221422.GA17085@elte.hu>
References: <20080127144400.78e0aec5@colorado.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127144400.78e0aec5@colorado.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin K. Stuhl <benjamin.stuhl@colorado.edu> wrote:

>   I recently upgraded from 2.6.23.x to 2.6.24 and found that whereas 
> with 2.6.23.x I could have multiple "make -j3" compilation runs going 
> in the background with no real problems (on a dual-core Core 2), with 
> 2.6.24 I get multiple-second lags when trying to switch tasks in KDE.

that sounds bad ... Could you send me the output of:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

while such delays are happening? Please enable CONFIG_SCHED_DEBUG=y and 
CONFIG_SCHEDSTATS=y as well before doing the dump. Also please send your 
.config.

to get best output from cfs-debug-info.sh, please first run this:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info-clear.sh

then reproduce the delay, and then run cfs-debug-info.sh to capture all 
that task stats.

	Ingo
