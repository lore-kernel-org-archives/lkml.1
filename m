Return-Path: <linux-kernel-owner+w=401wt.eu-S933511AbXGLP2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511AbXGLP2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 11:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758910AbXGLP20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 11:28:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55670 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758470AbXGLP2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 11:28:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Thu, 12 Jul 2007 17:35:38 +0200
User-Agent: KMail/1.9.5
Cc: david@lang.hm, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Huang, Ying" <ying.huang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <200707121446.14170.rjw@sisk.pl> <469631FA.2070405@rtr.ca>
In-Reply-To: <469631FA.2070405@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707121735.40077.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 12 July 2007 15:51, Mark Lord wrote:
> Rafael J. Wysocki wrote:
> > On Thursday, 12 July 2007 08:43, david@lang.hm wrote:
> >> On Wed, 11 Jul 2007, Jeremy Fitzhardinge wrote:
> >>
> >>> Andrew Morton wrote:
> ..
> >> 8. hibernate kernel does syspend-to-ram to put the devices into a known 
> >> safe state.
> > Again, the devices should be quiesced rather then suspended in this step.
> 
> That's just not possible.  The Hibernate kernel will not have all
> of the same device drivers as the mainline kernel.  Or at least that's
> what people have previously stated here.

OK, one more problem to solve. :-)

> >>>>  This sounds awesome.  Am I correct in expecting that ultimately the
> >>>>  existing hibernation implementation just goes away and we reuse (and hence
> >>>>  strengthen) the existing kexec (and kdump?) infrastructure?
> 
> No, not so simple.  We still need much of the code to santize devices
> upon wakeup from hibernation.   And adding this extra reboot-kernel step
> in the midst of hibernate will double the time it takes (ugh).
> 
> Currently, TuxOnIce(suspend2) takes about 10 seconds to suspend my notebook.
> Switching to this new scheme would double that to 10 seconds to boot/probe,
> plus the original 10 seconds to hibernate.  Assuming the new implementation
> even comes close to suspend2 speed.

How much RAM is there in your machine?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
