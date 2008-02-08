Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbYBHW1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbYBHW1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbYBHW0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:26:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58985 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749AbYBHW0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:26:50 -0500
Date: Fri, 8 Feb 2008 23:26:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix sparse warning from include/linux/mmzone.h
Message-ID: <20080208222637.GA2989@elte.hu>
References: <1202417543.31361.5.camel@brick> <20080208135154.ccdac0c1.akpm@linux-foundation.org> <alpine.LFD.1.00.0802081401410.2896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802081401410.2896@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Heh, yeah. That's a very odd way to write it.
> 
> It would probably make more sense to just write it as something like
> 
> 	struct zone *base = zone->zone_pgdat->node_zones;
> 
> 	if (zone == base + ZONE_HIGHMEM ||
> 		(zone == base + ZONE_MOVABLE && zone_movable_is_highmem());
> 
> instead.

missing closing parenthesis ;-)

btw., doesnt this look even nicer?:

     if (zone == base + ZONE_HIGHMEM ||
        (zone == base + ZONE_MOVABLE && zone_movable_is_highmem()));

[ i guess it must be Friday... ;-) ]

	Ingo
