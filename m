Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbXCaJng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbXCaJng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 05:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbXCaJng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 05:43:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35999 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbXCaJnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 05:43:35 -0400
Date: Sat, 31 Mar 2007 11:43:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Xenofon Antidides <xantidides@yahoo.gr>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [test] hackbench.c interactivity results: vanilla versus SD/RSDL
Message-ID: <20070331094323.GA5550@elte.hu>
References: <1175322706.6030.20.camel@Homer.simpson.net> <20070331092857.12651.qmail@web26704.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331092857.12651.qmail@web26704.mail.ukl.yahoo.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Xenofon Antidides <xantidides@yahoo.gr> wrote:

> [...] I cannot play wine games with audio, I cannot sample video, I 
> cannot use skype, I cannot play midi. And even linux only things I try 
> do I cannot share my X, I cannot use more than one vmware. [...]

strange - i can do such things (and other things) with the vanilla 
scheduler (except vmware which i dont run). It would be nice to debug 
your 'cannot play midi' problem for example - could you try to describe 
it a bit more accurately so that we can try to reproduce it and fix it? 
(in the alternative i can send you tracing patches to capture what the 
scheduler does and how)

also, could you possibly try these workloads you described with Mike's 
latest patch too? Thanks,

	Ingo
