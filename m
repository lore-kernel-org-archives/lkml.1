Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189Ab0AWJBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab0AWJBt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 04:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868Ab0AWJBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 04:01:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43662 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab0AWJBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 04:01:48 -0500
Date: Sat, 23 Jan 2010 10:01:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <petkovbb@googlemail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
       tglx@linutronix.de, andreas.herrmann3@amd.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3 0/5] x86, cacheinfo, amd: L3 Cache Index Disable fixes
Message-ID: <20100123090135.GB20056@elte.hu>
References: <1264172467-25155-1-git-send-email-bp@amd64.org>
 <4B59DF4C.7040608@zytor.com>
 <20100122174049.GC19425@aftab>
 <4B59E507.9060403@zytor.com>
 <20100123065953.GB15774@elte.hu>
 <20100123081132.GB7098@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100123081132.GB7098@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <petkovbb@googlemail.com> wrote:

> On Sat, Jan 23, 2010 at 07:59:53AM +0100, Ingo Molnar wrote:
> > 
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> > 
> > > On 01/22/2010 09:40 AM, Borislav Petkov wrote:
> > > >>>
> > > >>> Those patches are also good -stable candidates.
> > > >>
> > > >> Hmmm... I'm not sure I see a strong justification for a late -rc push
> > > >> into Linus/stable push for for these... I think you would have to
> > > >> explicitly make the case if you want them to be considered as such.
> > > > 
> > > > Well, on the one hand, they fix real bugs in the L3 cache index disable 
> > > > code and since they're bugfixes, they are eligible late -rc candidates.
> > > 
> > > Bugfixes are *early* -rc candidates.  Regression fixes are *late* -rc 
> > > candidates, at least that seems to be the policy Linus currently implements.  
> > > -stable seems to use slightly less strict criteria (the whole point is that 
> > > -final needs to be a stabilization point, backported fixes/drivers can then 
> > > come onto a stable base) which is why you seem some patches which are 
> > > "straight to .1".
> > 
> > Yes.
> 
> Ok, thanks for the clarification - my only trouble was that the current
> code is b0rked as is and those fixes are needed. However, backporting
> them at a later point seems much more riskfree and I will do so later.
> 
> Thanks.

Well, if there's a crasher in there, then a minimal fix to address just that 
is preferred for .33 - and that can be tagged for -stable immediately.

Anything more complex (these handful of patches) should go via the usual route 
of .34-rc1 and then -stable if it's problem-free.

	Ingo
