Return-Path: <linux-kernel-owner+w=401wt.eu-S1764671AbXJRSF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764671AbXJRSF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 14:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbXJRSFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 14:05:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:28202 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776AbXJRSFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 14:05:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,296,1188802800"; 
   d="scan'208";a="250289621"
Date: Thu, 18 Oct 2007 10:56:01 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [PATCH 0/3] Fix two PEIe hotplug issues
Message-Id: <20071018105601.27d96f7e.kristen.c.accardi@intel.com>
In-Reply-To: <20071018174925.GB4927@thunk.org>
References: <4716CB9D.6080503@rtr.ca>
	<4716CE79.7040201@rtr.ca>
	<20071018091347.4b94faf8.kristen.c.accardi@intel.com>
	<4717928D.6070703@rtr.ca>
	<20071018100614.435fe88c.kristen.c.accardi@intel.com>
	<20071018174925.GB4927@thunk.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 13:49:25 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Thu, Oct 18, 2007 at 10:06:14AM -0700, Kristen Carlson Accardi wrote:
> > No, it actually does violate the spec.  Feel free to read it yourself.
> > We are not supposed to do Native PCIe without first successfully executing
> > OSC.  Period.  If you do, you are violating the spec.
> 
> To be fair, we have violated the spec before in order to get crappy
> hardware or to work around crappy ACPI implementations.
> acpi_sleep=s3_bios for example violates the spec, but yet it is the
> only way to get certain laptops to suspend/resume correctly.  
> 
> The question to ask is whether violating the spec will lead to (a) a
> potential system hang/crash, (b) data corruption, (c) physical harm to
> the device/laptop.
> 
> Regards,
> 
> 						- Ted
> 

And the answer is most definitely yes to at least a) and c) on specific
hardware I know about.
