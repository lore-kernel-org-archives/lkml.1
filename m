Return-Path: <linux-kernel-owner+w=401wt.eu-S1762557AbXJRV1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762557AbXJRV1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 17:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbXJRV07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 17:26:59 -0400
Received: from rtr.ca ([76.10.145.34]:3138 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbXJRV06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 17:26:58 -0400
Message-ID: <4717CFA0.2030901@rtr.ca>
Date: Thu, 18 Oct 2007 17:26:56 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [PATCH 0/3] Fix two PEIe hotplug issues
References: <4716CB9D.6080503@rtr.ca> <4716CE79.7040201@rtr.ca> <20071018091347.4b94faf8.kristen.c.accardi@intel.com> <4717928D.6070703@rtr.ca> <20071018100614.435fe88c.kristen.c.accardi@intel.com> <20071018174925.GB4927@thunk.org>
In-Reply-To: <20071018174925.GB4927@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Thu, Oct 18, 2007 at 10:06:14AM -0700, Kristen Carlson Accardi wrote:
>> No, it actually does violate the spec.  Feel free to read it yourself.
>> We are not supposed to do Native PCIe without first successfully executing
>> OSC.  Period.  If you do, you are violating the spec.
> 
> To be fair, we have violated the spec before in order to get crappy
> hardware or to work around crappy ACPI implementations.
> acpi_sleep=s3_bios for example violates the spec, but yet it is the
> only way to get certain laptops to suspend/resume correctly.  

If we religiously relied upon BIOS support for everything in Linux,
then SATA drives wouldn't be doing anything more than emulating PATA,
and we'd still be doing PIO transfers for most PATA drives.

And ditto for many other areas in the kernel,
but that's the main one that I know a bit about. 

> The question to ask is whether violating the spec will lead to (a) a
> potential system hang/crash, (b) data corruption, (c) physical harm to
> the device/laptop.

So far, after a couple of days of intensive (disk!) I/O over the slot,
the answers are NO, NO, and NO.

Cheers
