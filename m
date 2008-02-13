Return-Path: <linux-kernel-owner+w=401wt.eu-S933495AbYBMQhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495AbYBMQhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbYBMQhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:37:22 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:34042 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764311AbYBMQhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:37:20 -0500
Date: Wed, 13 Feb 2008 22:07:15 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: vatsa@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression in latest sched-git
Message-ID: <20080213163715.GB19570@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080212185355.GA6320@linux.vnet.ibm.com> <1202845208.6247.82.camel@lappy> <20080213030035.GA3402@linux.vnet.ibm.com> <1202907078.20209.3.camel@lappy> <20080213163444.GA19570@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213163444.GA19570@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 10:04:44PM +0530, Dhaval Giani wrote:
> > > On the same lines, I cant understand how we can be seeing 700ms latency
> > > (below) unless we had: large number of active groups/users and large number of 
> > > tasks within each group/user.
> > 
> > All I can say it that its trivial to reproduce these horrid latencies.
> > 
> 
> Hi Peter,
> 
> I've been trying to reproduce the latencies, and the worst I have
> managed only 80ms. At an average I am getting around 60 ms. This is with
> a make -j4 as root, and dhaval running other programs. (with maxcpus=1).
> 

Totally missed here. Any more hints to reproduce?

-- 
regards,
Dhaval
