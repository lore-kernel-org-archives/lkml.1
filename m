Return-Path: <linux-kernel-owner+w=401wt.eu-S1765629AbXJRRtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765629AbXJRRtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758312AbXJRRtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:49:32 -0400
Received: from thunk.org ([69.25.196.29]:59332 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758153AbXJRRtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:49:31 -0400
Date: Thu, 18 Oct 2007 13:49:25 -0400
From: Theodore Tso <tytso@mit.edu>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [PATCH 0/3] Fix two PEIe hotplug issues
Message-ID: <20071018174925.GB4927@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Mark Lord <lkml@rtr.ca>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
	pcihpd-discuss@lists.sourceforge.net
References: <4716CB9D.6080503@rtr.ca> <4716CE79.7040201@rtr.ca> <20071018091347.4b94faf8.kristen.c.accardi@intel.com> <4717928D.6070703@rtr.ca> <20071018100614.435fe88c.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018100614.435fe88c.kristen.c.accardi@intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 10:06:14AM -0700, Kristen Carlson Accardi wrote:
> No, it actually does violate the spec.  Feel free to read it yourself.
> We are not supposed to do Native PCIe without first successfully executing
> OSC.  Period.  If you do, you are violating the spec.

To be fair, we have violated the spec before in order to get crappy
hardware or to work around crappy ACPI implementations.
acpi_sleep=s3_bios for example violates the spec, but yet it is the
only way to get certain laptops to suspend/resume correctly.  

The question to ask is whether violating the spec will lead to (a) a
potential system hang/crash, (b) data corruption, (c) physical harm to
the device/laptop.

Regards,

						- Ted
