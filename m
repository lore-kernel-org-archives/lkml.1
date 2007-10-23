Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbXJWPNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbXJWPNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbXJWPNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:13:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58616 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbXJWPNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:13:35 -0400
Date: Tue, 23 Oct 2007 17:13:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Al Viro <viro@ftp.linux.org.uk>,
       WANG Cong <xiyou.wangcong@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Nix <nix@esperi.org.uk>, Jeff Dike <jdike@addtoit.com>,
       Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in
	2.6.23-final.
Message-ID: <20071023151309.GA14998@elte.hu>
References: <20071022124551.GA7438@elte.hu> <471D2ECC.6090209@goop.org> <20071022231927.GA30814@elte.hu> <471D389E.40609@goop.org> <20071023084546.GA17007@elte.hu> <p73wste7zy5.fsf@bingen.suse.de> <20071023131009.GA32298@elte.hu> <p73sl427wvu.fsf@bingen.suse.de> <20071023142006.GA9961@elte.hu> <20071023144852.GA27956@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023144852.GA27956@one.firstfloor.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, Oct 23, 2007 at 04:20:06PM +0200, Ingo Molnar wrote:
> > 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > >> You should rename it then to "asmcall" or something.
> > > >
> > > > if then that should be a separate renaming patch.
> > > 
> > > Well you're asking for the ugly hacks for out of tree code.  [...]
> > 
> > nice word-bending there. I'm asking for pre-existing annotations to 
> > survive. 
> 
> What I'm objecting to is that you ask for this for your out of tree 
> code without any justification on why exactly -- -pg should in theory 
> work with -mregparms.

last i checked it didnt work - i'll re-check that.

but even taking the latency tracer completely out of the picture, 
maintaining this information is useful - at least for some time.

> It's standard policy to require very good reasons for changes that are 
> only useful for out of tree code. [...]

it's not just for out of tree code - it's to keep the information of the 
calling convention maintained - we could need it in the future.

> Is it just because you didn't want to adapt the tracer for i386 
> regparm? [...]

uhm, thank you for such accusations and personal attacks :-( How did i 
deserve that?

	Ingo
