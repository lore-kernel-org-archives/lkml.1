Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbXHCIeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbXHCIeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 04:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbXHCIem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 04:34:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:48935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbXHCIek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 04:34:40 -0400
To: Matt Mackall <mpm@selenic.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Roman Zippel <zippel@linux-m68k.org>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
References: <20070711214649.GK14435@v2.random>
	<alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
	<Pine.LNX.4.64.0707130415520.1818@scrub.home>
	<1184302024.6709.11.camel@Homer.simpson.net>
	<Pine.LNX.4.64.0707131728070.1817@scrub.home>
	<1184389456.6632.13.camel@Homer.simpson.net>
	<Pine.LNX.4.64.0708010439050.1817@scrub.home>
	<20070801112229.GA11710@elte.hu> <20070803030436.GO11166@waste.org>
	<1186113467.3996.0.camel@laptopd505.fenrus.org>
	<20070803043800.GE11115@waste.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 03 Aug 2007 11:29:10 +0200
In-Reply-To: <20070803043800.GE11115@waste.org>
Message-ID: <p73odhpm0ex.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall <mpm@selenic.com> writes:
> 
> Indeed. I'm just pointing out that not having TSC, fast HZ, no-HZ
> mode, or high-res timers should not be treated as an unusual
> circumstance. That's a PC-centric view.

The question is if it would be that hard to add TSC equivalent
sched_clock() support to more systems. At least a lot of CPUs I have
ever looked at had some kind of fast clock available. Perhaps it's
more laziness of the developers or cut'n'paste that these are not as
widely used as they should be?

-Andi
