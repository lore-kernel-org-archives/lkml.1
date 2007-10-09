Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbXJIK0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbXJIK0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 06:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbXJIK0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 06:26:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49222 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbXJIK0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 06:26:47 -0400
Date: Tue, 9 Oct 2007 12:26:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH for 2.6.23] Fix scheduler domain sysctl list
Message-ID: <20071009102632.GB15583@elte.hu>
References: <20071009100224.GA22834@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009100224.GA22834@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> Ingo has this already fixed in sched-devel (but he also adds more 
> parameters here). Since the fix is very simple I think it should be 
> fixed for .23. Especially cache_nice_tries is useful to tune because 
> it is very magic and the current values are a little dubious.

this is a debug feature so i'll do a backport of this fix for 2.6.23.1, 
once sched-devel.git goes into .24.

	Ingo
