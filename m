Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbZJ0INj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbZJ0INj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932110AbZJ0INi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:13:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54286 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108AbZJ0INh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:13:37 -0400
Date: Tue, 27 Oct 2009 09:13:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: rostedt@goodmis.org, sam@ravnborg.org, linux-kernel@vger.kernel.org,
       nico@fluxnic.net, tony.luck@intel.com, sfr@canb.auug.org.au,
       mcgrof@gmail.com, jeff@garzik.org, robert.richter@amd.com,
       dmitry.torokhov@gmail.com, khali@linux-fr.org,
       torvalds@linux-foundation.org
Subject: Re: [RFC] to rebase or not to rebase on linux-next
Message-ID: <20091027081316.GB32640@elte.hu>
References: <1256603403.26028.358.camel@gandalf.stny.rr.com> <20091026.183416.52095233.davem@davemloft.net> <1256612558.26028.391.camel@gandalf.stny.rr.com> <20091026.221854.111712128.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026.221854.111712128.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Mon, 26 Oct 2009 23:02:38 -0400
> 
> > Whether I'm sending a patch to Ingo, Linus, Andrew, or even you, I 
> > would do it publicly and have a git repo to pull from for 
> > simplicity.
> 
> Sure, but just don't do it with a GIT repo that's going to make it's 
> way to Linus.
> 
> When you commit to any such GIT repo, you're making a permanent 
> irrevocable change whose history cannot be changed.
> 
> And given what you get in return for that, it's a pretty reasonable 
> constraint.

Agreed - and the people asking us to rebase trees miss this point, 
completely.

The thing is, i've been on both sides of the equation - three years ago 
i ran a patch-queue with 1500 patches in it, two years ago i ran a daily 
rebasing/rewinding Git tree and later i ran an occasionally-rebasing 
flow as well.

By far the best method is to not rebase/rewind maintainer trees.

If Linus can manage without rebasing _ever_, with _his_ rate of 10,000 
commits every 3 months, 300+ merges, with up to 50 direct commits 
authored by him per cycle then i'm quite sure other maintainers should 
be able to do that too. (at minimum the larger ones)

The networking tree has been doing this for a long amount of time - and 
all the trees i co-maintain are very close to doing this as well. So if 
there's any trend for the trees i'm involved with it's in the direction 
of _less_ rebasing/rewinding, not more of it.

	Ingo
