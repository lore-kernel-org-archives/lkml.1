Return-Path: <linux-kernel-owner+w=401wt.eu-S1763945AbXGLTL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763945AbXGLTL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbXGLTLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:11:20 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:51645
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbXGLTLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:11:19 -0400
Date: Thu, 12 Jul 2007 12:05:08 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Mark Lord <lkml@rtr.ca>
cc: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec	base	hibernation
In-Reply-To: <469632C7.5000903@rtr.ca>
Message-ID: <Pine.LNX.4.64.0707121204200.25614@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com> 
 <20070711172243.ab44c4d4.akpm@linux-foundation.org> 
 <1184251423.9346.55.camel@caritas-dev.intel.com> 
 <Pine.LNX.4.64.0707112345250.28090@asgard.lang.hm>
 <1184260683.9346.91.camel@caritas-dev.intel.com> <Pine.LNX.4.64.0707120247230.25614@asgard.lang.hm>
 <469632C7.5000903@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Mark Lord wrote:

> david@lang.hm wrote:
>>
>>  actually, I think that while you may be able to get away with only one
>>  kernel, you are probably better off with two. on the hibernate kernel you
>>  can choose many 'embedded' options that don't make sense for the normal
>>  kernel (no high mem, no SMP support, no SELinux, no network routing, not
>>  netfilter, use SLOB not SLAB/SLUB, etc). also keep in mind that each
>>  module that you load wastes apartial page of memory.
>
> No highmem?  No thanks.
>
> I really want hibernate to save stuff from above 1GB as well
> as the stuff below 1GB.

oops, good point. I was thinking that the hibernate kernel wouldn't need 
that much ram for it's own operation and forgetting that it needed to 
access everything the main system had.

David Lang
