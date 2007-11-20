Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbXKTFrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbXKTFrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXKTFrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:47:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55956 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbXKTFrA (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:47:00 -0500
Date: Tue, 20 Nov 2007 06:46:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: pomac@vapor.com, Linux-kernel@vger.kernel.org
Subject: Re: [BUG?] OOM with large cache....(x86_64, 2.6.24-rc3-git1, nohz)
Message-ID: <20071120054648.GA20436@elte.hu>
References: <1195520355.8601.14.camel@localhost> <200711201513.36711.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711201513.36711.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Unfortunately, we don't show NR_ANON_PAGES in these stats, [...]

sidenote: the way i combat these missing pieces of instrumentation in 
the scheduler is to add them immediately to the cfs-debug-info.sh script 
(and to /proc/sched_debug if needed). I.e. if we get one report that 
misses a piece of critical information is OK, but if it's two reports 
and we still havent made it easy to report the right kind of information 
that is our fault entirely. This constant ping-ponging for information 
that goes on for basically every MM problem - which information could 
have been provided in the first message (by running a single, easy to 
download tool) is getting pretty hindering i believe.

	Ingo
