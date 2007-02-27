Return-Path: <linux-kernel-owner+w=401wt.eu-S1750763AbXB0LTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750763AbXB0LTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 06:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbXB0LTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 06:19:54 -0500
Received: from dev.mellanox.co.il ([194.90.237.44]:34558 "EHLO
	dev.mellanox.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbXB0LTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 06:19:53 -0500
X-Greylist: delayed 3015 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Feb 2007 06:19:53 EST
Date: Tue, 27 Feb 2007 12:28:09 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bunk@stusta.de, pavel@suse.cz, linux-pm@linux-foundation.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com, mingo@redhat.com
Subject: Re: 2.6.21-rc1: T60 resume from suspend to RAM issues
Message-ID: <20070227102809.GD10548@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <20070223020904.c8fc8a3e.akpm@linux-foundation.org> <20070224211141.GA4425@mellanox.co.il> <20070227101451.GA11981@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227101451.GA11981@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Ingo Molnar <mingo@elte.hu>:
> Subject: Re: 2.6.21-rc1: T60 resume from suspend to RAM issues
> 
> 
> * Michael S. Tsirkin <mst@mellanox.co.il> wrote:
> 
> > > > 2. As a separate test, I enabled DynTicks in .config. Seems to 
> > > > work fine but won't come out of suspend to memory at all: pressing 
> > > > Fn/F4 seems to have no effect.
> > > 
> > > Do you believe that the second problem was caused by dynticks?
> > 
> > Assuming these are 2 different problems, yes, the second one seems to 
> > be caused by dyntics.
> 
> on my T60 current -git does not resume even without dynticks. v2.6.20 
> with the same .config resumes fine (except for the display).
> 
> after pressing Fn/F4 the disk light flashes briefly, which suggests that 
> action is probably back to the Linux kernel at that point, and that we 
> hung somewhere there. Will try a bisection thing.

That's exactly the behaviour I have with DynTicks: the disk light flashes
briefly.

-- 
MST
