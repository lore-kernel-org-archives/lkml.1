Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbXLFUos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbXLFUos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXLFUol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:44:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbXLFUol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:44:41 -0500
Date: Thu, 6 Dec 2007 21:44:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com
Subject: Re: [PATCH 3/3] printer port driver: semaphore to mutex
Message-ID: <20071206204402.GC23375@elte.hu>
References: <20071206021857.826386004@mvista.com> <20071206021909.131993721@mvista.com> <20071206102334.GE17299@elte.hu> <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>
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


* Daniel Walker <dwalker@mvista.com> wrote:

> > cool. How far away are we from being able to remove all the 
> > semaphore code? :-)
> 
> I wish my 7 patches made a dent, but it's hasn't done much. ;(

it's a beginning.

> I would guess at least a week just to mop up the relatively easy 
> ones.. I've got 12 in my queue, and there still ~50 hopefully trivial 
> ones still to be looked at.. Then another ~30 more difficult ones 
> (that use init_MUTEX_LOCKED, or sema_init with 0 instead of 1) ..

With BKL removal being projected to happen between 5 and 10 years from 
now, i think you are moving at lightning's pace :-)

	Ingo
