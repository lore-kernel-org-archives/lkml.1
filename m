Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZDIDF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZDIDF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 23:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbZDIDFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 23:05:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57005 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbZDIDFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 23:05:10 -0400
Date: Thu, 9 Apr 2009 05:04:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andy Whitcroft <apw@canonical.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: checkpatch fixes
Message-ID: <20090409030440.GA9169@elte.hu>
References: <20090408062106.39EE0FC3E5@magilla.sf.frob.com> <alpine.LFD.2.00.0904081007530.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904081007530.4583@localhost.localdomain>
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

> Oh well.  If I actually read perl, I could parse what the hell 
> those 80-character rules are in checkpath.  It already has random 
> "it's ok if X" stuff.  But it never seems to really have any "oh, 
> but splitting is worse" logic.

We should perhaps introduce an too-deep-indentation warning: any 
function with "[;{}]$" lines of 4 tabs in a row is already suspect 
IMHO. At 5 it's definitely crazy and ugly.

This would be a very efficient function-length reductor: it cannot 
be worked around via line wraps.

It would also be wonderful to warn about bad 80 columns 'fixes' - 
i've seen way too many perfectly fine cleanups damaged by ugly 
line-wrapping solutions.

We could also up the limit to 90 or 100 columns. My terminals are at 
90 columns and that's still pretty ergonomic. 100 is too wide to me 
personally. (i'd argue that lines longer than 100 fall outside the 
brain's 'field of view' cache and are beyond a general complexity 
threshold as well, so they are not efficient to read, regardless of 
monitor size and quality.)

	Ingo
