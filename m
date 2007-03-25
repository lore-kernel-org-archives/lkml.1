Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbXCYSbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbXCYSbg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 14:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXCYSbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 14:31:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35392 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbXCYSbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 14:31:34 -0400
Date: Sun, 25 Mar 2007 20:30:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Stable Kernel Team <stable@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [BUG] __copy_to_user_inatomic broken on non Pentium machines
Message-ID: <20070325183010.GA12676@elte.hu>
References: <1174810024.10840.477.camel@localhost.localdomain> <Pine.LNX.4.64.0703251039170.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703251039170.6730@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, 25 Mar 2007, Thomas Gleixner wrote:
> >
> > Environment: Pre Pentium systems, (boot_cpu_data.wp_works_ok == 0)
> 
> This shouldn't be "pre-pentium", afaik. WP-works-ok on i486 too. I 
> think only the original i386 had this bug ("feature").
> 
> But I agree, it does seem to be broken on such machines (I assume you 
> don't actually have one, but just tested by forcing it by hand ;)

actually, AFAIK this is a genuine i386 box Thomas has (an embedded 
board). Our hardware legacies and the resulting dependencies _really_ 
stick around for quite long time :-/

	Ingo
