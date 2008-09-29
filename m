Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbYI2JC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbYI2JC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYI2JCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:02:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51896 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbYI2JCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:02:48 -0400
Date: Mon, 29 Sep 2008 11:02:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip 2/3] Tracing/ftrace: Adapt mmiotrace to the new
	type of print_line
Message-ID: <20080929090231.GD2190@elte.hu>
References: <48DD0347.5070008@gmail.com> <20080928192909.30e0f5dd@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080928192909.30e0f5dd@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Paalanen <pq@iki.fi> wrote:

> > +		return TRACE_TYPE_HANDLED;
> >  	}
> >  }
> 
> Otherwise, very good.
> 
> As Ingo reverted the two earlier patches, you need to rebase these 
> two. I'd like to see these in upstream. Let's handle the pipe closing 
> bug in a different patch.

good. Frederic, please just resubmit all fixes you have against 
tip/master, with Pekka's Acked-by added. You can submit Pekka's patch as 
well, so that it's a coherent series. The customary way for that is to 
add in a From line as the first line of the changelog:

 From: Pekka Paalanen <pq@iki.fi>

and add your signoff to the end of the changelog. This way Git will show 
Pekka as the author and the path of the patch is well understood.

Thanks,

	Ingo
