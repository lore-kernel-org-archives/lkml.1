Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbXCaQcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbXCaQcP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 12:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbXCaQcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 12:32:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50056 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbXCaQcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 12:32:14 -0400
Date: Sat, 31 Mar 2007 18:31:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug] hung bootup in various drivers, was: "2.6.21-rc5: known regressions"
Message-ID: <20070331163122.GA2512@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015929.GY16477@stusta.de> <20070330120416.GA19373@elte.hu> <20070330141639.GA10387@suse.de> <20070330174619.GA12589@elte.hu> <20070330193258.GA7403@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330193258.GA7403@suse.de>
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


* Greg KH <gregkh@suse.de> wrote:

> Something has grabbed a reference to the driver...
> 
> Oh wait, is this code a module or built into the kernel?
> 
> If it's built in, there's still a reference counting bug in the 
> module/driver hookup logic as we really don't have a "module" yet we 
> are still thinking we do as we represent it in /sys/module and create 
> the linkages.

yes - an allyesconfig bzImage kernel is definitely massively built in :)

> Kay, did you ever get a chance to look into this reference counting 
> issue?

i'll try Kay's patch.

	Ingo
