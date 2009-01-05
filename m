Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbZAEGhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbZAEGhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 01:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZAEGhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 01:37:05 -0500
Received: from mail.gmx.net ([213.165.64.20]:38978 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751296AbZAEGhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 01:37:02 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18u4O0wJtAuCDYhvCHia5RspICNs4T33FMgV6plP6
	Z1kg8KN/Vemk0r
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
From: Mike Galbraith <efault@gmx.de>
To: svaidy@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1231130416.5479.8.camel@marge.simson.net>
References: <20081230062139.GA30038@elte.hu>
	 <20081230180722.GA29060@dirshya.in.ibm.com>
	 <20090102072600.GA13412@dirshya.in.ibm.com>
	 <20090102221630.GF17240@elte.hu> <1230967765.5257.6.camel@marge.simson.net>
	 <20090103101626.GA4301@dirshya.in.ibm.com>
	 <1230981761.27180.10.camel@marge.simson.net>
	 <1231081200.17224.44.camel@marge.simson.net>
	 <20090104181946.GC4301@dirshya.in.ibm.com>
	 <1231098769.5757.43.camel@marge.simson.net>
	 <20090105032029.GE4301@dirshya.in.ibm.com>
	 <1231130416.5479.8.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 07:36:53 +0100
Message-Id: <1231137413.10471.23.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Virgin 28 does not have a knee, but grows one when NEWIDLE is enabled.
The throughput curve is essentially the mc=2 curve with the knee
smoothed away, and a higher peak.  The very end is considerably lower.
ie it only helps the extremely contested end, and not nearly as much.
The whole curve is roughly a point under the 26.8 curve (which could
easily be config differences etc, but the shape is right).

I'll rummage around.

	-Mike

