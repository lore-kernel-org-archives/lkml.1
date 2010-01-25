Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155Ab0AYOD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0AYOD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769Ab0AYOD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:03:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:40318 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab0AYOD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:03:57 -0500
Subject: Re: netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1264413826.3642.88.camel@minggr.sh.intel.com>
References: <1264413826.3642.88.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 15:03:49 +0100
Message-ID: <1264428229.4283.1833.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 18:03 +0800, Lin Ming wrote:
> Hi, 
> 
> The netperf lookback regression comes back again.
> UDP stream test has ~50% regression with 2.6.33-rc1 compared to 2.6.32.
> 
> Testing machine: Nehalem, 2 sockets, 4 cores, hyper thread, 4G mem
> Server and client are bind to different physical cpu. 
> 
> taskset -c 15 ./netserver
> taskset -c 0 ./netperf -t UDP_STREAM -l 60 -H 127.0.0.1 -i 50,3 -I 99,5
> -- -P 12384,12888 -s 32768 -S 32768 -m 1024

I cannot reproduce this on a dual socket nehalem system, I get current
-linus to be about 10% faster than .32.

(Had to drop the -i -I thingies, otherwise this took ages)

