Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbYGRLgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbYGRLgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYGRLgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:36:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45391 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbYGRLge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:36:34 -0400
Date: Fri, 18 Jul 2008 13:36:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <aviro@redhat.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86_64 ia32 syscall audit fast-path
Message-ID: <20080718113615.GD6875@elte.hu>
References: <20080707065615.77BD9154246@magilla.localdomain> <20080707065742.7C119154246@magilla.localdomain> <alpine.LFD.1.10.0807070927090.11076@woody.linux-foundation.org> <alpine.LFD.1.10.0807070937520.11076@woody.linux-foundation.org> <20080708000233.E8EF3154244@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708000233.E8EF3154244@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> I don't know if there was some reason I did it that way rather than 
> the other.  I don't remember in which order I wrote and rewrote the 
> patches. I'll cop to laziness if you like.
> 
> It reminded me that I'd never tested the AMD (syscall/sysret) version 
> of this path.  That was clearly just plain lazy, and it was in fact 
> broken. It's a good thing you called me names and made me feel bad 
> about myself, so I cast about for more of my failings.
> 
> This version of the patch changes what you didn't like, and it works 
> right on both the AMD (syscall) and Intel (sysenter) paths.  (Yes, I 
> had already tested all the other paths.  This is the only one that is 
> not used on Intel hardware.)

do you have a delta patch against tip/x86/audit-speedup by any chance? 
That is a topic branch of your previous drop, which got tested as well 
to a certain degree. Would make it easier to see what changed, would 
make the merge have a more nuanced history, etc.

or, alternatively, if you have a -git based branch that i could pull, 
that would be nice as well. (i can compare old-x86/audit-speedup to 
new-x86/audit-speedup.)

	Ingo
