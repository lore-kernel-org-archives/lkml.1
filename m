Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYANDO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYANDO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 22:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYANDOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 22:14:46 -0500
Received: from mga10.intel.com ([192.55.52.92]:60495 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751360AbYANDOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 22:14:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,279,1196668800"; 
   d="scan'208";a="499778899"
Subject: Re: Netperf TCP_RR(loopback) 10% regression in
	2.6.24-rc6,	comparing with 2.6.22
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Rick Jones <rick.jones2@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <4787ADDA.7090602@hp.com>
References: <1199871330.3298.132.camel@ymzhang>
	 <1200043854.3265.24.camel@ymzhang>  <4787ADDA.7090602@hp.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 14 Jan 2008 11:11:32 +0800
Message-Id: <1200280292.3151.24.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-11 at 09:56 -0800, Rick Jones wrote:
> >>The test command is:
> >>#sudo taskset -c 7 ./netserver
> >>#sudo taskset -c 0 ./netperf -t TCP_RR -l 60 -H 127.0.0.1 -i 50,3 -I 99,5 -- -r 1,1
> 
> A couple of comments/questions on the command lines:
Thanks for your kind comments.

> 
> *) netperf/netserver support CPU affinity within themselves with the 
> global -T option to netperf.  Is the result with taskset much different? 
>    The equivalent to the above would be to run netperf with:
> 
> ./netperf -T 0,7 ..
I checked the source codes and didn't find this option.
I use netperf V2.3 (I found the number in the makefile).

> .
> 
> The one possibly salient difference between the two is that when done 
> within netperf, the initial process creation will take place wherever 
> the scheduler wants it.
> 
> *) The -i option to set the confidence iteration count will silently cap 
> the max at 30.
Indeed, you are right.

-yanmin


