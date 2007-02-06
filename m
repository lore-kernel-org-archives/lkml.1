Return-Path: <linux-kernel-owner+w=401wt.eu-S933177AbXBFSls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbXBFSls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933179AbXBFSls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:41:48 -0500
Received: from mail.dbd-breitband.de ([217.188.211.21]:1996 "EHLO
	dbd-mpx01.dbd-breitband.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933177AbXBFSlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:41:47 -0500
From: Marc Donner <donner@dbd-breitband.de>
Organization: DBD DeutscheBreitbandDienste
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: cpu load balancing problem on smp
Date: Tue, 6 Feb 2007 19:41:32 +0100
User-Agent: KMail/1.9.5
References: <200702061832.17771.donner@dbd-breitband.de> <1170785364.7324.31.camel@laptopd505.fenrus.org>
In-Reply-To: <1170785364.7324.31.camel@laptopd505.fenrus.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702061941.32907.donner@dbd-breitband.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 February 2007 19:09, you wrote:
> On Tue, 2007-02-06 at 18:32 +0100, Marc Donner wrote:
> > Hi @all
> >
> > we have detected some problems on our live systems and so i have build a
> > test setup in our lab as follow:
> >
> > 3 Core 2 duo servers, each with 2 CPUs,  with GE interfaces. 2 of them
> > are only for generating network traffic. the 3rd server is the one i want
> > to test. it is connected over two GE links to the other servers. the
> > testserver is configured as an ip router. running kernel 2.6.20.
> >
> > now if i  let traffic flow over the box, about 600Mbit/s and about 120k
> > packets/s all seems to be ok. the load is balanced over all cpus. if now
> > insert some iptables rules, about 500, the softirq load increases, but
> > all seems to be ok. now i insert some rules more, and suddenly 1 CPU is
> > 100% loaded and the other ones are 99% idle. the load toggles now between
> > the cpus in intervals.
>
> I wonder if you are using irqbalance.. if not you probably want to...
> (this should at least split it over 2 cpus)
>
> see http://www.irqbalance.org to get irqbalance

I now have tried irqloadbalance, but the same problem.
