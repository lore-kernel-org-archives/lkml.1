Return-Path: <linux-kernel-owner+w=401wt.eu-S932612AbYBTWdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbYBTWdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYBTWdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:33:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:23702 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbYBTWdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:33:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,382,1199692800"; 
   d="scan'208";a="521903705"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Wed, 20 Feb 2008 14:32:13 -0800
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
Message-Id: <200802201432.13393.jesse.barnes@intel.com>
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
>
> > Looks like the AR registers are hosed, which is what I thought I fixed...
> >  Can you attach your i915_drv.c file just so I can sanity check it?
>
> Attached.

Jeff, for the hang on suspend problem, I know suspect something else in 
2.6.25-rc2 caused that.

Can you try the 2.6.25-rc1 version of i915_drv.c (in fact all of 
drivers/char/drm from 2.6.25-rc1) but in a 2.6.25-rc2 kernel?  I ask because 
2.6.25-rc1 suspends to disk just fine for me and resumes w/o a green screen, 
while 2.6.25-rc2 fails to suspend (hangs like you say) and gives me a green 
screen.

Were there other changes in ACPI or the PM core that might have caused this I 
wonder?

Thanks,
Jesse
