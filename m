Return-Path: <linux-kernel-owner+w=401wt.eu-S933836AbXHIBbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836AbXHIBbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 21:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbXHIBay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 21:30:54 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:43962
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbXHIBax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 21:30:53 -0400
Date: Wed, 8 Aug 2007 18:26:24 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Greg Trounson <gregt@maths.otago.ac.nz>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
In-Reply-To: <46BA6667.1070205@maths.otago.ac.nz>
Message-ID: <Pine.LNX.4.64.0708081824070.9909@asgard.lang.hm>
References: <20070804103347.GA1956@elte.hu>
 <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
 <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>
 <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org>
 <20070804192130.GA25346@elte.hu> <20070804211156.5f600d80@the-village.bc.nu>
 <20070804202830.GA4538@elte.hu> <20070804224834.5187f9b7@the-village.bc.nu>
 <20070805071320.GC515@elte.hu> <46BA6667.1070205@maths.otago.ac.nz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Greg Trounson wrote:

>>  Measurements show that noatime helps 20-30% on regular desktop workloads,
>>  easily 50% for kernel builds and much more than that (in excess of 100%)
>>  for file-read-intense workloads. We cannot just walk past such a _huge_
>>  performance impact so easily without even reacting to the performance
>>  arguments, and i'm happy Ubuntu picked up noatime,nodiratime and is
>>  whipping up the floor with Fedora on the desktop.
>> 
>
> Sorry I'm just not seeing those gains here.  With my filesystems mounted with 
> atime defaults the Quake sources build in 1m28.856s.  A test with ls -ltu 
> verifies that atime is working as expected.  When I remount my filesystems 
> with:
> mount [fs] -o remount,noatime,nodiratime
> I get a compile time of 1m23.368s, a mere 6% improvement.
>
> This is on a dual-core Athlon 4200+ box running 2.6.21, so I would have 
> thought this to be close to a best-case file I/O test.

what sort of disks does this box have? and what filesystem? slower 
disks/filesystems can result in this showing a larger difference.

however 6% is a fairly significant gain.

David Lang
