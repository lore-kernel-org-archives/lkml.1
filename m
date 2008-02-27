Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYB0PKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYB0PKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYB0PK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:10:26 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:51531 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751262AbYB0PKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:10:25 -0500
Date: Wed, 27 Feb 2008 20:40:09 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: don't allow rt_runtime_us to be zero for groups
	having rt tasks
Message-ID: <20080227151009.GA18903@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080227110829.GA15731@linux.vnet.ibm.com> <1204116417.6242.383.camel@lappy> <20080227132459.GE15731@linux.vnet.ibm.com> <1204121510.6242.406.camel@lappy> <20080227150350.GB21610@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227150350.GB21610@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 04:03:50PM +0100, Ingo Molnar wrote:
> 
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
> 

Belongs to mainline.

-- 
regards,
Dhaval
