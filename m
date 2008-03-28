Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYC1Jc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYC1Jc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 05:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYC1Jct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 05:32:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57803 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbYC1Jct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 05:32:49 -0400
Date: Fri, 28 Mar 2008 10:32:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Mayer <ajm@sgi.com>
Cc: torvalds@linux-foundation.org,
       linux-kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86_64: resize NR_IRQS for large machines (re-submit)
Message-ID: <20080328093234.GD30863@elte.hu>
References: <20080327163314.GA24180@elte.hu> <Pine.SGI.3.96.1080327115108.7873204e-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SGI.3.96.1080327115108.7873204e-100000@fergus.americas.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0029]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Mayer <ajm@sgi.com> wrote:

> > i think you got it right, yes. But ... this is just a quick 
> > first-look suggestion from me, YMMV. Maybe you find a way to do it 
> > much easier to just convert everything at once. I tend to do things 
> > more gradually, in my experience it's very hard and time-consuming 
> > to change the world all at once - it's hard both to you the 
> > developer (you dont know whether it works until you have a very 
> > substantial amount of code written - while in a more gradual 
> > approach it can be converted one by one perhaps) - and it's hard for 
> > users and fellow kernel hackers.
> 
> I think I'll take a crack at it.  Doing it in phases means I can 
> invest a little less time and still give everyone a chance to see if 
> they like it.  And, the initial stuff seems like the area where people 
> will be the most likely to have problems and/or suggestions.  I have 
> no idea how long it will take to get something out there.  Stay tuned.

great! If your initial target for this is x86 (which has certainly the 
most twisted IRQ architecture of all architectures) then we'd be glad to 
host and test your patches in x86.git/latest - even if they touch 
drivers and other core code. Once it's proven enough it could be 
rehosted to -mm.

	Ingo
