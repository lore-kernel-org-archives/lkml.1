Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZA3KcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZA3KcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZA3KcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:32:03 -0500
Received: from mail.gmx.net ([213.165.64.20]:37759 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751100AbZA3KcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:32:01 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18mqEMXFUgmwN2xduhN6sbBjXvJEhvmgOU2Tva4jT
	slKNch5MqE6xrr
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
	scheduling
From: Mike Galbraith <efault@gmx.de>
To: Nathanael Hoyle <nhoyle@hoyletech.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1233310700.7816.7.camel@localhost>
References: <1233294584.28741.2.camel@localhost>
	 <1233305433.4495.154.camel@laptop>  <1233306030.17301.36.camel@localhost>
	 <1233306223.4495.159.camel@laptop>  <1233310700.7816.7.camel@localhost>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 11:31:56 +0100
Message-Id: <1233311516.6280.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 05:18 -0500, Nathanael Hoyle wrote:

> Ok, I'm now running:
> 
> Linux nightmare 2.6.28.2-nhoyle #1 SMP Fri Jan 30 04:50:03 EST 2009
> x86_64 Intel(R) Core(TM)2 Quad CPU Q9450 @ 2.66GHz GenuineIntel
> GNU/Linux
> 
> Initial conclusion is that whatever defects were corrected (non
> SCHED_IDLE specific defects that is), the newer kernel version does the
> trick.  Video playback is as smooth as ever when running foldingathome
> at simple nice 19 priority.

Good to hear, thanks for testing.

Peter, since 27 is a long term maintenance kernel, do you think 1af5f73
and 046e7f7 (at least) are 27.stable candidates?

	-Mike



