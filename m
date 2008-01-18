Return-Path: <linux-kernel-owner+w=401wt.eu-S932562AbYARWGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbYARWGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762059AbYARWGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:06:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40721 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761373AbYARWGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:06:44 -0500
Date: Fri, 18 Jan 2008 23:06:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/7] Remove CONFIG_X86_TSC for 32bit II
Message-ID: <20080118220628.GA17542@elte.hu>
References: <20080118627.198787000@suse.de> <20080118172721.96C8B14AAE@wotan.suse.de> <p73tzlaalq3.fsf_-_@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73tzlaalq3.fsf_-_@bingen.suse.de>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Andi Kleen <ak@suse.de> writes:
> 
> > The config option protects so little code that it is fairly pointless.
> > Also a lot of its code was related to itself only (as in panicing without
> > TSC). And TSC less CPUs are completely handled at runtime anyways.
> >
> > This makes 32bit behaviour match x86-64.
> >
> > I also removed an #if defined(CONFIG_X86_GENERIC) in get_cycles. Not 
> > sure what that was good for, it didn't make any sense.
> 
> Hmm, during further testing i found that the patch causes boot 
> failures in some configuration. I withdraw this one for now.

ok, pulled. In what situations did it fail? It worked fine on a (small) 
number of systems here.

> The other patches in the series are independent and should be still 
> considered for merging.

yep, they are in and have caused no problems so far.

	Ingo
