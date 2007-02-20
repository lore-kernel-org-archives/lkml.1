Return-Path: <linux-kernel-owner+w=401wt.eu-S1030479AbXBTWN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030479AbXBTWN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965261AbXBTWN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:13:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34356 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965257AbXBTWN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:13:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: 2.6.20-mm2
Date: Tue, 20 Feb 2007 23:07:44 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <20070218162822.3fd10212.akpm@linux-foundation.org> <200702182113.03481.david-b@pacbell.net>
In-Reply-To: <200702182113.03481.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702202307.45432.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 19 February 2007 06:13, David Brownell wrote:
> On Sunday 18 February 2007 4:28 pm, Andrew Morton wrote:
> > On Mon, 19 Feb 2007 00:32:08 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> 
> > > One more thing:
> > > 
> > > rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
> > > Unable to handle kernel NULL pointer dereference at 0000000000000030 RIP: 
> > >  [<ffffffff804032c3>] rtc_sysfs_remove_device+0x23/0x50
> > > 	...
> > > Call Trace:
> > >  [<ffffffff803c5786>] class_device_del+0x86/0x180
> > >  [<ffffffff803c5891>] class_device_unregister+0x11/0x20
> > >  [<ffffffff8040280e>] rtc_device_unregister+0x3e/0x50
> > >  [<ffffffff880cd789>] :rtc_cmos:cmos_pnp_probe+0x219/0x240
> > >  [<ffffffff803988a1>] pnp_device_probe+0xa1/0xe0
> > >  ...
> > 
> > How did you provoke that?  modprobe rtc-cmos?
> 
> Plus, I'd guess, the old rtc driver statically linked.

Yes (mistakenly).

> What I see is a should-not-happen fault of some kind in a cleanup
> path that's been tested with non-PNP rtc drivers.  A quick glance
> at the code left me puzzled.  Would sleeping a second or two before
> calling rtc_device_unregister() change that behavior?

[tries]

No.

Greetings,
Rafael
