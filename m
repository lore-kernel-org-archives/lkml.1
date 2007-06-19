Return-Path: <linux-kernel-owner+w=401wt.eu-S1761402AbXFSSYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbXFSSYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759132AbXFSSYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:24:34 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:44185
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882AbXFSSYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:24:33 -0400
Date: Tue, 19 Jun 2007 11:24:30 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Chris Mason <chris.mason@oracle.com>
cc: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
In-Reply-To: <20070619120457.GD14108@think.oraclecorp.com>
Message-ID: <Pine.LNX.4.64.0706191121260.25045@asgard.lang.hm>
References: <20070612161029.GB28279@think.oraclecorp.com> <4676C2D6.8030708@vlnb.net>
 <46779DB1.7060807@draigBrady.com> <20070619120457.GD14108@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Chris Mason wrote:

>>> 3. De-de-duplicate blocks on disk, i.e. copy them on write
>>>
>>> I suppose that de-duplication itself would be done by some user space
>>> process that would scan files, determine blocks with the same data and
>>> then de-duplicate them by using syscall or IOCTL (2).
>>>
>>> That would be very usable feature, which in most cases would allow to
>>> shrink occupied disk space on 50-90%.
>>
>> Have you references for this number?
>> In my experience one gets a lot of benefit from
>> the much simpler process of "de-duplication" of files.
>
> Yes, I would expect simple hard links to be a better solution for this,
> but the feature request is not that out of line.  I actually had plans
> on implementing auto duplicate block reuse earlier in btrfs.

with COW de-duplication you can merge things that have vastly different 
permissions. hard-links can't be used if different people have write 
permission.

David Lang

