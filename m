Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbZCIGw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbZCIGw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 02:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZCIGwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 02:52:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbZCIGwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 02:52:46 -0400
Date: Mon, 9 Mar 2009 07:52:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Balazs Scheidler <bazsi@balabit.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: scheduler oddity [bug?]
Message-ID: <20090309065238.GB7057@elte.hu>
References: <1236448069.16726.21.camel@bzorp.balabit> <1236505323.6281.57.camel@marge.simson.net> <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu> <1236529200.7110.16.camel@marge.simson.net> <20090308175255.GA22802@elte.hu> <1236537580.7094.8.camel@marge.simson.net> <20090308185518.GB28169@elte.hu> <1236571851.15543.13.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236571851.15543.13.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Sun, 2009-03-08 at 19:55 +0100, Ingo Molnar wrote:
> 
> > btw., there's room for a cleanup + micro-optimization here too: 
> > it would be nice to change se.last_wakeup and 
> > se.prev_sum_exec_runtime to be the same variable, 
> > se.prev_timestamp or so.
> 
> I don't see how they can meld without breaking 
> check_preempt_tick() all to pieces.

hm, indeed.

	Ingo
