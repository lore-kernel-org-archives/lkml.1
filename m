Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbZFZHZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbZFZHZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZFZHZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:25:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55205 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbZFZHZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:25:12 -0400
Date: Fri, 26 Jun 2009 09:25:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH] x86: tsc based udelay should have rdtsc_barrier
Message-ID: <20090626072504.GJ14078@elte.hu>
References: <20090625234431.GC29401@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625234431.GC29401@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:

> 
> delay_tsc needs rdtsc_barrier to provide proper delay.
> 
> Output from a test driver using hpet to cross check delay
> provided by udelay().
> 
> Before:
> [   86.794363] Expected delay 5us actual 4679ns
> [   87.154362] Expected delay 5us actual 698ns
> [   87.514162] Expected delay 5us actual 4539ns
> [   88.653716] Expected delay 5us actual 4539ns
> [   94.664106] Expected delay 10us actual 9638ns
> [   95.049351] Expected delay 10us actual 10126ns
> [   95.416110] Expected delay 10us actual 9568ns
> [   95.799216] Expected delay 10us actual 9638ns
> [  103.624104] Expected delay 10us actual 9707ns
> [  104.020619] Expected delay 10us actual 768ns
> [  104.419951] Expected delay 10us actual 9707ns
> 
> After:
> [   50.983320] Expected delay 5us actual 5587ns
> [   51.261807] Expected delay 5us actual 5587ns
> [   51.565715] Expected delay 5us actual 5657ns
> [   51.861171] Expected delay 5us actual 5587ns
> [   52.164704] Expected delay 5us actual 5726ns
> [   52.487457] Expected delay 5us actual 5657ns
> [   52.789338] Expected delay 5us actual 5726ns
> [   57.119680] Expected delay 10us actual 10755ns
> [   57.893997] Expected delay 10us actual 10615ns
> [   58.261287] Expected delay 10us actual 10755ns
> [   58.620505] Expected delay 10us actual 10825ns
> [   58.941035] Expected delay 10us actual 10755ns
> [   59.320903] Expected delay 10us actual 10615ns
> [   61.306311] Expected delay 10us actual 10755ns
> [   61.520542] Expected delay 10us actual 10615ns

Nice fix!

	Ingo
