Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbZDLN7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbZDLN7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 09:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZDLN73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 09:59:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40830 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbZDLN72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 09:59:28 -0400
Date: Sun, 12 Apr 2009 15:59:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] remove the BKL: remove "BKL auto-drop" assumption from
	nfs3_rpc_wrapper()
Message-ID: <20090412135912.GA5246@elte.hu>
References: <1239381281-11282-1-git-send-email-abogani@texware.it> <20090410182936.GA6018@nowhere> <63a49ef40904101350y68e93b85tad7d355868de9a38@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63a49ef40904101350y68e93b85tad7d355868de9a38@mail.gmail.com>
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


* Alessio Igor Bogani <abogani@texware.it> wrote:

> Hi,
> 
> 2009/4/10 Frederic Weisbecker <fweisbec@gmail.com>:
> [...]
> >> Fix nfs3_rpc_wrapper()'s "schedule() drops the BKL automatically" assumption,
> >> when schedule_timeout_killable() does not do that it can lock up.
> [...]
> > Btw, does it fix the lockdep message you've seen while mounting
> > an nfs point?
> 
> Unfortunately no. That lockdep message still happens when I 
> unmount rpc_pipefs. I'll investigate further.

might make sense to post that message here out in the open - maybe 
someone with a strong NFSd-fu will comment on it.

	Ingo
