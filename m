Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYFQJVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYFQJVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 05:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYFQJVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 05:21:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58677 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbYFQJVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 05:21:03 -0400
Date: Tue, 17 Jun 2008 11:20:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Oops report for the week preceding June 16th, 2008
Message-ID: <20080617092023.GA20621@elte.hu>
References: <4856AFDF.5080901@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4856AFDF.5080901@linux.intel.com>
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

> This week, a total of 3877 oopses and warnings have been reported, 
> compared to 3390 reports in the previous week.
>
> Recently, Fedora put out an updated kernel that contained a wireless 
> update; unfortunately, this update was rather broken and caused 
> various things to show up in the top 20. A few days later, another 
> update fixing the most obvious ones got released with the result that 
> only rank 2 and 9 are from the broken update, rather than a lot more..

sidenote: i suspect Fedora has done this to enable more hardware, and/or 
to fix mainline wireless bugs?

I wish we would do such new driver merging in mainline instead, so that 
we had a single point of testing and single point of effort.

Same for Nouveau: Fedora carries it and i dont understand why such a 
major piece of work is not done in mainline and not _helped by_ 
mainline. It's not like there would be any big risk from having such a 
new, experimental 3D driver around - instead of people running nvidia.ko 
that causes trouble in all sorts of other subsystems.

All the years of moaning about nvidia.ko and finally we have some real 
OSS project and real chance of action but after a year of development 
Nouveau still has not been picked up ...

When distros feel the need to add large and risky patches that IMO shows 
process failure on our part and further isolates mainline from distros 
and from testers.

While we dont want to merge anything that gets thrown at us, not merging 
new, major, new-hardware-enabling OSS drivers in the mainline kernel is 
almost the same thing as intentionally hurting OSS projects and helping 
binary-only drivers.

	Ingo
