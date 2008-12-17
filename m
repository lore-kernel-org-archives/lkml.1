Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753317AbYLQXDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbYLQXDO (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYLQXC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:02:57 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39976 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752187AbYLQXC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:02:56 -0500
Message-ID: <4949851E.5000304@sgi.com>
Date: Wed, 17 Dec 2008 15:02:54 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 1/4] cpumask: cpu_coregroup_mask(): x86
References: <200812011646.35018.rusty@rustcorp.com.au> <4949831B.2000809@sgi.com>
In-Reply-To: <4949831B.2000809@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Rusty Russell wrote:
>> Like cpu_coregroup_map, but returns a (const) pointer.
>>
>> (This will go to Ingo separately as part of the x86 series, just
>> airing it here for thoroughness).
>>
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
> 
> I've pulled this patch into the queue for my cpus4096-for-ingo tree.
> 
> 	[PATCH 1/4] cpumask: cpu_coregroup_mask(): x86
> 
> I can also line up a queue for sched related changes:
> 
> 	[PATCH 4/4] cpumask: Replace cpu_coregroup_map with cpu_coregroup_map()
> 
> Is there any status on the corresponding changes for sparc, s390?  (I assume
> that they'll need to be merged into linux-next?)
> 
> 	[PATCH 2/4] cpumask: cpu_coregroup_mask(): sparc
> 	[PATCH 3/4] cpumask: cpu_coregroup_mask(): s390

Oops, never mind.  I just noticed that all 4 have already been pushed via
linux-next.

Ingo - how do we get these back into -tip for testing with other cpus4096
changes?  Do I need to do anything?

Thanks,
Mike
