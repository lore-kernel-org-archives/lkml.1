Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbZLOHmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbZLOHmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZLOHmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:42:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45764 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756589AbZLOHmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:42:18 -0500
Date: Tue, 15 Dec 2009 08:42:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: upstream regression: slob hang
Message-ID: <20091215074206.GA4227@elte.hu>
References: <20091210084949.GA18015@elte.hu>
 <4B268366.6090207@cs.helsinki.fi>
 <1260815761.24459.1434.camel@calx>
 <1260859518.4770.4.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260859518.4770.4.camel@penberg-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Ingo Molnar wrote:
> > > > FYI, the attached config hangs in the SLOB code, on 32-bit x86 laptop 
> > > > (dual core). No log available from that box.
> 
> On Mon, 2009-12-14 at 20:26 +0200, Pekka Enberg wrote:
> > > Boots fine on my 32-bit x86 laptop.
> 
> On Mon, 2009-12-14 at 12:36 -0600, Matt Mackall wrote:
> > Thanks, Pekka. I've been too busy to experiment with this. Ingo,
> > anything interesting about your laptop? How much memory do you have?
> 
> Side note: SLOB hasn't really changed for a while so I suspect Ingo is 
> hitting some once in a blue moon type of old bug.

That's possible - although as of late i'm generally finding new regressions, 
the old once-in-a-blue-moon races i've triggered already. (the roughly half a 
million random bootups i've done in the last 2 years in -tip testing went a 
long way in rooting them out)

I'll try to figure this one out in a few days hopefully - the laptop is not 
available for testing right now for other reasons.

	Ingo
