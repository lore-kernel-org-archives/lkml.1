Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZBUJqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZBUJqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 04:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZBUJqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 04:46:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33463 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbZBUJqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 04:46:31 -0500
Date: Sat, 21 Feb 2009 10:46:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20090221094614.GA26948@elte.hu>
References: <20090219171005.GA27922@elte.hu> <alpine.LFD.2.00.0902201809260.21686@localhost.localdomain> <20090221083212.GA1537@elte.hu> <20090221091826.GA30055@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090221091826.GA30055@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> I will be happy to merge a patch that makes the warnings 
> become visible again and also to make them hard errors.
>
> But for now I cannot take the additional work it requires to 
> follow all the section mismatch warnings that suddenly will 
> pop up for the different architectures, which is why I 
> hesitate to create said patch myself.

Ok - i'm working on a patch that enables it on x86 and makes it 
a hard failure, and brings the number of warnings down to a zero 
baseline where we can base a sane future on. Other architectures 
can then opt-in too when they see fit - or can leave it disabled 
if it's too much work for them.

	Ingo
