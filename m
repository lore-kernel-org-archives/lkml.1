Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbYJHHET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbYJHHET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 03:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYJHHEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 03:04:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:39484 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbYJHHEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 03:04:09 -0400
Subject: Re: [Bug #11207] VolanoMark regression with 2.6.27-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Miao Xie <miaox@cn.fujitsu.com>
In-Reply-To: <1223433391.1685.19.camel@ymzhang>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.S8B.b975IB@wind>
	 <200810080211.42210.nickpiggin@yahoo.com.au>
	 <1223394526.26330.52.camel@lappy.programming.kicks-ass.net>
	 <1223433391.1685.19.camel@ymzhang>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 09:03:56 +0200
Message-Id: <1223449437.1378.19.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 10:36 +0800, Zhang, Yanmin wrote:

> > Sadly not much, I can't seem to reproduce :-(
> The regression is bigger with more cpu.

Yep :-(

> > 
> > Yanmin, does the wakeup patch I did for oltp help this workload any?
> > 
> > http://marc.info/?l=linux-kernel&m=122194673932703&w=4
> I tested it against 2.6.29-rc9 on 8-core stoakley and 16-core tigerton. volanoMark
> chatroom number is default 10.
> Basically, comparing with pure 2.6.27-rc9, the patched kernel's result has about 2%
> regression. Group scheduling is enabled.

Ok, so that didn't help. Thanks for testing!

