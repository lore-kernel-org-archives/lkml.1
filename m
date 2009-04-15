Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbZDOWsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbZDOWsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 18:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbZDOWsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 18:48:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59924 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZDOWsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 18:48:40 -0400
Date: Thu, 16 Apr 2009 00:48:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090415224800.GA22425@elte.hu>
References: <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415.142326.97287514.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415.142326.97287514.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Wed, 15 Apr 2009 12:43:02 -0700 (PDT)
> 
> > And if it _is_ obvious, then the mechanical "Impact:" thing is pointless.
> > 
> > In other words - in neither case does it actually help anything at all. 
> > It's only distracting noise.
> 
> FWIW I find the Impact: blurbs highly annoying too.  Just freakin' 
> say what the damn patch does in the commit message.

Just curious: have you tried to use them over a couple of days, just 
to check whether your first read-only impression is correct, that 
they are just annoying blurbs with no other effects? (you might have 
- I dont know.)

> If a person can't be bothered to skim the commit message text, 
> this Impact: tag only gives them a false sense of understanding 
> what the change does.

So do you consider it wrong to summarize impact? Does this argument 
extend to other summaries as well, such as the title itself? Or is 
your argument that there should be only a single kind of summary in 
a commit - the title itself?

Also, would it be wrong for people to be able to skim commit logs 
only for 'interesting looking' commits, by using impact tags? Should 
they be 'punished' by us obfuscating away summaries intentionally?

Also, do you think hpa was not telling the truth when he said that 
it is much faster for him to review patches that have an impact 
line? Do you think i am not telling the truth for reporting the same 
experience? Isnt speed and effiency of review something we should be 
happy to improve?

	Ingo
