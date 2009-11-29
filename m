Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbZK2Auz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbZK2Auz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 19:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZK2Auz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 19:50:55 -0500
Received: from bar.sig21.net ([80.81.252.164]:58378 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZK2Auy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 19:50:54 -0500
Date: Sun, 29 Nov 2009 01:51:57 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Greg KH <greg@kroah.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Mikhail Malygin <mmalygin@ked.de>,
       Hans Werner <hwerner4@gmx.de>, Tejun Heo <tj@kernel.org>,
       Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Samsung N130 ATA exception after 5min uptime -- Phoenix
 FailSafe issue?
Message-ID: <20091129005157.GA6487@sig21.net>
References: <20091126164212.GA24421@sig21.net>
 <20091128191932.GB24048@kroah.com>
 <4B11886E.3030906@gmail.com>
 <20091128213446.GA26420@kroah.com>
 <20091128222203.GA369@sig21.net>
 <20091129001745.GA29143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091129001745.GA29143@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.793,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 04:17:45PM -0800, Greg KH wrote:
> On Sat, Nov 28, 2009 at 11:22:03PM +0100, Johannes Stezenbach wrote:
> > 
> > BTW, at 5min after boot it is 99% guaranteed that this ATA
> > exception will happen during the occasional fsck. That
> > doesn't feel right.
> 
> Well, I've never been doing a fsck at 5 minutes into boot, and neither do
> most Windows users :)

I've been through a lot of reboots with all the testing, and
the fsck took longer than 5min, and the ATA exception  struck.
fsck continued after the 30 second stall and succeeded.

> > but it would be better they'd support ACPI.
> > I mean if they have to support it for Windows 7 anyway, then
> > what's the point of not supporting it for other OSs?
> 
> Hey, no argument from me here, but I think the main issue is that they
> do not officially support Windows 7 on this platform yet either.  Hence,
> no ACPI support.  The ACPI support in the latest BIOS seems very rough,
> I think this is the first time they have ever implemented ACPI, so I
> would not count on it working properly just yet.

You can buy it officially with Windows 7 now, it seems to be fully supported.
http://www.samsung.com/us/consumer/office/mobile-computing/netbooks/NP-N130-KA04US/index.idx?pagetype=prd_detail&tab=support

> > While were at it I have another question:  When running on battery the
> > ethernet throughput drops to ~25Mbit/s.  After a bit of experimenting
> > I found that this is connected to a BIOS entry about "CPU Power
> > Saving Mode".  lspci shows that this changes "LnkCtl: ASPM L1
> > Enabled" to "LnkCtl: ASPM L0s L1 Enabled".  Having this config
> > option in the BIOS is inflexible.  IIRC there was an app in
> > Windows which allows to configure it at runtime.  Do you
> > know how to do it in Linux?
> 
> I do not konw anything about this.  Are you saying that Windows would
> allow you to turn the throughput back up at the expense of battery life
> through an application?  Do you know what that application is called and
> where I could find it?

I haven't actually tested throughput in Windows, but ISTR that there was
a Samsung app where you could configure various power saving features.
Might have been the "SAMSUNG Battery Manager".


Thanks,
Johannes
