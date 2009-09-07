Return-Path: <linux-kernel-owner+w=401wt.eu-S1751086AbZIGGyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086AbZIGGyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 02:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbZIGGyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 02:54:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:59541 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750778AbZIGGyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 02:54:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX181NGYdlqs18IkOcmK15Qp6PtgEBy85/jM83CuqNY
	2RdT3VnUiSfv8o
Subject: RE: question on sched-rt group allocation cap: sched_rt_runtime_us
From: Mike Galbraith <efault@gmx.de>
To: Anirban Sinha <ASinha@zeugmasystems.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C54DC483@exchange.ZeugmaSystems.local>
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it>
	 <dhcf5-263-13@gated-at.bofh.it>
	 <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com>
	 <1252218779.6126.17.camel@marge.simson.net>
	 <DDFD17CC94A9BD49A82147DDF7D545C54DC483@exchange.ZeugmaSystems.local>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 08:54:46 +0200
Message-Id: <1252306486.7423.72.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-06 at 17:18 -0700, Anirban Sinha wrote:
> 
> 
> > Dunno.  Fly or die little patchlet (toss).
> 
> > sched: allow the user to disable RT bandwidth aggregation.
> 
> Hmm. Interesting. With this change, my results are as follows:
> 
> rt_runtime/rt_period   % of reg iterations
> 
> 0.2                    100%
> 0.25                   100%
> 0.3                    100%
> 0.4                    100%
> 0.5                    82%
> 0.6                    66%
> 0.7                    54%
> 0.8                    46%
> 0.9                    38.5%
> 0.95                   32%
> 
> 
> This results are on a quad core blade. Does it still makes sense
> though?
> Can anyone else run the same tests on a quadcore over the latest
> kernel? I will patch our 2.6.26 kernel with upstream fixes and rerun
> these tests on tuesday.

I tested tip (v2.6.31-rc9-1357-ge6a3cd0) with a little perturbation
measurement proglet on an isolated Q6600 core.

10s measurement interval results:

sched_rt_runtime_us  RT utilization
950000               94.99%
750000               75.00%
500000               50.04%
250000               25.02%
 50000                5.03%

Seems to work fine here.

	-Mike

