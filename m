Return-Path: <linux-kernel-owner+w=401wt.eu-S1761246AbXK1MvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761246AbXK1MvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759494AbXK1Mus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:50:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36348 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758773AbXK1Mur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:50:47 -0500
Date: Wed, 28 Nov 2007 13:50:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: -rt doesn't compile for UML
Message-ID: <20071128125030.GB21791@elte.hu>
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> When writing a big file to a ubd disk, everything in uml slows down to
> a crawl, even though CPU usage is minimal.
> 
> So I wanted to try the latency tracer from -rt, but it doesn't compile 
> with UML:

note that there are standalone patches as well:

 http://people.redhat.com/mingo/latency-tracing-patches/

so there's no forced need to use -rt.

> Ingo, do you think this route is worthwhile pursuing, or is it too 
> difficult to make -rt work for UML?

-rt should work for UML as well - but it needs porting (as every 
architecture).

	Ingo
