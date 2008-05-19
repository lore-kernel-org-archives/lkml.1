Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbYESHLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbYESHLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 03:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbYESHKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 03:10:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45152 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbYESHKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 03:10:09 -0400
Subject: Re: [Bug #10638] sysbench+mysql(oltp, readonly) 30% regression
	with 2.6.26-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1211179767.3177.166.camel@ymzhang>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	 <7wuznNhcUqC.A.IMB.TtBMIB@albercik>
	 <1211131278.6463.7.camel@lappy.programming.kicks-ass.net>
	 <1211135856.6463.22.camel@lappy.programming.kicks-ass.net>
	 <1211160283.3177.134.camel@ymzhang>  <1211176540.8292.3.camel@twins>
	 <1211179767.3177.166.camel@ymzhang>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 May 2008 09:10:05 +0200
Message-Id: <1211181005.8292.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-19 at 14:49 +0800, Zhang, Yanmin wrote:

> I tested it on 8-core stoakley.
> 
> 1) volanoMark
> Comparing with 2.6.26-rc1, 2.6.26-rc3+peter_sched_git_patch result has about 30% improvement, but it still has
> about 27% regression than the one of 2.6.25.
> 
> 2) sysbench+mysql(readonly oltp)
> ﻿Comparing with 2.6.26-rc2, 2.6.26-rc3+peter_sched_git_patch result has about 15% improvement, but it still has
> about 15% regression than the one of 2.6.25.

Hmm, so both about halfways. When testing on a quad vmark got all the
way back but sysbench was indeed half way.

Ah, well. I'll just continue poking at this. Thanks!

