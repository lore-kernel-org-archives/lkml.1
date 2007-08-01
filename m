Return-Path: <linux-kernel-owner+w=401wt.eu-S1763923AbXHAMZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763923AbXHAMZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761842AbXHAMZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:25:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:40275 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761195AbXHAMZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:25:39 -0400
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
	<20070711211638.GE18767@one.firstfloor.org>
	<20070711214649.GK14435@v2.random>
	<alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
	<Pine.LNX.4.64.0707130415520.1818@scrub.home>
	<1184302024.6709.11.camel@Homer.simpson.net>
	<Pine.LNX.4.64.0707131728070.1817@scrub.home>
	<1184389456.6632.13.camel@Homer.simpson.net>
	<Pine.LNX.4.64.0708010439050.1817@scrub.home>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Aug 2007 15:20:12 +0200
In-Reply-To: <Pine.LNX.4.64.0708010439050.1817@scrub.home>
Message-ID: <p73wswfo0hf.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel <zippel@linux-m68k.org> writes:

> especially if one already knows that
> scheduler clock has only limited resolution (because it's based on
> jiffies), it becomes possible to use mostly 32bit values.

jiffies based sched_clock should be soon very rare. It's probably
not worth optimizing for it.

-Andi
