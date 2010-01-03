Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945Ab0ACVBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab0ACVBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 16:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383Ab0ACVBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 16:01:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50760 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab0ACVBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 16:01:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 12/12] PM / r8169: Add simplified run-time PM support
Date: Sun, 3 Jan 2010 22:01:14 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Len Brown <lenb@kernel.org>
References: <200911160047.46299.rjw@sisk.pl> <201001022149.05553.rjw@sisk.pl> <20100103195544.GC11928@elf.ucw.cz>
In-Reply-To: <20100103195544.GC11928@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001032201.14087.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 January 2010, Pavel Machek wrote:
> 
> > > On notebooks, you can often use
> > > 
> > > pavel@amd:/data/l/linux-msm/arch/arm/mach-msm$ cat
> > > /proc/acpi/battery/BAT0/state 
> > > present:                 yes
> > > capacity state:          ok
> > > charging state:          charged
> > > present rate:            0 mW
> > > remaining capacity:      71830 mWh
> > > present voltage:         16277 mV
> > > 
> > > ...present rate is often usable-enough.
> > 
> > Using /proc/acpi/battery/BAT1/state I measured the energy drawn in 10 minutes
> > both with the network adapter in D0 and D3hot.  The results were that with the
> > network adapter in D0 the box drew 2476 mWh, while with the network adapter in
> > D3hot it drew 2361 mWh.  The difference is 115 mWh, or about 5% on this
> > particular box.
> > 
> > This means about 0.1 Wh in 10 minutes, so we can save about 0.6 Wh per hour.
> 
> Which means it saves 0.6W :-). Measuring power in Wh/h is "interesting".

You can't save power, you can only save energy.  Wh is just an energy unit.

> Ok, that's consistent with my experiments, ethernet transciever was around 1W... Thanks.

No big deal.

Rafael
