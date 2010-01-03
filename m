Return-Path: <linux-kernel-owner+w=401wt.eu-S1752383Ab0ACTzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab0ACTzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 14:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116Ab0ACTzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 14:55:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57996 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab0ACTzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 14:55:53 -0500
Date: Sun, 3 Jan 2010 20:55:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
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
Subject: Re: [RFC][PATCH 12/12] PM / r8169: Add simplified run-time PM
 support
Message-ID: <20100103195544.GC11928@elf.ucw.cz>
References: <200911160047.46299.rjw@sisk.pl>
 <200912272048.37332.rjw@sisk.pl>
 <20091227200147.GJ11737@elf.ucw.cz>
 <201001022149.05553.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001022149.05553.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > On notebooks, you can often use
> > 
> > pavel@amd:/data/l/linux-msm/arch/arm/mach-msm$ cat
> > /proc/acpi/battery/BAT0/state 
> > present:                 yes
> > capacity state:          ok
> > charging state:          charged
> > present rate:            0 mW
> > remaining capacity:      71830 mWh
> > present voltage:         16277 mV
> > 
> > ...present rate is often usable-enough.
> 
> Using /proc/acpi/battery/BAT1/state I measured the energy drawn in 10 minutes
> both with the network adapter in D0 and D3hot.  The results were that with the
> network adapter in D0 the box drew 2476 mWh, while with the network adapter in
> D3hot it drew 2361 mWh.  The difference is 115 mWh, or about 5% on this
> particular box.
> 
> This means about 0.1 Wh in 10 minutes, so we can save about 0.6 Wh per hour.

Which means it saves 0.6W :-). Measuring power in Wh/h is
"interesting". Ok, that's consistent with my experiments, ethernet
transciever was around 1W... Thanks.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
