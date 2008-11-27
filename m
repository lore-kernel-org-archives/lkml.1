Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbYK0LxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbYK0LxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 06:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYK0LxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 06:53:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074AbYK0LxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 06:53:03 -0500
Date: Thu, 27 Nov 2008 12:52:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: oops/warning report for the week of November 26, 2008
Message-ID: <20081127115236.GE29013@elte.hu>
References: <492DD792.6080302@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492DD792.6080302@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> Rank 8: mtrr_trim_uncached_memory (warning)
> 	Reported 227 times (619 total reports)
> 	There is a high number of machines where our MTRR checks 
> 	trigger. I suspect we are too picky in accepting the MTRR 
> 	configuration.

the warning here means: "the BIOS messed up but we fixed it up for 
you just fine".

Should we print a DMI descriptor so that it can be tracked back to the 
bad BIOSen in question? Or should we (partially) silence the warning 
itself? Those BIOS bugs need fixing really: older kernels will boot up 
with bad MTRR settings - resulting in a super-slow system or other 
weirdnesses. We can tone down the message so that it doesnt show up in 
kerneloops.org. It's up to you.

	Ingo
