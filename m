Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbZLDNNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbZLDNNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbZLDNMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:12:51 -0500
Received: from mail.gmx.net ([213.165.64.20]:39969 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756283AbZLDNMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:12:43 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX185C1V974w5a+m+qiHMdDq2tDrQihCHjk8sq82axg
	KUuJuhUDlwj90p
Subject: Re: [RFC][PATCH] sched: fix GENTLE_FAIR_SLEEPERS dependency
From: Mike Galbraith <efault@gmx.de>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B18F59B.6@suse.de>
References: <4B18D66E.8020905@suse.de> <20091204095408.GA26118@elte.hu>
	 <4B18E257.2080009@suse.de> <1259924920.17907.8.camel@laptop>
	 <4B18F59B.6@suse.de>
Content-Type: text/plain
Date: Fri, 04 Dec 2009 14:12:46 +0100
Message-Id: <1259932366.5621.27.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 17:12 +0530, Suresh Jayaraman wrote:
> On 12/04/2009 04:38 PM, Peter Zijlstra wrote:
> > On Fri, 2009-12-04 at 15:50 +0530, Suresh Jayaraman wrote:
> >>
> >> I think originally introduced as a development/debugging facility,
> >> sched_features is slowly transforming into a viable tool for System
> >> Administrators, by looking at the impact of turning on/off some of these
> >> features on some workloads (especially non-desktop workloads). And I
> >> think these benefits should be passed on to the end users perhaps in the
> >> form of documentation. 
> > 
> > This is really not meant to be used in that context. Its purely a debug
> > feature, with knobs coming and going as we see fit.
> > 
> 
> Does this also mean these features should not impact any specific
> workload much?

Not at all.  Most loads will be heavily affected by one or more
features.

	-Mike

