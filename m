Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbZDMTmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbZDMTmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZDMTl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:41:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52364 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbZDMTl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:41:57 -0400
Date: Mon, 13 Apr 2009 21:40:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       travis@sgi.com, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, rusty@rustcorp.com.au, lenb@kernel.org
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
Message-ID: <20090413194012.GA12639@elte.hu>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org> <4609.1239456126@turing-police.cc.vt.edu> <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain> <20090413171853.GA4601@elte.hu> <20090413102749.4ca3a217.akpm@linux-foundation.org> <alpine.LFD.2.00.0904131040350.4583@localhost.localdomain> <20090413114932.44b47910.akpm@linux-foundation.org> <20090413190319.GA4261@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413190319.GA4261@redhat.com>
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


* Dave Jones <davej@redhat.com> wrote:

> On Mon, Apr 13, 2009 at 11:49:32AM -0700, Andrew Morton wrote:
>  > On Mon, 13 Apr 2009 10:45:45 -0700 (PDT)
>  > > 
>  > > IOW, why not just do
>  > > 
>  > > 	smp_call_function_many(cmd->mask, do_drv_write, cmd, 1);
>  > > 
>  > > here?
>  > > 
>  > 
>  > Didn't know it existed :(
> 
> heh. I'm going to run with that excuse too.
> Remember the days when you could fit the kernels API in your head? :)

smp_call_function_many() is the modern mask-pointery version of 
smp_call_function_mask() - which is a pretty ancient API.

	Ingo
