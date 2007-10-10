Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbXJJRG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbXJJRG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 13:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbXJJRGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 13:06:52 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:37369 "EHLO
	outbound4-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755371AbXJJRGv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 13:06:51 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH][try 2] architectural pstate driver for powernow-k8
Date: Wed, 10 Oct 2007 12:06:28 -0500
Message-ID: <1449F58C868D8D4E9C72945771150BDF02077087@SAUSEXMB1.amd.com>
In-Reply-To: <20071010163518.GB6443@alberich.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][try 2] architectural pstate driver for powernow-k8
Thread-Index: AcgLW4yjsacRATojSECkI0uFvArw6wABBnTA
References: <200710091446.38432.mark.langsdorf@amd.com>
 <p73fy0k3ve8.fsf@bingen.suse.de>
 <200710091543.21350.mark.langsdorf@amd.com>
 <20071009234125.GB6879@redhat.com>
 <20071010163518.GB6443@alberich.amd.com>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
       "Dave Jones" <davej@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 10 Oct 2007 17:06:38.0690 (UTC)
 FILETIME=[EBDBAC20:01C80B5F]
X-WSS-ID: 6B13D9152ZC1583002-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Has this been tested on older implementations of powernow yet?
> > I'm happy to merge this and give it some time in -mm, before it
> > goes to mainline, but if no-one is testing on those older
> > opterons/turions etc then we're not going to know we regressed
> > until its too late.   If it hasn't been tested yet, any chance
> > you can scrounge some up at AMD and give it a spin just to be sure?
> 
> 
> I'd like to see this driver in the next kernel release.

Thanks, Andreas.

> So I have done some tests with this code - based on kernel 
> version 2.6.23. I have tested it on Athlon 64 X2, Athlon 64,
> Turion X2 and some other parts
> (e.g.family 0x10) and with different cpufreq governors.
> I did not observe any problems with this driver update.
> Behaviour is the same as before.

I've also been running it on my Turion X2 laptop for a 
few weeks without issues.  It doesn't touch the legacy
code path at all.  

 
> So please consider to add the attached patch for 2.6.24.
> Patch is against current Linus' git tree. This means the patch
> "[CPUFREQ] Support different families in fid/did to frequency 
> conversion" which is contained in the cpufreq.git should
> be ommitted. The issue fixed with that patch is solved
> with this driver update, too.

Either patch is acceptable; I think they're fundamentally
identical anyway.

-Mark Langsdorf
Operating System Research Center
AMD


