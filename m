Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbYABQKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbYABQKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759635AbYABQJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:09:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:33210 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759617AbYABQJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:09:52 -0500
Date: Wed, 2 Jan 2008 17:09:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Yi Yang <yi.y.yang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net
Subject: Re: [PATCH linux-acpi] Correct wakeup set error and append a new column PCI ID
Message-ID: <20080102160943.GA17187@ucw.cz>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com> <1198744900.3640.4.camel@yangyi-dev.bj.intel.com> <1198916553.3806.2.camel@yangyi-dev.bj.intel.com> <20080101232011.GA2545@ucw.cz> <1199239440.3806.18.camel@yangyi-dev.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199239440.3806.18.camel@yangyi-dev.bj.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-01-02 10:03:59, Yi Yang wrote:
> On Wed, 2008-01-02 at 00:20 +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > /proc/acpi/wakeup is also case-sensitive, case-insensitive is better.
> > 
> > Why?
> A user uses device bus id like 'C093' to enable or disable wakeup of the
> device, for example
> 
> echo "C093" > /proc/acpi/wakeup
> 
> but i think "c093" should also be ok. i.e.

Why do you think so? Unix is generally case-sensitive. I see ascii
text in .../wakeup. Maybe some bios vendor is crazy enough to have
wakeup devices called 'wake', 'Wake', 'wAke', 'waKe', 'wakE'?

> > Maybe this file should be left for compatibility and we should present
> > something reasonable in /sys? Can't you already get PCI ID from sysfs
> > node?
> PCI ID can be gotten from sysfs, but it is a unique identifier for a
> device, a user can get device name from /usr/share/hwdata/pci.ids in any
> dstribution by PCI ID, he/she is unnecessary to use bus number to get
> device name, bus number is platform-specific, but PCI ID is
> platform-independent.

If the same info can be gotten from 'sysfs node' field, new field
should not be added.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
