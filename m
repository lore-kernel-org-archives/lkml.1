Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbXBVIjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbXBVIjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXBVIjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:39:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42593 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbXBVIjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:39:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: 2.6.20-mm2
Date: Thu, 22 Feb 2007 09:33:37 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <200702202307.45432.rjw@sisk.pl> <200702211957.00930.david-b@pacbell.net>
In-Reply-To: <200702211957.00930.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702220933.37559.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 22 February 2007 04:57, David Brownell wrote:
> On Tuesday 20 February 2007 2:07 pm, Rafael J. Wysocki wrote:
> 
> > > Plus, I'd guess, the old rtc driver statically linked.
> > 
> > Yes (mistakenly).
> 
> Until someone merges the BSOD-for-Linux patch, I'll continue to
> assume that oopsing is the wrong response to "user" mistakes.  ;)
> 
> Legacy drivers can be such a PITA.

Unfortunately, the userland shipped with OpenSUSE refuses to talk to the new
one (or I don't know how to make it do that).

> > > What I see is a should-not-happen fault of some kind in a cleanup
> > > path that's been tested with non-PNP rtc drivers.  A quick glance
> > > at the code left me puzzled.  Would sleeping a second or two before
> > > calling rtc_device_unregister() change that behavior?
> > 
> > [tries]
> > 
> > No.
> 
> Shoot.  OK, I'll see if I can reproduce it myself.  Is this system
> using a generic CMOS RTC?  Or is HPET somehow involved?  (That old
> RTC driver has HPET voodoo as well as normal RTC stuff.)

How can I check that?

Rafael
