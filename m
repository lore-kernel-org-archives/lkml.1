Return-Path: <linux-kernel-owner+w=401wt.eu-S933212AbXCZBOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbXCZBOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 21:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933298AbXCZBOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 21:14:10 -0400
Received: from mail28.syd.optusnet.com.au ([211.29.133.169]:39802 "EHLO
	mail28.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933212AbXCZBOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 21:14:09 -0400
From: Con Kolivas <kernel@kolivas.org>
To: tim.c.chen@linux.intel.com
Subject: Re: RSDL 0.31 causes slowdown
Date: Mon, 26 Mar 2007 11:13:47 +1000
User-Agent: KMail/1.9.5
Cc: Con Kolivas <ckolivas@gmail.com>, ck@vds.kolivas.org,
       linux-kernel@vger.kernel.org, wli@holomorphy.com,
       suresh.b.siddha@intel.com, arjan@infradead.org
References: <1174598506.23795.62.camel@localhost.localdomain> <8cd998d50703221940naec0905y56ec708eb11b81a2@mail.gmail.com> <1174672650.23795.67.camel@localhost.localdomain>
In-Reply-To: <1174672650.23795.67.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703261113.47681.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 March 2007 04:57, Tim Chen wrote:
> On Fri, 2007-03-23 at 13:40 +1100, Con Kolivas wrote:
> > Volanomark is a purely yield() semantic dependant workload (as
> > discussed many times previously). In the earlier form of RSDL I
> > softened the effect of sched_yield but other changes since then have
> > made that softness bordering on a noop. Obviously when sched_yield is
> > relied upon that will not be enough. Extending the rr interval simply
> > makes the yield slightly more effective and is not the proper
> > workaround. Since expiration of arrays is a regular frequent
> > occurrence in RSDL then changing yield semantics back to expiration
> > should cause a massive improvement in these values, without making the
> > yields as long as in mainline. It's impossible to know exactly what
> > the final result will be since java uses this timing sensitive yield
> > for locking but we can improve it drastically from this. I'll make a
> > patch soon to change yield again.
>
> Con,
>
> The new RSDL 0.33 has fully recovered the loss in performance for
> Volanomark.  The throughput for Volanomark is at the same level as
> mainline 2.6.21-rc4 kernel.
>
> Tim

Thanks very much for testing. I'm quite happy with the yield semantics staying 
the way they are in rSDl 0.33+.

-- 
-ck
