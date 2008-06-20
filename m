Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbYFTP5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbYFTP5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759137AbYFTP4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:56:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35000 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759035AbYFTP4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:56:42 -0400
Date: Fri, 20 Jun 2008 17:55:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Ellingsworth <david@identd.dyndns.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH/RFC] remove irqs_disabled warning from local_bh_enable
Message-ID: <20080620155541.GC6656@elte.hu>
References: <1213739834.3803.137.camel@johannes.berg> <20080620134637.GA8135@elte.hu> <20080620152748.GA21245@elte.hu> <200806201736.23916.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806201736.23916.mb@bu3sch.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Michael Buesch <mb@bu3sch.de> wrote:

> On Friday 20 June 2008 17:27:48 Ingo Molnar wrote:
> >  [<c012b361>] local_bh_enable_ip+0xd1/0xe0
> >  [<c08d9f9f>] _spin_unlock_bh+0x2f/0x40
> >  [<c0471b92>] vortex_timer+0xe2/0x3e0
> 
> > real bug or false positive?
> 
> Well, a timer runs with IRQs disabled, no? So this would be a bug.

indeed - agreed :) [no time for me to fix it, but can test any rfc patch.]

so score +1 for Johannes's patch. I think if it works out fine and there 
are no false positives in further testing i'll put it up for pull into 
v2.6.26 as well, as it is catching real bugs.

	Ingo
