Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbXDYLox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbXDYLox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbXDYLow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:44:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41117 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbXDYLow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:44:52 -0400
Date: Wed, 25 Apr 2007 13:43:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Guilherme Schroeder <guilherme@centralinf.com.br>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Mikael Pettersson <mikpe@it.uu.se>, ak@suse.de, discuss@x86-64.org,
       Jeff Chua <jeff.chua.linux@gmail.com>, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, Dave Jones <davej@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@infradead.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Dmitry Torokhov <dtor@insightbb.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [3/3] 2.6.21-rc7: known regressions (v2)
Message-ID: <20070425114317.GA32153@elte.hu>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070423214909.GD3468@stusta.de> <20070425040605.6d6b4a82.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425040605.6d6b4a82.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > Subject    : suspend to disk hangs  (CONFIG_NO_HZ)
> > References : http://lkml.org/lkml/2007/3/25/217
> > Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
> > Status     : unknown
> 
> That's still rather a lot of bustage from the timekeeping changes.  Is 
> anything really happening here or have we all given up?

Jeff: does that suspend-to-disk hang problem also happen if you use 
hpet=disable?

	Ingo
