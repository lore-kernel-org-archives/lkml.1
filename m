Return-Path: <linux-kernel-owner+w=401wt.eu-S1757731AbZEFVbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731AbZEFVbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbZEFVau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:30:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56053 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbZEFVat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:30:49 -0400
Date: Wed, 6 May 2009 23:29:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Markus Gutschke =?utf-8?B?KOmhp+Wtn+WLpCk=?= <markus@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-mips@linux-mips.org, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
Message-ID: <20090506212913.GC4861@elte.hu>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com> <20090228030413.5B915FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902271932520.3111@localhost.localdomain> <alpine.LFD.2.00.0902271948570.3111@localhost.localdomain> <20090228072554.CFEA6FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902280916470.3111@localhost.localdomain> <904b25810905061146ged374f2se0afd24e9e3c1f06@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <904b25810905061146ged374f2se0afd24e9e3c1f06@mail.gmail.com>
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


* Markus Gutschke (顧孟勤) <markus@google.com> wrote:

> On Sat, Feb 28, 2009 at 10:23, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:

> > And I guess the seccomp interaction means that this is 
> > potentially a 2.6.29 thing. Not that I know whether anybody 
> > actually _uses_ seccomp. It does seem to be enabled in at least 
> > Fedora kernels, but it might not be used anywhere.
> 
> In the Linux version of Google Chrome, we are currently working on 
> code that will use seccomp for parts of our sandboxing solution.

That's a pretty interesting usage. What would be fallback mode you 
are using if the kernel doesnt have seccomp built in? Completely 
non-sandboxed? Or a ptrace/PTRACE_SYSCALL based sandbox?

	Ingo
