Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbXB0Lf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbXB0Lf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 06:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933044AbXB0Lf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 06:35:27 -0500
Received: from dev.mellanox.co.il ([194.90.237.44]:34569 "EHLO
	dev.mellanox.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024AbXB0Lf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 06:35:26 -0500
Date: Tue, 27 Feb 2007 13:33:08 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bunk@stusta.de, pavel@suse.cz, linux-pm@linux-foundation.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com, mingo@redhat.com
Subject: Re: 2.6.21-rc1: T60 resume from suspend to RAM issues
Message-ID: <20070227113308.GE10548@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <20070223020904.c8fc8a3e.akpm@linux-foundation.org> <20070224211141.GA4425@mellanox.co.il> <20070227101451.GA11981@elte.hu> <20070227102809.GD10548@mellanox.co.il> <20070227110306.GE20927@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227110306.GE20927@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Ingo Molnar <mingo@elte.hu>:
> Subject: Re: 2.6.21-rc1: T60 resume from suspend to RAM issues
> 
> 
> * Michael S. Tsirkin <mst@mellanox.co.il> wrote:
> 
> > > > > Do you believe that the second problem was caused by dynticks?
> > > > 
> > > > Assuming these are 2 different problems, yes, the second one seems 
> > > > to be caused by dyntics.
> > > 
> > > on my T60 current -git does not resume even without dynticks. 
> > > v2.6.20 with the same .config resumes fine (except for the display).
> > > 
> > > after pressing Fn/F4 the disk light flashes briefly, which suggests 
> > > that action is probably back to the Linux kernel at that point, and 
> > > that we hung somewhere there. Will try a bisection thing.
> > 
> > That's exactly the behaviour I have with DynTicks: the disk light 
> > flashes briefly.
> 
> it flashes here briefly even if suspend works fine.

Yes of course. The difference with 2.6.21-rc1 is that flashing the LED
is all it does :)


-- 
MST
