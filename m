Return-Path: <linux-kernel-owner+w=401wt.eu-S932270AbZJFMFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbZJFMFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932256AbZJFMFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:05:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:60604 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbZJFMFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:05:03 -0400
Subject: Re: find_busiest_group using lots of CPU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <20091006112006.GO5216@kernel.dk>
References: <20090930081811.GP23126@kernel.dk>
	 <1254745898.26976.52.camel@twins> <20091006075127.GF5216@kernel.dk>
	 <20091006112006.GO5216@kernel.dk>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 14:04:21 +0200
Message-Id: <1254830661.21044.275.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 13:20 +0200, Jens Axboe wrote:
> > > io_schedule() straight into find_busiest_group() leads me to think this
> > > could be SD_BALANCE_NEWIDLE, does something like:
> > > 
> > > for i in /proc/sys/kernel/sched_domain/cpu*/domain*/flags; 
> > > do 
> > >     val=`cat $i`; echo $((val & ~0x02)) > $i; 
> > > done
> > > 
> > > [ assuming SCHED_DEBUG=y ]
> > > 
> > > Cure things?
> > 
> > I can try,
> 
> It does, it's gone from the profiles.

Hrmm,. ok. I'll go prod at the NEWIDLE bits to see if anything stands
out.

If only perf-annotate could generate annotated C... maybe I'll look at
that.

Thanks!

