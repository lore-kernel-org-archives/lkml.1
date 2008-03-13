Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYCMRkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYCMRkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYCMRk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:40:27 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:54991 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767AbYCMRk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:40:26 -0400
Subject: Re: [patch 0/6] Guest page hinting version 6.
From: Zachary Amsden <zach@vmware.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, virtualization@lists.osdl.org,
       akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       frankeh@watson.ibm.com, rusty@rustcorp.com.au, jeremy@goop.org,
       andrea@qumranet.com, clameter@sgi.com, a.p.zijlstra@chello.nl
In-Reply-To: <Pine.LNX.4.64.0803131627450.17244@blonde.site>
References: <20080312132132.520833247@de.ibm.com>
	 <Pine.LNX.4.64.0803131627450.17244@blonde.site>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 10:45:07 -0700
Message-Id: <1205430307.18433.20.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-13 at 16:57 +0000, Hugh Dickins wrote:
> Oh, that would be such a shame.  Your guest page hinting patches remind
> me of that childhood thrill, when once a year the circus comes to town ;)

I like the circus too.

> But seriously, I'm ashamed to see my name in the Cc list: it would
> be very unfair if your patches never made it in, just because I've
> failed to find the time to wrap my own puny brain around them.

Bah!  So modest.

> It's very encouraging to see Jeremy and Rusty weighing in.  I hope
> Zach will too, and I've added Andrea: their support would count a lot.
> You have Nick on the list, good, I've added Christoph and Peter
> (if you do resend, linux-mm might prove more useful than linux-kernel).

I agree the page hinting technique is generally useful, even
cross-architecture.

What doesn't appear to be useful however, is support for this under
VMware.  It can be done, even without the writable pte support (yes,
really).  But due to us exploiting optimizations at lower layers, it
doesn't appear that it will gain us any performance - and we must
already have the complex working set algorithms to support
non-paravirtualized guests.

> With support from rival virtualizers,
> I do think you've a good chance of getting in.

I would say we support it, but I don't expect us to make use of the
infrastructure anytime soon.  For us it would make more sense to use the
swap-fault optimization, but this requires some significant design
changes in our monitor.

Either way, these are both great ideas and I would not want to be held
responsible for blocking their upstream progress.  Someday, with the
evolving x86 architecture (if we ever get per-page dirty bits), they
might make sense for us to do as well.

Zach

