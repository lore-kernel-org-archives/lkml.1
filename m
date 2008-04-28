Return-Path: <linux-kernel-owner+w=401wt.eu-S933577AbYD1LvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577AbYD1LvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 07:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763424AbYD1LvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 07:51:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58561 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756AbYD1LvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 07:51:17 -0400
Date: Mon, 28 Apr 2008 13:50:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, James.Bottomley@HansenPartnership.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
Message-ID: <20080428115057.GA21105@elte.hu>
References: <20080427231809.GA13848@elte.hu> <20080427.163106.181887129.davem@davemloft.net> <20080428100154.0ac65cb6@core> <20080428.021745.17554887.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428.021745.17554887.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> > So review them. Your comments strike me as the pot calling the 
> > kettle black given the way the network people like to live on their 
> > own mailing list.
> 
> Oh contraire.  Because we networking folks use a seperate mailing list 
> with a lower signal to noise ratio than lkml, and as a result more 
> specialization, more patches get more review by more specialists.

well, then lets go back to the very basis of this whole ... box match.
:) It was about a broken networking patch that i stumbled upon
(unwillingly, via testing), which commit was _not_ posted on netdev and 
_not_ posted on lkml:

   http://lkml.org/lkml/2008/4/19/51

I simply hit a (trivial) regression in the networking code, but i simply 
found no existing discussion of the suspect patch (commit 5e8fbe2a).

the development process is an integral part of the source code of this 
OS and not a private matter of developers or maintainers. It is not a 
religion and it is not taboo to criticise it, it is a crutial part of 
our technology. So i will continue to criticise the development process 
in the future too when i think it has aspects that hurts us. [and will 
try to address all incoming criticism as well.]

> You might want to know that linux-next mainly exists because of how 
> much of this has been going on over the past half year or so.

the problem is that linux-next alone would not have helped much in this 
specific matter. For example the softlockup warnings annoyance you 
reported would have triggered immediately had you booted your Sparc64 
box with linux-next or -mm even just _once_ :-)

But the same holds for me: had i ran linux-next i could have reported 
some of the networking regressions sooner.

So how about making mutual use of linux-next and 'promise' to each other 
to at least minimally build/boot the integrated tree, or at least 
promise to not complain too loudly about bugs that could have been found 
and reported there via reasonable mutual testing of linux-next? Does 
that sound reasonable?

	Ingo
