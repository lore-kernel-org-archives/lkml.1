Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919Ab0AYOTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab0AYOTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173Ab0AYOTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:19:44 -0500
Received: from mail.gmx.net ([213.165.64.20]:53778 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750987Ab0AYOTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:19:44 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18B7VZeQBQBfZr/tMJ6Yv4wI1GD7krJTmLG9QmUAD
	8d5e/xB0/u9jvo
Subject: Re: netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1264428229.4283.1833.camel@laptop>
References: <1264413826.3642.88.camel@minggr.sh.intel.com>
	 <1264428229.4283.1833.camel@laptop>
Content-Type: text/plain
Date: Mon, 25 Jan 2010 15:19:39 +0100
Message-Id: <1264429179.5881.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 15:03 +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-25 at 18:03 +0800, Lin Ming wrote:
> > Hi, 
> > 
> > The netperf lookback regression comes back again.
> > UDP stream test has ~50% regression with 2.6.33-rc1 compared to 2.6.32.
> > 
> > Testing machine: Nehalem, 2 sockets, 4 cores, hyper thread, 4G mem
> > Server and client are bind to different physical cpu. 
> > 
> > taskset -c 15 ./netserver
> > taskset -c 0 ./netperf -t UDP_STREAM -l 60 -H 127.0.0.1 -i 50,3 -I 99,5
> > -- -P 12384,12888 -s 32768 -S 32768 -m 1024
> 
> I cannot reproduce this on a dual socket nehalem system, I get current
> -linus to be about 10% faster than .32.

Nogo here too, but no nice HW here.

	-Mike

