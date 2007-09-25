Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbXIYMzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbXIYMzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXIYMy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:54:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:39548 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751333AbXIYMy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:54:57 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/6xAJJyor6tDoMZ3OaT/VxIwUuh52nmXC/jY4HMk
	h/cRWFj+zsxBeY
Subject: Re: [git] CFS-devel, latest code
From: Mike Galbraith <efault@gmx.de>
To: vatsa@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1190723327.7112.5.camel@Homer.simpson.net>
References: <20070924214537.GA18980@elte.hu>
	 <1190700652.6482.7.camel@Homer.simpson.net>
	 <1190705759.11910.10.camel@Homer.simpson.net>
	 <1190709207.11226.6.camel@Homer.simpson.net>
	 <20070925091331.GA22905@elte.hu>
	 <20070925094440.GK26289@linux.vnet.ibm.com>
	 <20070925094040.GA28391@elte.hu> <20070925101044.GA923@elte.hu>
	 <20070925102855.GL26289@linux.vnet.ibm.com>
	 <1190723327.7112.5.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 14:54:53 +0200
Message-Id: <1190724893.13716.8.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 14:28 +0200, Mike Galbraith wrote:
> On Tue, 2007-09-25 at 15:58 +0530, Srivatsa Vaddagiri wrote:
> 
> > While I try recreating this myself, I wonder if this patch helps?
> 
> It didn't here, nor did tweaking root's share.  Booting with maxcpus=1,
> I was unable to produce large latencies, but didn't try very many
> things.

Easy way to make it pretty bad: pin a nice 0 loop to CPU0, pin a nice 19
loop to CPU1, then start an unpinned make.. more Xorg bouncing back and
forth I suppose.

se.wait_max              :            14.105683
se.wait_max              :           316.943787
se.wait_max              :           692.884324
se.wait_max              :            38.165534
se.wait_max              :           732.883492
se.wait_max              :           127.059784
se.wait_max              :            63.403549
se.wait_max              :           372.933284

	-Mike

