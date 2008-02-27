Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbYB0PJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbYB0PJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYB0PI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:08:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58685 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbYB0PI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:08:56 -0500
Subject: Re: [PATCH] sched: don't allow rt_runtime_us to be zero for groups
	having rt tasks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080227150350.GB21610@elte.hu>
References: <20080227110829.GA15731@linux.vnet.ibm.com>
	 <1204116417.6242.383.camel@lappy>
	 <20080227132459.GE15731@linux.vnet.ibm.com>
	 <1204121510.6242.406.camel@lappy>  <20080227150350.GB21610@elte.hu>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 16:08:39 +0100
Message-Id: <1204124919.6242.408.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 16:03 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > 
> > On Wed, 2008-02-27 at 18:54 +0530, Dhaval Giani wrote:
> > 
> > > This patch checks if we can set the rt_runtime_us to 0. If there is a
> > > realtime task in the group, we don't want to set the rt_runtime_us as 0
> > > or bad things will happen.
> > > 
> > > Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > 
> > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> doesnt apply to sched-devel.git - what's the plan here?

stick in front, drop the other two sched-rt-group patches for which I'll
send you an update somewhere today.

These two patches would be candidates to push to linus..

