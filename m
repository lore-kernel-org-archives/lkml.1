Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbZL2FZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbZL2FZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 00:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZL2FZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 00:25:01 -0500
Received: from mail.gmx.net ([213.165.64.20]:50113 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751820AbZL2FZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 00:25:01 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/tq1tXxm7tO7o0yCSha77wBRUjPXd3V7t3pVHeLM
	bNBBH9ZcuWK4o+
Subject: Re: tbench regression with 2.6.33-rc1
From: Mike Galbraith <efault@gmx.de>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262052582.10685.59.camel@minggr.sh.intel.com>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
	 <1261902760.6201.33.camel@marge.simson.net>
	 <1262052582.10685.59.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Tue, 29 Dec 2009 06:24:52 +0100
Message-Id: <1262064292.6412.30.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-29 at 10:09 +0800, Lin Ming wrote:
> And also no regression if I run tbench with RT scheduler on tulsa
> machine, as below command,
> 
> schedtool -R -p 20 -e tbench_srv &
> schedtool -R -p 20 -e tbench 32

Hm, odd.  I'd expect tbench to suffer when run SCHED_RR, and here it
does, achieving roughly 85% of lowest SCHED_OTHER throughput.

	-Mike

