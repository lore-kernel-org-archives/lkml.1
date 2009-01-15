Return-Path: <linux-kernel-owner+w=401wt.eu-S1763828AbZAOK6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763828AbZAOK6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757185AbZAOK6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:58:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50611 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727AbZAOK6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:58:21 -0500
Date: Thu, 15 Jan 2009 11:58:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: remove byte locks
Message-ID: <20090115105808.GA16253@elte.hu>
References: <alpine.LNX.1.10.0901121247430.5377@jikos.suse.cz> <20090112120743.GC24266@elte.hu> <alpine.LNX.1.10.0901121334510.5377@jikos.suse.cz> <20090112124401.GA31939@elte.hu> <496D1F54.7070104@goop.org> <alpine.LNX.1.10.0901140016520.5377@jikos.suse.cz> <496D292B.20007@goop.org> <alpine.LNX.1.10.0901151147420.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0901151147420.5377@jikos.suse.cz>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 13 Jan 2009, Jeremy Fitzhardinge wrote:
> 
> > > Why can't this just be somewhere in documentation? (possibly even with 
> > > the byte locks code as a reference).
> > Because Ingo's compil-o-matic will never fail on a documentation error.
> 
> Hmm, I have always considered the "we don't accept any code that would 
> have zero in-kernel users" rule as a quite reasonable one, at least in 
> order to prevent from bloat and code getting confusing.
> But apparently it's not the intention here.
> 
> > > It is IMHO just totally confusing to have a spinlock implementation that is
> > > not used at all in the tree. It took me quite some time to go through this
> > > until I finally figured out that this code is actually never used.
> > > Currently, on first sight it might seem that byte locks are used whenever
> > > CONFIG_PARAVIRT is set, which is not true.
> > Well, a comment next to the code explaining the rationale probably 
> > wouldn't go astray.
> 
> I still strongly feel that if the only purpose of the code in kernel is 
> "to provide example", then it belongs to documentation.
> 
> > > And apparently even Linus got confused by this, which also tells us
> > > something by itself, see [1].
> > > [1] http://marc.info/?l=linux-kernel&m=123144211719754&w=2
> > It tells us that Linus couldn't give a rat's arse about virtualization, 
> > which is just something we have to cope with ;)
> 
> I am afraid this has nothing to do with virtualization. It's simply 
> confusing when looking at the code.

i'd tend to agree, that area of code is quite complex already.

	Ingo
