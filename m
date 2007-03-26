Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbXCZRjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbXCZRjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 13:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbXCZRjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 13:39:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42134 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbXCZRje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 13:39:34 -0400
Date: Mon, 26 Mar 2007 19:39:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       auke-jan.h.kok@intel.com, Adrian Bunk <bunk@stusta.de>
Subject: Re: -rc5: e1000 resume weirdness
Message-ID: <20070326173921.GA6921@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070326101153.GA4593@elte.hu> <4807377b0703260850g5b20df6eo5279760b5c10e946@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4807377b0703260850g5b20df6eo5279760b5c10e946@mail.gmail.com>
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


* Jesse Brandeburg <jesse.brandeburg@gmail.com> wrote:

> was there a "NETDEV WATCHDOG" message that follows this?  If not it is 
> a harmless debug print.  Note the time_stamp and jiffies difference, 
> very large, consistent with a resume.  I think we need to disable the 
> internal e1000 tx hang code that causes this debug print when we are 
> suspending.  I'll work with auke to generate a short patch.

there was no "NETDEV WATCHDOG" message. But still there was a ~30 
seconds delay until i got the first few packets through the interface - 
while normally it's available almost instantly after resume. But ... 
this condition seems sporadic, i havent seen it on subsequent 
suspend+resume attempts.

	Ingo
