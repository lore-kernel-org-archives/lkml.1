Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbYAOWKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbYAOWKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYAOWKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:10:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36241 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbYAOWKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:10:08 -0500
Date: Tue, 15 Jan 2008 23:09:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ed Tomlinson <edt@aei.ca>
Cc: Matthew <jackdachef@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of
	32bit applications(binaries) on 64bit system (Gentoo)
Message-ID: <20080115220952.GD2665@elte.hu>
References: <47841C41.4060401@zytor.com> <e85b9d30801140847k4b19cea4nd08461c1664a1b35@mail.gmail.com> <20080114170036.GL15542@elte.hu> <200801141716.38380.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801141716.38380.edt@aei.ca>
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


* Ed Tomlinson <edt@aei.ca> wrote:

> This is _not_ a regression.  This has been occuring for ages here.  A 
> backport of this fix to 2.6.23 would be a very good thing - IMHO its 
> something that should go into stable asap.

the problem is that this bug was only present in x86.git. I.e. neither 
2.6.24 nor 2.6.23 has this particular bug.

perhaps something else in x86.git fixed your box, but this 
x86.git-specific hang 'took over its place', and now that it got fixed, 
you've got a working box? In any case, please monitor your box, it might 
still lock up the same way it did previously ...

	Ingo
