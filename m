Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYGGGnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYGGGnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYGGGn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:43:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40297 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYGGGn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:43:28 -0400
Date: Mon, 7 Jul 2008 08:42:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
Message-ID: <20080707064227.GA27622@elte.hu>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <uBi7uNfg81L.A.XLC.s0LcIB@albercik> <20080706111750.a6d77e81.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080706111750.a6d77e81.randy.dunlap@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> This still happens with 2.6.26-rc9.  Using CONFIG_NUMA=y boots OK.

one thing i dont see you having followed up on is whether tip/master 
works fine:

  http://lkml.org/lkml/2008/6/11/355

(or, whether linux-next works fine with the same !NUMA config.)

i.e. whether this is a genuine new problem or something we already 
fixed. (just didnt realize the upstream relevance of)

( if tip/master works fine then it would be very useful to do an 
  'inverse bisection' for the fix. )

	Ingo
