Return-Path: <linux-kernel-owner+w=401wt.eu-S932160AbXB0KjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbXB0KjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932948AbXB0KjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:39:14 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58215 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932160AbXB0KjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:39:13 -0500
Date: Tue, 27 Feb 2007 11:38:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bunk@stusta.de, linux-pm@linux-foundation.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com, mingo@redhat.com
Subject: Re: 2.6.21-rc1: T60 resume from suspend to RAM issues
Message-ID: <20070227103853.GH6745@elf.ucw.cz>
References: <20070223020904.c8fc8a3e.akpm@linux-foundation.org> <20070224211141.GA4425@mellanox.co.il> <20070227101451.GA11981@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227101451.GA11981@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

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

See suspend.sf.net. s2ram is able to resume display for you, too.. as
should some command line parameter.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
