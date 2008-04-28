Return-Path: <linux-kernel-owner+w=401wt.eu-S964930AbYD1PCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930AbYD1PCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbYD1PCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:02:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58115 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbYD1PCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:02:13 -0400
Date: Mon, 28 Apr 2008 17:01:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: x86: fix a couple of sparse warnings
Message-ID: <20080428150156.GA7412@elte.hu>
References: <1209338159-30095-1-git-send-email-dmitri.vorobiev@gmail.com> <20080428123809.GD27997@elte.hu> <20080428133756.GJ16379@cs181133002.pp.htv.fi> <90edad820804280643p43509911gd7b497131c3f5004@mail.gmail.com> <20080428135957.GK16379@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428135957.GK16379@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Adrian Bunk <bunk@kernel.org> wrote:

> On Mon, Apr 28, 2008 at 05:43:25PM +0400, Dmitri Vorobiev wrote:
> > 2008/4/28 Adrian Bunk <bunk@kernel.org>:
> > >
> > >  /me wonders what was wrong with http://lkml.org/lkml/2008/4/23/131
> > >     that contains a superset of the first patch
> > >     (and got no response at all)
> > 
> > Adrian, I am sorry for duplicating your work. The clash wasn't 
> > intentional: I did not notice your earlier patch in the high traffic 
> > of this mailing list.
> 
> No problem, and I'm actually more interested why my patch got lost.

It's simple: in this case i had two patches in my backlog, one from a 
new person and one from a frequent contributor - doing the very same 
change. I preferred the newbie's patch, to encourage Dmitri to keep 
contributing to Linux and to help him learn from the experience of 
working with various Linux maintainers.

You contributed a lot of similar changes already, and are 1500 similar 
patches down the line, and for "trivial" patches like this you probably 
aren't going to learn anything new.

That doesn't mean your work is not appreciated - there's 5 of your 
patches queued up in x86.git this very moment [one of them is a subset 
of the patch you mention above] and a few more in my mbox, but it does 
mean that for a case like this, the newbie's change wins. And that 
applies to my own changes just as much : often a newbie submits a 
cleanup that i have done already but i'll put in the newbie's patch and 
drop mine.

	Ingo
