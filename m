Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZHNTMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZHNTMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 15:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756931AbZHNTML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 15:12:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40569 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756927AbZHNTML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 15:12:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
Date: Fri, 14 Aug 2009 21:12:38 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <Pine.LNX.4.44L0.0908141044220.2987-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908141044220.2987-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908142112.38557.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Alan Stern wrote:
> On Thu, 13 Aug 2009, Rafael J. Wysocki wrote:
> 
> > > No, I've only tested it with a few selected drivers.  I'm going to try the
> > > "async everyone" scenario, though.
> > 
> > On HP nx6325 booted with init=/bin/bash it doesn't pass the
> > 'echo devices > /sys/power/pm_test && echo mem > /sys/power/state' test.
> > 
> > The suspend part actually seems to work, but the resume part crashes
> > miserably.
> 
> Any details?  Can you tell where it crashes?

Unfortunately it ends up in a continuous flood of backtraces, so I can't
say much.

However, if I set async_suspend for all PCI devices, as well as for ACPI battery
and i8042, everything apparently works, even with real suspend-resume.

Thanks,
Rafael
