Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZDLNBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZDLNBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 09:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZDLNBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 09:01:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38855 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbZDLNBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 09:01:21 -0400
Date: Sun, 12 Apr 2009 15:01:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC 0/3] Improvements to the tracing documentation
Message-ID: <20090412130105.GB20281@elte.hu>
References: <1239479479-2603-1-git-send-email-tytso@mit.edu> <20090412092524.GA30349@elte.hu> <20090412121533.GB10547@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412121533.GB10547@mit.edu>
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


* Theodore Tso <tytso@mit.edu> wrote:

> On Sun, Apr 12, 2009 at 11:25:24AM +0200, Ingo Molnar wrote:
> > > I'm not sure the documentation is 100% correct, but by 
> > > submitting it, hopefully that the tracer authors will get 
> > > flushed out of the woodwork and be inspired to improve 
> > > what has been submitted.  :-)
> > 
> > Applied, thanks Ted!
> > 
> > Patch #1 was already present in the tracing tree - i've 
> > added both the event and the power tracer docs to 
> > Documentation/trace/.
> 
> Thanks for applying it so fast, [...]

Heh, i'm used to getting perfect patches from you :) Also, 
documentation is always lagging behind so every little piece helps, 
and it's not like it can actually break anything in the kernel.

> [...] but did you fix up the spelling and pathname 
> (Documentation/power.txt was supposed to be 
> Documentation/trace/power.txt) fixups that folks pointed out?

Yeah, i did that. I also fixed up a few other small details no-one 
pointed out.

> [...] I was going to send an v2 update of the patches.  So if you 
> haven't pushed them out yet, you might want to pull them until I 
> get them fixed up. Or I can send patches to fix up those issues, 
> whichever is more convenient for you.

No need to resend.

Btw., you mention ext4 and jbd2 new-style tracepoints in the text. 
Does this mean you already have them coded up (i havent seen any 
patch posting from you), just that you cannot push it upstream yet 
because ext4 can be a module? We'll have modular new-style 
tracepoints soon.

	Ingo
