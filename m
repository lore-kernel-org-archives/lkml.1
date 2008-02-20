Return-Path: <linux-kernel-owner+w=401wt.eu-S1761747AbYBTTFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761747AbYBTTFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbYBTTFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:05:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:10044 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbYBTTFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:05:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,382,1199692800"; 
   d="scan'208";a="381494431"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Wed, 20 Feb 2008 10:53:15 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802200950.53591.jesse.barnes@intel.com> <b6a2187b0802201029h4786ab87qbc14d1466e12058b@mail.gmail.com>
In-Reply-To: <b6a2187b0802201029h4786ab87qbc14d1466e12058b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201053.16218.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2008 10:29 am Jeff Chua wrote:
> > I know I fixed that problem in at least one configuration...  Can you
> > try: # echo test > /sys/power/disk
> >   # echo disk > /sys/power/state
> > and see if that also turns your screen green?
>
> Yes, still green. But I got it to actual reboot with ...
>
> echo reboot > /sys/power/disk
>
> So, next I'll try "shutdown" to see if it work. I was using "platform".

Ok, that would be good to try.

> > Also, getting a GPU register dump would be helpful.  The intel_reg_dumper
> > tool
>
> Attached are the two dumps from console. One prior to suspend, and one
> after resume.

Looks like the AR registers are hosed, which is what I thought I fixed...  Can 
you attach your i915_drv.c file just so I can sanity check it?

Thanks,
Jesse
