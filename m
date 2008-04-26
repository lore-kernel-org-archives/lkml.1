Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbYDZPlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbYDZPlw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYDZPlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:41:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43190 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbYDZPlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:41:44 -0400
Date: Sat, 26 Apr 2008 17:41:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [git pull] x86 PAT changes
Message-ID: <20080426154123.GA7295@elte.hu>
References: <20080424225625.GB8717@elte.hu> <481330C6.7040109@googlemail.com> <20080426144203.GA19635@elte.hu> <48134C45.806@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48134C45.806@googlemail.com>
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


* Gabriel C <nix.or.die@googlemail.com> wrote:

> Ingo Molnar wrote:
> > * Gabriel C <nix.or.die@googlemail.com> wrote:
> > 
> >> Hi Ingo,
> >>
> >> When using an 64bit ( didn't got time to test 32bit now ) kernel[1] 
> >> with PAT enabled , kvm-intel does not work anymore.
> >>
> >> When modprobing kvm-intel , kvm is saying VT extension is disable by 
> >> BIOS which isn't true. When disabling PAT again ( no changes to BIOS ) 
> >> kvm-intel works again here.
> >>
> >> Is that an known problem ?
> > 
> > no, that side-effect was not known. Cc:-ed more folks.
> 
> It seems like the update triggers some compiler bug.
> 
> Setting CC_OPTIMIZE_FOR_SIZE=n fixed that btw.
> 
> I don't have the time right now but later on today I will compile 
> gcc43_svn_branch and test again with CC_OPTIMIZE_FOR_SIZE=y and see 
> what I get.
> 
> Ingo sorry for the noise.

no problem and it's not noise even if it turns out to be a compiler 
problem - we very much want to know about them when they affect the 
kernel.

	Ingo
