Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbZF0Fcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbZF0Fcw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 01:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbZF0Fcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 01:32:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbZF0Fco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 01:32:44 -0400
Date: Sat, 27 Jun 2009 07:32:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vince Weaver <vince@deater.net>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: performance counter 20% error finding retired instruction count
Message-ID: <20090627053231.GA16200@elte.hu>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy> <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy> <1246043554.31755.207.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246043554.31755.207.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > PS.  Why is the perf code littered with many many  __MINGW32__ defined?
> >       Should this be in the kernel tree?  It makes the code really hard
> >       to follow.  Are there plans to port perf to windows?
> 
> Comes straight from the git sources.. and littered might be a bit 
> much, I count only 11.
> 
> # git grep MING tools/perf | wc -l
> 11
> 
> But yeah, that might want cleaning up.

Indeed. I removed those bits - thanks Vince for reporting it!

	Ingo
