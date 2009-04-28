Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZD1Gah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZD1Gah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 02:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZD1Ga2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 02:30:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32803 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbZD1Ga1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 02:30:27 -0400
Date: Tue, 28 Apr 2009 08:29:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>, Dave Airlie <airlied@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
Message-ID: <20090428062924.GA6769@elte.hu>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com> <20090427083935.GA20941@elte.hu> <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com> <49F65FA2.4010603@kernel.org> <alpine.LFD.2.00.0904271852510.22156@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904271852510.22156@localhost.localdomain>
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

> On Tue, 28 Apr 2009, Tejun Heo wrote:
> > 
> > I think defconfig should enable options such that it shows where 
> > upstream kernel is headed, so FWIW +1 for KMS from me.
> 
> I'd actually love to get rid of the stupid defconfig's entirely. 
> They've lost pretty much all relevance over the years, except for 
> specific cases where you might have defconfigs that are for 
> specific platforms.

Yes, exactly. That is the main reason why i NAK-ed a patchset a year 
ago that would have increased the number of defconfigs on x86 
dramatically:

  http://lkml.org/lkml/2008/2/25/86

The defconfig still has some very minimal meaning: i use it for 
example when i create a default config for a new box. It gives a 
reasonable default and then i double-check the lsmod output against 
the .config and add one or two more drivers. [would be nice to have 
that all automatic btw. - a 'make config-for-this-hardware' type of 
kbuild/kconfig thing.]

It is also a good 'middle-ground' config for tests. My tests first 
do a 32-bit defconfig, then a 64-bit defconfig, then allno, allyes, 
allmod. The defconfig builds quickly so often i can see problems 
based on those first iterations already.

	Ingo
