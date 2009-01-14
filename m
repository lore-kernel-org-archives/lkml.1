Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbZANKyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbZANKyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbZANKyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:54:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49857 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbZANKyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:54:32 -0500
Date: Wed, 14 Jan 2009 11:54:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: linux-kernel@vger.kernel.org, rientjes@google.com, mbligh@google.com,
       thockin@google.com
Subject: Re: [PATCH v3] softlockup: decouple hung tasks check from
	softlockup detection
Message-ID: <20090114105426.GH2913@elte.hu>
References: <20090112090307.GC26750@elte.hu> <20090112175803.GA3797@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112175803.GA3797@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mandeep Singh Baines <msb@google.com> wrote:

> Ingo Molnar (mingo@elte.hu) wrote:
> > Looks good in principle, but i suspect your patch submission should 
> > include the new kernel/hung_task.c file too ;-)
> > 
> > 	Ingo
> 
> Doh. Thanks for reviewing. Here is the same patch with hung_task.c included.

this now conflicts with the softlockup-panic fix you posted - and that fix 
has to go first as it's v2.6.29 material. (while the decoupling patch is 
2.6.30 material)

So could you please send a patch against tip/master:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
