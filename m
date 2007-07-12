Return-Path: <linux-kernel-owner+w=401wt.eu-S934560AbXGLNzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934560AbXGLNzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762147AbXGLNzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:55:22 -0400
Received: from rtr.ca ([64.26.128.89]:4824 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758542AbXGLNzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:55:21 -0400
Message-ID: <469632C7.5000903@rtr.ca>
Date: Thu, 12 Jul 2007 09:55:19 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: david@lang.hm
Cc: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec	base	hibernation
References: <1184167831.12556.13.camel@caritas-dev.intel.com>  <20070711172243.ab44c4d4.akpm@linux-foundation.org>  <1184251423.9346.55.camel@caritas-dev.intel.com>  <Pine.LNX.4.64.0707112345250.28090@asgard.lang.hm> <1184260683.9346.91.camel@caritas-dev.intel.com> <Pine.LNX.4.64.0707120247230.25614@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707120247230.25614@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
>
> actually, I think that while you may be able to get away with only one 
> kernel, you are probably better off with two. on the hibernate kernel 
> you can choose many 'embedded' options that don't make sense for the 
> normal kernel (no high mem, no SMP support, no SELinux, no network 
> routing, not netfilter, use SLOB not SLAB/SLUB, etc). also keep in mind 
> that each module that you load wastes apartial page of memory.

No highmem?  No thanks.

I really want hibernate to save stuff from above 1GB as well
as the stuff below 1GB.

Cheers
