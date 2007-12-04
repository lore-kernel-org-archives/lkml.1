Return-Path: <linux-kernel-owner+w=401wt.eu-S1752405AbXLDGls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752405AbXLDGls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 01:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbXLDGll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 01:41:41 -0500
Received: from mga10.intel.com ([192.55.52.92]:41361 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751420AbXLDGlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 01:41:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,247,1194249600"; 
   d="scan'208";a="223077685"
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071203100554.GA30050@elte.hu>
References: <1196155985.25646.31.camel@ymzhang>
	 <200711301346.22573.nickpiggin@yahoo.com.au>
	 <1196392527.25646.65.camel@ymzhang>
	 <200711301429.15664.nickpiggin@yahoo.com.au>
	 <20071130100845.GB2201@elte.hu> <1196674170.25646.121.camel@ymzhang>
	 <20071203100554.GA30050@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Tue, 04 Dec 2007 14:40:13 +0800
Message-Id: <1196750413.25646.182.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-03 at 11:05 +0100, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > Although no source codes of volanoMark, I suspect it calls 
> > Thread.sched. volanoMark is a kind of chatroom benchmark. When a 
> > client sends out a message, server will send the message to all 
> > clients. I suspect the client calls Thread.yield after sending out a 
> > couple of messages.
> 
> yeah, so far only volanomark seems to be affected by this, and if it 
> indeed calls Thread.yield artificially it's a pretty stupid benchmark 
> and it's not the fault of the JDK. If we had the source to volanomark we 
> could fix this easily.
> 
> > 2 JVM all have regression if sched_compat_yield=0.
> > 
> > I ran some testing, such like iozone/specjbb/tbench/dbench/sysbench, 
> > and didn't see regression.
> 
> which JVM was utilized by the specjbb (Java Business Benchmark) tests?
BEA Jrockit. It supports huge pages which promote performance for about 8%~10%.

-yanmin
