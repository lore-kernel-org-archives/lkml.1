Return-Path: <linux-kernel-owner+w=401wt.eu-S1759930AbXEVGSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbXEVGSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 02:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbXEVGSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 02:18:22 -0400
Received: from d0618453.dreamhost.com ([208.97.132.83]:53558 "EHLO
	spaceymail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756187AbXEVGSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 02:18:21 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: bad networking related lag in v2.6.22-rc2
Date: Tue, 22 May 2007 11:47:55 +0530
User-Agent: KMail/1.9.6
Cc: Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
References: <20070517174533.GA538@elte.hu> <465208D2.6070409@trash.net> <46520F77.5000408@trash.net>
In-Reply-To: <46520F77.5000408@trash.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705221147.56571.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 May 2007 03:00:31 Patrick McHardy wrote:
> Patrick McHardy wrote:
> > Ingo Molnar wrote:
> >>* Anant Nitya <kernel@prachanda.info> wrote:
> >>>I am posting links to the information you asked for. One more thing,
> >>>after digging a bit more I found its QoS shaping that is making the
> >>>box crawl. Once I disabled the traffic shaping everything comes back
> >>>to smooth and normal. Shaping being done on very low speed residential
> >>>ADSL 256/64 Kbps connection. If you want me to post shaping rules,
> >>>please free to ask. BTW its a simple HTB/SFQ rules.
> >>
> >>[...]
> >>
> >>>http://cybertek.info/taitai/trace-to-ingo.txt.bz2
> >>
> >>thanks! This trace indeed includes the smoking gun, htb_dequeue() and
> >>__qdisc_run():
> >>
> >>[..]
> >
> > This looks like fallout from the switch to hrtimers. Anant, please
> > send me your HTB script, I'll try to reproduce it.
>
> I think I already found the bug, please try if this patch helps.

Sorry, but this patch is not helping here. I recompiled the kernel with this 
patch but same load pattern still make system to crawl.

Here is the link for script I use to shape traffic.

http://cybertek.info/taitai/adslbwopt.sh

Regards
Ananitya

-- 
Out of many thousands, one may endeavor for perfection, and of
those who have achieved perfection, hardly one knows Me in truth.
				-- Gita Sutra Of Mysticism
