Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbZL2FtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbZL2FtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 00:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZL2FtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 00:49:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:36391 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751229AbZL2FtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 00:49:09 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+jArBV2RGjgpI3x/2z4ogtw7miWyAyzcn8CkVb7b
	IiLY2rsBXOKn5D
Subject: Re: tbench regression with 2.6.33-rc1
From: Mike Galbraith <efault@gmx.de>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262063959.13697.6.camel@minggr.sh.intel.com>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
	 <1261902760.6201.33.camel@marge.simson.net>
	 <1262052582.10685.59.camel@minggr.sh.intel.com>
	 <1262064292.6412.30.camel@marge.simson.net>
	 <1262063959.13697.6.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Tue, 29 Dec 2009 06:49:05 +0100
Message-Id: <1262065745.17082.0.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-29 at 13:19 +0800, Lin Ming wrote:
> On Tue, 2009-12-29 at 13:24 +0800, Mike Galbraith wrote:
> > On Tue, 2009-12-29 at 10:09 +0800, Lin Ming wrote:
> > > And also no regression if I run tbench with RT scheduler on tulsa
> > > machine, as below command,
> > > 
> > > schedtool -R -p 20 -e tbench_srv &
> > > schedtool -R -p 20 -e tbench 32
> > 
> > Hm, odd.  I'd expect tbench to suffer when run SCHED_RR, and here it
> > does, achieving roughly 85% of lowest SCHED_OTHER throughput.
> 
> Here is some misunderstanding.
> I compared SCHED_RR tbench with 2.6.32 and 2.6.33-rc1 and no regression
> found.
> 
> For the same kernel, SCHED_RR tbench only achieved ~40% of SCHED_OTHER
> throughput.

Ah.  Thanks for the clarification.

	-Mike

