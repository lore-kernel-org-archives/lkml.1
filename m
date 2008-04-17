Return-Path: <linux-kernel-owner+w=401wt.eu-S1760533AbYDQIk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760533AbYDQIk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbYDQIkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:40:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44661 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbYDQIkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:40:17 -0400
Date: Thu, 17 Apr 2008 10:40:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080417084006.GA10379@elte.hu>
References: <20080416202338.GA6007@elte.hu> <20080417002552.5742ad65.akpm@linux-foundation.org> <84144f020804170045s24cbb802u3358ec6b5d391a10@mail.gmail.com> <20080417012051.ed56f4ab.akpm@linux-foundation.org> <Pine.LNX.4.64.0804171130090.4929@sbz-30.cs.Helsinki.FI> <84144f020804170134k4c98f022xc247442592fb1a44@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020804170134k4c98f022xc247442592fb1a44@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Thu, Apr 17, 2008 at 11:32 AM, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> >  Oh sorry, I guess I fixed up problems I spot myself. There indeed 
> >  seem to be some comments by Andrew that have not been addressed:
> 
> s/have not/might have not/
> 
> >   http://lkml.org/lkml/2008/2/23/68

at a quick glance most of the fundamental ones are addressed (it now 
uses per-cpu hrtimers, not the timer hook, etc.), but i'll go over it 
with a fine comb as well to make sure everything Andrew pointed out is 
addressed.

	Ingo
