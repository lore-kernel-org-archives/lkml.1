Return-Path: <linux-kernel-owner+w=401wt.eu-S933778AbXHYIFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbXHYIFO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 04:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932621AbXHYIEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 04:04:48 -0400
Received: from tag.witbe.net ([81.88.96.48]:59956 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765093AbXHYIEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 04:04:45 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Aug 2007 04:04:44 EDT
Date: Sat, 25 Aug 2007 09:55:13 +0200
From: Paul Rolland <rol@as2917.net>
To: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tilman Schmidt <tilman@imap.cc>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>, Thomas Renninger <trenn@suse.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, rol@witbe.net
Subject: Re: 2.6.23-rc3-mm1
Message-ID: <20070825095513.699423f3@tux.DEF.witbe.net>
In-Reply-To: <20070825042809.GA15863@redhat.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<46CF695D.1020008@imap.cc>
	<20070824170702.a2c51084.akpm@linux-foundation.org>
	<46CF7C3F.10707@imap.cc>
	<20070824203000.1d710cee.akpm@linux-foundation.org>
	<20070825042809.GA15863@redhat.com>
Organization: AS2917.net
X-Mailer: Claws Mail 3.0.0-rc1 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, 25 Aug 2007 00:28:09 -0400
Dave Jones <davej@redhat.com> wrote:

> On Fri, Aug 24, 2007 at 08:30:00PM -0700, Andrew Morton wrote:
>  
>  > >  <6>Linux agpgart interface v0.102
>  > > +<6>rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
>  > > +<4>rtc_cmos: probe of 00:03 failed with error -16
>  > > +<6>agpgart: suspend/resume problematic: resume with 3D/DRI active
>  > > may lockup X.Org +<4>on some chipset/BIOS combos (see DEBUG_AGP_PM
>  > > in intel-agp.c) <6>agpgart: Detected an Intel 965Q Chipset.
>  > >  <6>agpgart: Unknown page table size, assuming 512KB
>  > >  <6>agpgart: Detected 7676K stolen memory.
>  > >  <6>agpgart: AGP aperture is 256M @ 0x40000000
>  > > -<6>rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
>  > > -<4>rtc_cmos: probe of 00:03 failed with error -16
>  > 
>  > I wonder if that was supposed to happen.  It's also happening in
>  > 2.6.23-rc3 base.
>  
> EBUSY. I've seen this happen when you have both CONFIG_RTC and
> CONFIG_RTC_DRV_CMOS set.

This one is becoming quite worth an entry in a FAQ, it pops up one every
month ;)
There was a discussion about preventing both being set at the same time
when configuring, but I don't remember how it ends... 

Paul


