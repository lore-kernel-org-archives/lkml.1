Return-Path: <linux-kernel-owner+w=401wt.eu-S1764795AbXLTQeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764795AbXLTQeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbXLTQeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:34:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37723 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758669AbXLTQeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:34:15 -0500
Date: Thu, 20 Dec 2007 17:33:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: not needed patch
Message-ID: <20071220163352.GA6930@elte.hu>
References: <200712192057.02500.yinghai.lu@sun.com> <20071220142906.GA20794@elte.hu> <476A983F.1060704@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476A983F.1060704@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> >> by revert commit fbdcf18df73758b2e187ab94678b30cd5f6ff9f9, we could 
> >> use c->cpu_index in identify_cpu.
> > 
> > but that's 2.6.25 stuff, right? Travis?
> > 
> 
> Looking at this more closely, yes my change is not needed and should 
> be removed.  I'm not sure what caused my cpu # to be all zeros when I 
> was testing, but it now works ok without my change.

how about this question:

> > well, it might in the worst-case be a superfluous change, but not 
> > cause any problems in 2.6.24, right?

	Ingo
