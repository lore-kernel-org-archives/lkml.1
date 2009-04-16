Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbZDPAJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbZDPAJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZDPAJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:09:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47792 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZDPAJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:09:32 -0400
Date: Thu, 16 Apr 2009 02:08:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       tglx@linutronix.de, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090416000841.GA18185@elte.hu>
References: <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <20090415162627.GA32254@elte.hu> <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415133255.b6a33bfe.akpm@linux-foundation.org> <20090415210353.GA27368@elte.hu> <alpine.LFD.2.00.0904151406380.4042@localhost.localdomain> <20090415224017.GA18764@elte.hu> <alpine.LFD.2.00.0904151607010.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904151607010.4042@localhost.localdomain>
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

> On Thu, 16 Apr 2009, Ingo Molnar wrote:
> >
> > As i said it in the mail, i actually used the impact line of 
> > commit 6b44003e5ca66 ("work_on_cpu(): rewrite it to create a 
> > kernel thread on demand") later on, when a regression was caused 
> > by that commit.
> 
> Duh. You keep on repeating that idiotic argument.
> 
> The "Impact:" part had nothing what-so-ever to do with what you 
> argue for.
> 
> I'm not arguing against good commit messages. I'm arguing against 
> the "Impact:" part. It's pointless.
> 
> ALL of the commit message is (hopefully) about important things. 
> If you want to narrow it down to one single line, that's just 
> WRONG.

Ok, i see your argument.

Is there any other way for us to get the benefits of the impact 
line, without actually adding one?

They are:

 - Better split-up patches from contributors.

 - Increased maintainer and developer attention on the effects of
   patches.

 - Less time we have to spend on patches we get with impact-lines.
   Both hpa and me reported this.

 - easy regression post-mortems

What i dont understand is how you can dismiss these positive points 
so easily and only concentrate on the negative points - these 
effects are mostly visible to those creating impact lines - not to 
you. You cannot really have seen any of these effects without having 
done impact lines for a few days.

(
  Okay, you are perhaps an exception, you _do_ write fantastic
  commit logs that generally need no 'stinkin impact line.

  There's exceptions though, even with your commits. I wish you had 
  added one to ea34f43a for example, which you committed today.

  It is not clear from that commit log at all what the practical
  relevance of your fix is.

  I suspect it fixes Ali Gholami Rudi's problem of his CPU hitting
  50^C till the fan turns on.

  I'd probably have added the following impact line (although i'd
  have first asked Ali whether this is the precise impact the fix
  had on him - it's not 100% clear from the discussion):

    Impact: fix cpufreq misbehavior causing high CPU temperature

  Does this information matter? I think it does. Does it matter 
  _more_ than the rest of the commit log? I think, to most Linux
  users, it does. That's one of the reasons why we are experimenting 
  with formalized this kind of information. It's important 
  information and it should not be forgotten from commit logs.

  As a developer, while writing up a commit log it is _so_ easy to
  get lost in the details of the 'how' and 'why' - and not emit
  basic information: why do people care? What were the bad
  _practical_ effects of the bug that are fixed here?

  It is basic human nature to get lost in that - even for the best.
)

	Ingo
