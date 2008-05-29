Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbYE2J7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbYE2J7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 05:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbYE2J7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 05:59:31 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:36121 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbYE2J7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 05:59:30 -0400
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
From: Kasper Sandberg <lkml@metanurb.dk>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com
In-Reply-To: <alpine.DEB.1.10.0805281523560.29755@p34.internal.lan>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
	 <483D7CE8.4000600@redhat.com>
	 <alpine.DEB.1.10.0805281329450.29755@p34.internal.lan>
	 <483DB0EC.3090403@redhat.com>
	 <alpine.DEB.1.10.0805281523560.29755@p34.internal.lan>
Content-Type: text/plain
Date: Thu, 29 May 2008 11:57:30 +0200
Message-Id: <1212055050.25169.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-28 at 15:27 -0400, Justin Piszcz wrote:
> 
> On Wed, 28 May 2008, Chris Snook wrote:
> 
> > Justin Piszcz wrote:
> >> 
> >> 
> >> On Wed, 28 May 2008, Chris Snook wrote:
> >> 
> >>> Justin Piszcz wrote:
> >>>> Hardware:
> >>>> 
> >>> Given that one of the greatest benefits of NCQ/TCQ is with parity RAID, 
> >>> I'd be fascinated to see how enabling NCQ changes your results.  Of 
> >>> course, you'd want to use a single SATA controller with a known good NCQ 
> >>> implementation, and hard drives known to not do stupid things like disable 
> >>> readahead when NCQ is enabled.
> >> Only/usually on multi-threaded jobs/tasks, yes?
> >
> > Generally, yes, but there's caching and readahead at various layers in 
> > software that can expose the benefit on certain single-threaded workloads as 
> > well.
> >
> >> Also, I turn off NCQ on all of my hosts that has it enabled by default 
> >> because
> >> there are many bugs that occur when NCQ is on, they are working on it in 
> >> the
> >> libata layer but IMO it is not safe at all for running SATA disks w/NCQ as
> >> with it on I have seen drives drop out of the array (with it off, no 
> >> problems).
> >> 
> >
> > Are you using SATA drives with RAID-optimized firmware?  Most SATA 
> > manufacturers have variants of their drives for a few dollars more that have 
> > firmware that provides bounded latency for error recovery operations, for 
> > precisely this reason.
> I see--however, as I understood it there were bugs utilizing NCQ in libata?
You wouldnt happen to have some more information about this? i havent
personally had problems yet, but i havent used it for very long - but
since it comes activated by DEFAULT, i would assume it to be relatively
stable?

> 
> But FYI--
> In this test, they were regular SATA drives, not special raid-ones (RE2,etc).
> 
> Thanks for the info!
> 
> Justin.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

