Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbZANHgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbZANHgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759468AbZANHfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:35:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44820 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbZANHfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:35:46 -0500
Date: Wed, 14 Jan 2009 08:35:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Brian Rogers <brian@xyzw.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] How to get real-time priority using idle priority
Message-ID: <20090114073530.GA15644@elte.hu>
References: <4969D0D7.2060401@xyzw.org> <1231736941.6003.7.camel@marge.simson.net> <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu> <496BE8F6.1040308@xyzw.org> <1231815523.5899.7.camel@marge.simson.net> <1231910014.610.14.camel@marge.simson.net> <20090114053106.GA10410@elte.hu> <1231912965.956.11.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231912965.956.11.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Wed, 2009-01-14 at 06:31 +0100, Ingo Molnar wrote:
> > What about increasing the weight of SCHED_IDLE tasks from 1 to 2 or 3? 
> > That still makes them mega-nice (which is more than enough), but should 
> > make the math a lot less borderline.
> 
> The weight is currently 2, inv_weight is 1 << 31, which is correct.

then move it up to 5 or so perhaps? We are hitting limits of 64-bit math 
here.

	Ingo
