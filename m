Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbZLLKKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbZLLKKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 05:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761468AbZLLKKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 05:10:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48118 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761423AbZLLKKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 05:10:40 -0500
Date: Sat, 12 Dec 2009 11:10:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091212101032.GB25286@elte.hu>
References: <20091211232805.GA10652@kroah.com>
 <20091212084611.GA28266@elte.hu>
 <20091212013927.58d386d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091212013927.58d386d1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Seems to be quite .config-dependent.

My theory is that it's a race and that it's thus timing dependent. TTY 
SMP details get stressed most during a particular point during bootup, 
when all the mingetty's are starting up all at once and race with each 
other.

If you are lucky to not hit the bug then, then the likelyhood is much 
lower later on.

It would be nice if Alan posted his TTY stress-testing code. It could 
potentially make this bug bisectable.

	Ingo
