Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbYBMQnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbYBMQnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932246AbYBMQnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:43:19 -0500
Received: from viefep31-int.chello.at ([62.179.121.49]:61197 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764705AbYBMQnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:43:18 -0500
Subject: Re: Regression in latest sched-git
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: vatsa@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080213163715.GB19570@linux.vnet.ibm.com>
References: <20080212185355.GA6320@linux.vnet.ibm.com>
	 <1202845208.6247.82.camel@lappy> <20080213030035.GA3402@linux.vnet.ibm.com>
	 <1202907078.20209.3.camel@lappy>
	 <20080213163444.GA19570@linux.vnet.ibm.com>
	 <20080213163715.GB19570@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 17:43:13 +0100
Message-Id: <1202920993.6811.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-13 at 22:07 +0530, Dhaval Giani wrote:
> On Wed, Feb 13, 2008 at 10:04:44PM +0530, Dhaval Giani wrote:
> > > > On the same lines, I cant understand how we can be seeing 700ms latency
> > > > (below) unless we had: large number of active groups/users and large number of 
> > > > tasks within each group/user.
> > > 
> > > All I can say it that its trivial to reproduce these horrid latencies.
> > > 
> > 
> > Hi Peter,
> > 
> > I've been trying to reproduce the latencies, and the worst I have
> > managed only 80ms. At an average I am getting around 60 ms. This is with
> > a make -j4 as root, and dhaval running other programs. (with maxcpus=1).
> > 
> 
> Totally missed here. Any more hints to reproduce?

Not really, this is the recipie I took from Lukas Hejtmanek's report and
it worked for me.

I'll see if I can find some time to try the ftrace patches to narrow
this down.

