Return-Path: <linux-kernel-owner+w=401wt.eu-S933565AbXBXVLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565AbXBXVLR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 16:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933567AbXBXVLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 16:11:16 -0500
Received: from p02c11o146.mxlogic.net ([208.65.145.69]:57693 "EHLO
	p02c11o146.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933565AbXBXVLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 16:11:15 -0500
Date: Sat, 24 Feb 2007 23:11:41 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, bunk@stusta.de, pavel@suse.cz,
       linux-pm@linux-foundation.org, linux-acpi@vger.kernel.org,
       len.brown@intel.com, mingo@redhat.com
Subject: Re: 2.6.21-rc1: T60 resume from suspend to RAM issues
Message-ID: <20070224211141.GA4425@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <20070223020904.c8fc8a3e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223020904.c8fc8a3e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 24 Feb 2007 21:13:35.0978 (UTC) FILETIME=[A57764A0:01C75858]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15016.001
X-TM-AS-Result: No--16.017600-4.000000-31
X-Spam: [F=0.1723388037; S=0.172(2007010901)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Andrew Morton <akpm@linux-foundation.org>:
> Subject: Re: 2.6.21-rc1: T60 resume from suspend to RAM issues
> 
> > On Fri, 23 Feb 2007 01:38:03 +0200 "Michael S. Tsirkin" <mst@mellanox.co.il> wrote:
> > I tested this:
> > commit 9654640d0af8f2de40ff3807d3695109d3463f54
> > and see 2 issues:
> > 
> > 1. After suspend to RAM, system wakes up but no screen.
> > I can log in through ssh though.
> > dmesg output at this point below.
> > Works fine on 2.6.20 and below, with same .config
> > .config and log file for this issue attached.
> > 
> > 2. As a separate test, I enabled DynTicks in .config.
> > Seems to work fine but won't come out of suspend to memory at all:
> > pressing Fn/F4 seems to have no effect.
> > 
> 
> Do you believe that the second problem was caused by dynticks?

Assuming these are 2 different problems, yes, the second one seems
to be caused by dyntics.

-- 
MST
