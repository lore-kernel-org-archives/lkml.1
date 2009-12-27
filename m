Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbZL0Jl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbZL0Jl3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 04:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbZL0Jl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 04:41:29 -0500
Received: from mail.gmx.net ([213.165.64.20]:42807 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750872AbZL0Jl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 04:41:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/ZeIRv3YLZuGneVqICTqNp2297K5QimoM/igYoqW
	HuwlVMo/BuP2xB
Subject: Re: tbench regression with 2.6.33-rc1
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1261904349.15854.2.camel@laptop>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
	 <1261902760.6201.33.camel@marge.simson.net>
	 <1261904349.15854.2.camel@laptop>
Content-Type: text/plain
Date: Sun, 27 Dec 2009 10:41:23 +0100
Message-Id: <1261906883.5451.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6899999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-27 at 09:59 +0100, Peter Zijlstra wrote:
> On Sun, 2009-12-27 at 09:32 +0100, Mike Galbraith wrote:
> > Perf also isn't free, and in 33, we lost the ability to config it out,
> 
> Uhm, that's a plain bug, we should be able to build a kernel without
> perf support, does the hw breakpoint support have an unfortunate select
> some place or something?

Yeah, it's selected in arch/x86/Kconfig.  The kernel won't build without
it either.

	-Mike

