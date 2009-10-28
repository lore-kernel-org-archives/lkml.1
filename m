Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbZJ1Gk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbZJ1Gk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbZJ1Gk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:40:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43717 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756851AbZJ1Gk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:40:26 -0400
Date: Wed, 28 Oct 2009 07:40:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Nicolas Pitre <nico@fluxnic.net>, "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC] to rebase or not to rebase on linux-next
Message-ID: <20091028064009.GA6353@elte.hu>
References: <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com> <20091023134115.GD27097@elte.hu> <alpine.LFD.2.00.0910231424440.21460@xanadu.home> <20091023191631.GA1879@elte.hu> <1256326512.26028.34.camel@gandalf.stny.rr.com> <20091023205400.GA8356@elte.hu> <20091023215958.GA4139@merkur.ravnborg.org> <1256599588.26028.340.camel@gandalf.stny.rr.com> <20091027075954.GA32640@elte.hu> <1256657956.26028.408.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256657956.26028.408.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 2009-10-27 at 08:59 +0100, Ingo Molnar wrote:
> 
> > For any reasonably complex change you simply need to wait a bit 
> > anyway to gather feedback. And for trivial/obvious/small patches it 
> > makes little sense to upset the Git history just to add the tags.
> > 
> > (And if there's frequent problems with small changes that were 
> > supposed to be easy you need to revisit the quality process.)
> 
> Sure, but I'm not talking about changing the patch, I'm talking about 
> a late "reviewed by" or "tested-by". These usually do come after a 
> patch set has been moved into the final git push. It would be nice to 
> flag a commit that it was tested by someone.

If you want to make your patches dependent on acks then you first need 
to send out those patches with an '[RFC]' added, and put into a branch 
hierarchy (rfc/* would be fine) that i sure wont pull from you.

You can also send obvious/small/own patches out for immediate pull. In 
that case extra review can still be done after you sent patches out. 
Mistakes noticed during review will be credited in terms of future 
Reported-by tags.

People do this frequently.

	Ingo
