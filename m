Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbXFON6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbXFON6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXFON6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:58:44 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34466 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbXFON6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:58:43 -0400
Date: Fri, 15 Jun 2007 19:36:45 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Kirill Korotaev <dev@sw.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       wli@holomorphy.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, efault@gmx.de, kernel@kolivas.org,
       pwil3058@bigpond.net.au, dmitry.adamushko@gmail.com, tingy@cs.umass.edu,
       tong.n.li@intel.com, containers@lists.osdl.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC][PATCH 0/6] Add group fairness to CFS - v1
Message-ID: <20070615140645.GD11272@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070611154724.GA32435@in.ibm.com> <20070611193735.GA22152@elte.hu> <20070612055024.GA26957@in.ibm.com> <20070612062612.GA19637@elte.hu> <46728A15.5050905@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46728A15.5050905@sw.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 04:46:13PM +0400, Kirill Korotaev wrote:
> Ingo Molnar wrote:
> 
> > i'd still like to hear back from Kirill & co whether this framework is 
> > flexible enough for their work (OpenVZ, etc.) too.
> 
> My IMHO is that so far the proposed group scheduler doesn't look ready/suitable.

Hi Kirill,
	Yes its work-in-progress and hence is not ready/fully-functional
(yet). The patches I posted last gives an idea of the direction it is
heading. For ex: http://lkml.org/lkml/2007/6/11/162 and
http://lkml.org/lkml/2007/5/25/146 gives an idea of how SMP load balance will 
works.

IMHO the nice thing about this approach is it (re)uses lot of code in
scheduler which is there already to achieve fairness between tasks and
higher schedulable elements (users/containers etc).

Also with CFS engine's precise nanosecond accurate accounting and time-sorted 
list of tasks/entities, I feel we will get much tighter control over 
distribution of CPU between tasks/users/containers.

> We need to have a working SMP version before it will be clear
> whether the whole approach is good and works correct on variety of load patterns.

If you have any headsup thoughts on areas/workloads where this may pose problems
for container/user scheduling, I would be glad to hear them. Otherwise I would 
greatly wellcome any help in developing/reviewing these patches which meets 
both our goals!

-- 
Regards,
vatsa
