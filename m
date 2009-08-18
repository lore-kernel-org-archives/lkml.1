Return-Path: <linux-kernel-owner+w=401wt.eu-S1758931AbZHRNZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbZHRNZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758808AbZHRNZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:25:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:56323 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbZHRNZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:25:54 -0400
Subject: Re: [PATCH 0/12] cleanup __build_sched_domains()
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gautham Shenoy <ego@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>
In-Reply-To: <20090818131558.GO29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com>
	 <20090818111644.GA23983@elte.hu>  <20090818131558.GO29515@alberich.amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Aug 2009 15:25:41 +0200
Message-Id: <1250601941.7583.283.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 15:15 +0200, Andreas Herrmann wrote:
> 
> > I'd also not be surprised if the load-balancer needed some care to 
> > properly handle such a setup.
> 
> It needs some care and gave me some headache to get it working in all
> cases (i.e. NUMA, no-NUMA, NUMA-but-no-SRAT). My current code (that
> still needs to be split in proper patches for submission) works fine
> in all but one case. And I am still debugging it.
> 
> The case that is not working is a normal (non-multi-node) NUMA system
> on which switching to power policy does not take effect for already
> running tasks. Just the new created ones are scheduled according to
> the power policy.

Note that current upstream is broken here in a way that isn't fixable in
a straight fwd way. Ego and vatsa were looking into that iirc.
