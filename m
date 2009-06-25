Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbZFYPGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbZFYPGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZFYPFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:05:54 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:26372 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbZFYPFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:05:53 -0400
X-IronPort-AV: E=Sophos;i="4.42,290,1243814400"; 
   d="scan'208";a="331665954"
From: Roland Dreier <rdreier@cisco.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
References: <1245760130.3776.6.camel@localhost.localdomain>
	<20090623195656.GC8777@elte.hu>
	<1245876060.3038.7.camel@localhost.localdomain>
	<alpine.LFD.2.00.0906242253270.2767@localhost.localdomain>
	<20090625092409.GC23547@elte.hu>
	<alpine.LFD.2.00.0906251445200.2767@localhost.localdomain>
	<1245936216.5308.43.camel@hpdv5.satnam>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 25 Jun 2009 08:05:55 -0700
In-Reply-To: <1245936216.5308.43.camel@hpdv5.satnam> (Jaswinder Singh Rajput's
	message of "Thu, 25 Jun 2009 18:53:36 +0530")
Message-ID: <ada7hz0l5f0.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Jun 2009 15:05:56.0077 (UTC) FILETIME=[70B0A1D0:01C9F5A6]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > This still looks ugly and lines are again long check for
 > 'L1-dcache-prefetch-misses' and does not solve the purpose :
 > 
 >  Performance counter stats for 'ls -lR /usr/include/':
 >  
 >       254259235  L1-dcache-loads       (scaled from 22.69%)
 >         1129360  L1-dcache-load-misses  (scaled from 23.05%)
 >          151929  L1-dcache-stores      (scaled from 22.94%)
 >          395089  L1-dcache-prefetches  (scaled from 23.30%)
 >          273699  L1-dcache-prefetch-misses  (scaled from 23.19%)
 >       253780608  L1-icache-loads       (scaled from 23.07%)
 >         4014781  L1-icache-load-misses  (scaled from 23.16%)

But even the longest line there (dcache-prefetch-misses) is only 64
columns long, so you could just align the "(scaled" part a little
further to the right and keep the output under, say, 72 columns.

 - R.
