Return-Path: <linux-kernel-owner+w=401wt.eu-S1764828AbYCDPZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764828AbYCDPZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYCDPYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:24:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49650 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759460AbYCDPYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:24:50 -0500
Date: Tue, 4 Mar 2008 16:24:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark McLoughlin <markmc@redhat.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Ian Campbell <ijc@hellion.org.uk>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit v2
Message-ID: <20080304152422.GB6449@elte.hu>
References: <20080228131341.GA25213@mailshack.com> <1204232996.28798.8.camel@cthulhu.hellion.org.uk> <20080229114943.GA1909@mailshack.com> <1204305247.2037.2.camel@muff> <1204310323.24514.1239870063@webmail.messagingengine.com> <1204322819.6299.1.camel@muff> <20080301160911.GA13271@mailshack.com> <1204631082.16613.7.camel@muff> <20080304144915.GA4457@elte.hu> <1204643772.2774.9.camel@muff>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204643772.2774.9.camel@muff>
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


* Mark McLoughlin <markmc@redhat.com> wrote:

> > hm, for now i've only got the patch below queued up for v2.6.25.
> > 
> > Could you check whether just the patch below ontop of -rc3-ish 
> > upstream solves the problem too? The EBDA patch would be a bit risky 
> > now - it's queued up for v2.6.26 at the moment.
> 
> Sorry, perhaps I wasn't clear.
> 
> Ian's patch to add a hole in the e820 map fixes the problem without 
> any other patch.
> 
> I was just confirming to Alexander that his EBDA patch didn't break 
> anything further.

ah, great. You got me worried for a minute :)

	Ingo
