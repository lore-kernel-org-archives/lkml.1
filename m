Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbZDPHP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbZDPHP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZDPHPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:15:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35594 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbZDPHPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:15:20 -0400
Date: Thu, 16 Apr 2009 09:14:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090416071442.GA2351@elte.hu>
References: <20090415133255.b6a33bfe.akpm@linux-foundation.org> <20090415210353.GA27368@elte.hu> <alpine.LFD.2.00.0904151406380.4042@localhost.localdomain> <20090415224017.GA18764@elte.hu> <alpine.LFD.2.00.0904151607010.4042@localhost.localdomain> <20090416000841.GA18185@elte.hu> <alpine.LFD.2.00.0904151717040.4042@localhost.localdomain> <alpine.LFD.2.00.0904151736140.4042@localhost.localdomain> <20090416005025.GA2779@elte.hu> <49E6B51A.5030501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E6B51A.5030501@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
> >>
> >> At least then it wouldn't break up the narrative, and it would 
> >> kind of fit with all the other "tagged" lines.
> > 
> > Yeah, that makes sense.
> 
> Actually, there is one good thing about this.  One of the things 
> we've found useful is to have the maintainer add or edit Impact: 
> lines. Putting them with the tags would make it more clear who did 
> the impact assessment.

Ah, indeed - good point. There two other good things about moving 
the impact line to the signoff section:

 - We can actually add it every time - even if it repeats bits of
   the subject line which would look weird if it was in the second 
   line. Right now with the impact line in a prominent place i often 
   feel reluctant to add an impact line when the subject line is 
   good enough to describe the expected risk/impact of a change.

 - I can update my scripts to warn when i sign off on something with 
   no impact line. I.e. the "dont forget to assess impact" step 
   becomes even harder to flunk.

/me likes.

We then also need a good Documentation/impact-tag.txt description 
about it, and list the principles and a few good and bad examples. 
Would you like to write it up?

	Ingo
