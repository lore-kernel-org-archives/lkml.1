Return-Path: <linux-kernel-owner+w=401wt.eu-S934056AbXC2IPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934056AbXC2IPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 04:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934051AbXC2IPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 04:15:15 -0400
Received: from smtp.osdl.org ([65.172.181.24]:47009 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934039AbXC2IPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 04:15:12 -0400
Date: Thu, 29 Mar 2007 01:15:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andy Grover" <andrew.grover@intel.com>,
       "Paul Diefenbaugh" <paul.s.diefenbaugh@intel.com>, len.brown@intel.com,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm2 -- ACPI problems (lid switch broken, always
 shows running from AC, plugging in AC hangs machine)
Message-Id: <20070329011503.00c89cb8.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0703290100q1bb80390ke66333407bbeecfd@mail.gmail.com>
References: <a44ae5cd0703281355h13f1bd70s9eb94092bfa9c3e@mail.gmail.com>
	<20070328142000.ebc7712d.akpm@linux-foundation.org>
	<a44ae5cd0703290100q1bb80390ke66333407bbeecfd@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 01:00:45 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:

> On 3/28/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 28 Mar 2007 13:55:54 -0700
> > "Miles Lane" <miles.lane@gmail.com> wrote:
> >
> > > My laptop (HP dv1240us) is always showing that my laptop is plugged
> > > into AC power, even when it is running off of the battery.  When I
> > > plug into the AC after running on the battery, the machine immediately
> > > locks up.  Also, the laptop lid button isn't working -- pressing it
> > > doesn't trigger a suspend.
> >
> > OK, thanks.
> >
> > If you have time, could you please test
> >
> > 2.6.21-rc5 +
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/origin.patch + ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/git-acpi.patch
> > which will allow us to eliminate any non-acpi patches.
> 
> Okay, I tested with those patches and got the same problems with the
> resulting build.
> I can't reproduce the hang on plugging in the AC with either
> 2.6.21-rc5-mm2 or the
> build with the patches you sent.  The other problems are 100% reproducible.
> I have some new details:
> 
> 1.  Power always shows up as plugged in to AC.
> 2.  The lid button is non-operational for initiating a suspend.
> 3.  Suspending from the Gnome shutdown menu works.   Afterwards, the
> lid button works for resuming from suspend.
> 4.  If I suspend, resume and then try to shutdown; when I see the
> message "The machine will now halt" the power does not shut off.  That
> is, the various buttons on my laptop stay lit up.  I am forced to
> shutdown by holding down the power button for five seconds.
> 

Thanks.  So we can conclude that all these problems are due to changes in
2.6.21-rc5-mm2's git-acpi.patch?

