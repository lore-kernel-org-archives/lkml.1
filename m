Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZA3Kk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZA3Kk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZA3Kkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:40:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:57606 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZA3Kkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:40:46 -0500
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
 scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Nathanael Hoyle <nhoyle@hoyletech.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1233311516.6280.4.camel@marge.simson.net>
References: <1233294584.28741.2.camel@localhost>
	 <1233305433.4495.154.camel@laptop>  <1233306030.17301.36.camel@localhost>
	 <1233306223.4495.159.camel@laptop>  <1233310700.7816.7.camel@localhost>
	 <1233311516.6280.4.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 11:40:42 +0100
Message-Id: <1233312042.4495.167.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 11:31 +0100, Mike Galbraith wrote:
> On Fri, 2009-01-30 at 05:18 -0500, Nathanael Hoyle wrote:
> 
> > Ok, I'm now running:
> > 
> > Linux nightmare 2.6.28.2-nhoyle #1 SMP Fri Jan 30 04:50:03 EST 2009
> > x86_64 Intel(R) Core(TM)2 Quad CPU Q9450 @ 2.66GHz GenuineIntel
> > GNU/Linux
> > 
> > Initial conclusion is that whatever defects were corrected (non
> > SCHED_IDLE specific defects that is), the newer kernel version does the
> > trick.  Video playback is as smooth as ever when running foldingathome
> > at simple nice 19 priority.
> 
> Good to hear, thanks for testing.
> 
> Peter, since 27 is a long term maintenance kernel, do you think 1af5f73
> and 046e7f7 (at least) are 27.stable candidates?

1af5f730fc1bf7c62ec9fb2d307206e18bf40a69 and
e17036dac189dd034c092a91df56aa740db7146d you mean?

I guess that makes sense.

