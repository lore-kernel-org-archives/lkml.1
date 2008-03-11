Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbYCKRZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbYCKRZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYCKRZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:25:38 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64987 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbYCKRZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:25:37 -0400
X-IronPort-AV: E=McAfee;i="5100,188,5249"; a="1220793"
Message-ID: <47D6C08E.9040701@qualcomm.com>
Date: Tue, 11 Mar 2008 10:25:34 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com
Subject: Re: [PATCH 1/2] cpuset: cpuset irq affinities
References: <1205215046-27085-1-git-send-email-maxk@qualcomm.com>	<1205215046-27085-2-git-send-email-maxk@qualcomm.com> <20080311015711.9c4615a6.pj@sgi.com>
In-Reply-To: <20080311015711.9c4615a6.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Jackson wrote:
> Max K wrote:
>> this could also provide the desired semantics.
> 
> Could you spell out what you mean by "the desired semantics" ?
> 
> I don't see any Documentation or much comments, which would
> help understand this.  It helps to describe both what has
> changed, and, from the top, the why, what and how of what
> you're doing, in part as Documentation or code comments,
> for the benefit of future readers.
> 
> Did you see my discussion of this with Peter on March 6 and 7
> in the lkml "[RFC/PATCH] cpuset: cpuset irq affinities" thread?
> This latest patch of yours seems, offhand, to predate that discussion.
Paul, can you please comment on 2/2 patch instead. 1/2 is just a resend of the
Peter's original patch that I was building on top. So yes it predates that
discussion. I used it as the baseline.

> I don't see any explanation of what locking is needed when.
There are more comments in 2/2. There is one spot in there where I'm not sure
about the locking (look for FIXME comment). Everything else seems to be
protected correctly by callback_lock. I may have missed things of course.

> What semantics to you impose on irqs in overlapping cpusets,
> which would seem to lead to conflicting directives as to
> whether one set or another of irqs was to be applied to the
> CPUs in the overlap?
Please take a look at
	[PATCH 2/2] cpusets: Improved irq affinity handling
I'm treating irqs just like tasks (at least I think I'm :).

Max



