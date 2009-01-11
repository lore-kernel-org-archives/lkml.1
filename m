Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbZAKBor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbZAKBor (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 20:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZAKBoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 20:44:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45728 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZAKBoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 20:44:38 -0500
Date: Sun, 11 Jan 2009 02:44:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/9] Performance counters for POWER
Message-ID: <20090111014429.GN12885@elte.hu>
References: <18791.10652.298501.863657@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18791.10652.298501.863657@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> The following series of patches extends Ingo and Thomas's performance
> counter framework to add support for 64-bit POWER processors.
> Currently I have the PPC970 family and POWER6 done.
> 
> The approach I have taken is to do the constraint checking and the
> search through the space of alternative event codes as each group of
> counters is added at the time a task is scheduled in.  That means we
> are potentially doing the search several times in a row, with
> interrupts disabled.  I think it will be OK since there are only a few
> events that have alternatives (and not many of them), and the
> constraint checking is fast since it is just simple integer
> operations.  However, one of the things I plan to do is to instrument
> that code to find out how long it takes in the worst case.  (If it
> takes too long then I will need some major changes to the generic
> code.)
> 
> This series is also available via git at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git
> 
> in the master branch.

Pulled into tip/perfcounters/core, thanks Paul!

	Ingo
