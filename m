Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbZBZKoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbZBZKoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZBZKny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:43:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:53546 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbZBZKny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:43:54 -0500
Subject: Re: [PATCH] cpuacct: add a branch prediction
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090226104008.GJ11421@balbir.in.ibm.com>
References: <49A6475F.4000502@cn.fujitsu.com>
	 <20090226083702.GI11421@balbir.in.ibm.com>
	 <49A655B0.9020002@cn.fujitsu.com>
	 <20090226104008.GJ11421@balbir.in.ibm.com>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 11:43:39 +0100
Message-Id: <1235645019.4645.4780.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 16:10 +0530, Balbir Singh wrote:

> My point is the likely/unlikely in this case depends on turning on/off
> CONFIG_CGROUP_CPUACCT? Am I missing something?

Yeah, that whole function is a stub for !CPUACCT

#ifdef CONFIG_CGROUP_CPUACCT
static void cpuacct_charge(struct task_struct *tsk, u64 cputime);
#else
static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
#endif


