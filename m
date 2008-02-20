Return-Path: <linux-kernel-owner+w=401wt.eu-S932981AbYBTT2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981AbYBTT2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756706AbYBTT1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:27:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:30254 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbYBTT1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:27:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,382,1199692800"; 
   d="scan'208";a="381507909"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Wed, 20 Feb 2008 11:18:08 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201053.16218.jesse.barnes@intel.com> <b6a2187b0802201110k6e6c458dg6f48c586fff6187a@mail.gmail.com>
In-Reply-To: <b6a2187b0802201110k6e6c458dg6f48c586fff6187a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201118.08468.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2008 11:10 am Jeff Chua wrote:
> On Feb 21, 2008 2:53 AM, Jesse Barnes <jesse.barnes@intel.com> wrote:
> > > So, next I'll try "shutdown" to see if it work. I was using "platform".
> >
> > Ok, that would be good to try.
>
> "shutdown" does power down properly. But still green on resume.

Ok, so Linus' theory about something later in the resume path trying to touch 
video is looking good.

Rafael, is there anyway to prevent the device shutdown in the hibernate path?

> > Looks like the AR registers are hosed, which is what I thought I fixed...
> >  Can you attach your i915_drv.c file just so I can sanity check it?
>
> Attached.

Hm, looks right.  Let me see if I can reproduce this on my T61.

Thanks,
Jesse
