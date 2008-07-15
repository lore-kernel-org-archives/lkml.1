Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYGOVZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYGOVZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762698AbYGOVZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:25:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58690 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762205AbYGOVZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:25:31 -0400
Date: Tue, 15 Jul 2008 23:25:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] x86 updates
Message-ID: <20080715212514.GA13767@elte.hu>
References: <alpine.LFD.1.10.0807152249270.3283@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807151417440.2867@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0807151417440.2867@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 15 Jul 2008, Thomas Gleixner wrote:
> >
> > Please pull the latest x86/urgent git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/urgent
> 
> Hmm> "Already up-to-date"?
> 
> Also, your other tree seems to also have added annoying warnings:
> 
>   arch/x86/kernel/acpi/boot.c: In function ‘acpi_parse_fadt’:
>   arch/x86/kernel/acpi/boot.c:747: warning: format ‘%#x’ expects type ‘unsigned int’, but argument 2 has type ‘long unsigned int’
> 
> Grr.
> 
> Guys, stop sending me crap. A _little_ bit of testing would be good.

i've got dhowell's -Werr debug feature that allows us to integrate 
checks for warnings into our automated tests. (checking for warnings 
automatically is rather hard to do otherwise - gcc will mix it all up 
especially in make -j200 alike output)

i just need one free day add it and to cleanse the kernel from spurious 
warnings, so that we can catch all warnings from that point on :)

	Ingo
