Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbXEUGIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbXEUGIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 02:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbXEUGIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 02:08:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35779 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbXEUGIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 02:08:35 -0400
Date: Mon, 21 May 2007 08:08:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] lockdep: lock contention tracking
Message-ID: <20070521060828.GB20277@elte.hu>
References: <1179657026.5915.10.camel@lappy> <20070521060446.GA4593@gnuppy.monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521060446.GA4593@gnuppy.monkey.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Huey <billh@gnuppy.monkey.org> wrote:

> On Sun, May 20, 2007 at 12:30:26PM +0200, Peter Zijlstra wrote:
> > The 4 points are the first 4 unique callsites that cause lock contention
> > for the specified lock class.
> > 
> > writing a 0 to /proc/lockdep_contentions clears the stats
> 
> We should talk about unifying it with my lockstat work for -rt so that 
> we have a comprehensive solution for the "world". But you know that 
> already :)

To me it appears Peter's stuff is already a pretty complete solution on 
its own, and it's a whole lot simpler (and less duplicative) than your 
lockstat patch. Could you list the specific items/features that you 
think Peter's stuff doesnt have?

	Ingo
