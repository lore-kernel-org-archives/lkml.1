Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbXLHT4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbXLHT4j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 14:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbXLHT40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 14:56:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51355 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbXLHT4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 14:56:25 -0500
Date: Sat, 8 Dec 2007 20:55:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071208195532.GB579@elte.hu>
References: <200712080340.49546.rjw@sisk.pl> <20071208014241.f4b138e0.akpm@linux-foundation.org> <20071208194042.GO17037@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071208194042.GO17037@thunk.org>
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


* Theodore Tso <tytso@mit.edu> wrote:

> I am very happily running with Ingo's "snd hda suspend latency: 
> shorten codec read" patch, which was originally intended to speed up 
> resuming from hibernation, but which as I discovered, also has the 
> nice side effect of eliminating the reported error.
> 
> On 11/23, Takashi replied to my note 
> (http://lkml.org/lkml/2007/11/23/17) and suggested that Jaroslav push 
> this patch to Linus immediately instead of waiting for 2.6.25, since 
> it appearly solves two problems with one stone.  However, I just 
> checked, as of Linus's public, and Ingo's patch is *not* in mainline.
> 
> However, as far as I am concerned, Ingo's patch, first posted to LKML 
> here: http://lkml.org/lkml/2007/11/16/66 should be listed as fixing 
> the above regression.  Rafael, could you please make a note of this in 
> your regression list, and could we please get this patch pushed into 
> mainline?

ha! I'd never have expected _that_ to happen. Cool. Fixing a driver bug 
by accident :-)

	Ingo
