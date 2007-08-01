Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbXHAQPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbXHAQPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbXHAQPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:15:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:48946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbXHAQPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:15:43 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
References: <20070711211638.GE18767@one.firstfloor.org>
	<20070711214649.GK14435@v2.random>
	<alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
	<Pine.LNX.4.64.0707130415520.1818@scrub.home>
	<1184302024.6709.11.camel@Homer.simpson.net>
	<Pine.LNX.4.64.0707131728070.1817@scrub.home>
	<1184389456.6632.13.camel@Homer.simpson.net>
	<Pine.LNX.4.64.0708010439050.1817@scrub.home>
	<20070801071230.GA16375@elte.hu>
	<Pine.LNX.4.64.0708011511530.1817@scrub.home>
	<20070801150742.GA23670@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Aug 2007 19:10:15 +0200
In-Reply-To: <20070801150742.GA23670@elte.hu>
Message-ID: <p73ps27npu0.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> thanks. Just to make sure, while you said that your TSC was off on that 
> laptop, the bootup log of yours suggests a working TSC:
> 
>   Time: tsc clocksource has been installed.

Standard kernels often disable the TSC later after running a bit 
with it (e.g. on any cpufreq change without p state invariant TSC) 

-Andi
