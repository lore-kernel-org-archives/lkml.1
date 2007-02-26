Return-Path: <linux-kernel-owner+w=401wt.eu-S1751187AbXBZJ0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbXBZJ0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 04:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbXBZJ0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 04:26:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:28700 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbXBZJ0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 04:26:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,219,1170662400"; 
   d="scan'208"; a="204044987:sNHT18894946"
Subject: Re: [GIT PATCH] ACPI patches for 2.6.21
From: Zhang Rui <rui.zhang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070222155357.GA4692@ucw.cz>
References: <200702071418.51058.lenb@kernel.org>
	 <20070209230928.GD3949@ucw.cz> <200702092327.04237.lenb@kernel.org>
	 <20070222155357.GA4692@ucw.cz>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 17:25:39 +0800
Message-Id: <1172481939.11100.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 15:53 +0000, Pavel Machek wrote: 
> Hi!
> 
> > > > the old /proc/acpi/ interfaces with cleaner interfaces in sysfs --
> > > > non-ACPI-specific generic ones whenever possible.  This effort
> > > > is not complete, but it has been in -mm for a long time and
> > > > I believe that it is time to push it upstream to benefit
> > > > from broader exposure and testing.
> > > 
> > > Does it still include completely broken alarm interface? Can't find it
> > > in changelogs, so hopefully not.
> > 
> > No. See discussion on linux-acpi.
> > David Brownell's RTC driver will provide the new RTC interface in sysfs.
> > /proc/acpi/alarm will go away when the rest of /proc/acpi goes away.
> 
> I guess I should say 'sorry for a flame'. I've seen a discussion
> (linux-pm or somewhere), but did not see the decision to drop the
> offending patch.
> 
Hi, Pavel,
Both the patches that duplicate "alarm" and "wakeup" attributes in sysfs
are dropped. "alarm" attribute can be replaced by the new RTC driver.
And the "wakeup" attribute are in the wish list now.
You can get more details from the original mail.

http://marc.theaimsgroup.com/?l=linux-acpi&m=116910315512529&w=2

Thanks,
Rui
