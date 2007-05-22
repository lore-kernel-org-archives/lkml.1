Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbXEVGVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbXEVGVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 02:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760810AbXEVGU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 02:20:56 -0400
Received: from d061844a.dreamhost.com ([208.97.132.74]:49986 "EHLO
	spaceymail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760226AbXEVGUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 02:20:55 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: bad networking related lag in v2.6.22-rc2
Date: Tue, 22 May 2007 11:50:34 +0530
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
References: <20070517174533.GA538@elte.hu> <200705211544.58018.kernel@prachanda.hub> <20070521102009.GA12196@elte.hu>
In-Reply-To: <20070521102009.GA12196@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705221150.35774.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 May 2007 15:50:09 Ingo Molnar wrote:
> * Anant Nitya <kernel@prachanda.info> wrote:
> > Tcp:
> >     5 connections established
>
> hm, this does not explain the /proc/net/tcp overhead i think - although
> it could be a red herring. Will have a closer look at your new trace.
>
> if possible please try to generate the automatic softirq trace for
> Thomas, and then a separate trace for the firefox/net-lag thing, using
> trace-it-10sec.c. Btw., for the second trace, could you boot with
> maxcpus=1? That would make the second trace quite a bit more
> straightforward to analyze. You probably need both cpus to trigger the
> softirq problem.
>
> 	Ingo

here is the link for new trace with maxcpus=1.
http://cybertek.info/taitai/trace-it-10sec-to-ingo-with-maxcpus=1.bz2

Regards
Ananitya

-- 
Out of many thousands, one may endeavor for perfection, and of
those who have achieved perfection, hardly one knows Me in truth.
				-- Gita Sutra Of Mysticism
