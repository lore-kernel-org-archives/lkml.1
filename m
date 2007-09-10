Return-Path: <linux-kernel-owner+w=401wt.eu-S1761402AbXIJVF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbXIJVF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 17:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbXIJVFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 17:05:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:25480 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbXIJVFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 17:05:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,233,1186383600"; 
   d="scan'208";a="292062343"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch] enable userspace cpu core voltage control withacpi-cpufreq
Date: Mon, 10 Sep 2007 14:04:05 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F5015DB050@scsmsx415.amr.corp.intel.com>
In-Reply-To: <20070903152457.GC21586@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] enable userspace cpu core voltage control withacpi-cpufreq
Thread-Index: AcfuPwNAKmp9HOwORfuMDSYCMW2ALAFrokLA
References: <200709021441.l82EfWCe022642@mail.mc.o2online.de> <p738x7oaugi.fsf@bingen.suse.de> <20070903152457.GC21586@redhat.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Dave Jones" <davej@redhat.com>, "Andi Kleen" <andi@firstfloor.org>
Cc: <colin.michael@o2online.de>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Sep 2007 21:05:14.0586 (UTC) FILETIME=[48678BA0:01C7F3EE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Dave Jones
>Sent: Monday, September 03, 2007 8:25 AM
>To: Andi Kleen
>Cc: colin.michael@o2online.de; linux-kernel@vger.kernel.org
>Subject: Re: [patch] enable userspace cpu core voltage control 
>withacpi-cpufreq
>
>On Mon, Sep 03, 2007 at 12:56:13PM +0200, Andi Kleen wrote:
> > <colin.michael@o2online.de> writes:
> > 
> > > i want to make a patch known that provides a userspace 
>interface to control the core voltage of a computer processor(s).
> > 
> > That would be essentially linux supported undervolting which 
> > for stability is as bad as overclocking. The problem is that 
> > such games tend to generate weird kernel crashes and then
> > chew up development issues when kernel hackers have to chase
> > ghost bugs. I don't think we should support it. Developer 
> > time is too precious.
> 
>Seconded.  Exactly the same reasons I've refused to merge patches
>into cpufreq to allow arbitrary tables to override BIOS tables.
>Or patches to remove boundary checks.   Even when correctly
>implemented, this stuff can be fragile as hell, so introducing
>more things that cast doubt over its stability isn't something
>I'm keen on at all.
>

And acpi-cpufreq does not seem to be the place to be doing this. I would
say it should be a new driver or go into speedstep-centrino which has
similar user defined freq voltage values. Ideally a standalone driver so
that users do not get confused with single driver working in different
modes and distributors can choose not to ship it in case where they do
not like the driver tainting the kernel.

Thanks,
Venki
