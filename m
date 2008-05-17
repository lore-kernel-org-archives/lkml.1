Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbYEQPVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbYEQPVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbYEQPUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:20:51 -0400
Received: from mx1.ukfsn.org ([77.75.108.10]:57502 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755520AbYEQPUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:20:50 -0400
Message-ID: <482EF7D0.2030309@dgreaves.com>
Date: Sat, 17 May 2008 16:20:48 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080406)
MIME-Version: 1.0
To: Oliver Pinter <oliver.pntr@gmail.com>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, David Chinner <dgc@sgi.com>,
       LinuxRaid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Regression- XFS won't mount on partitioned md array
References: <482DC043.5000307@dgreaves.com>	 <alpine.DEB.1.10.0805161316100.3118@p34.internal.lan>	 <482DCCCD.8020503@dgreaves.com> <6101e8c40805161135w7470123uaac93ca59caee026@mail.gmail.com> <482EF026.9000206@dgreaves.com>
In-Reply-To: <482EF026.9000206@dgreaves.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves wrote:
> Oliver Pinter wrote:
>> this[1] patch fixed?
>>
>> 1:
> http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=queue-2.6.25/block-do_mounts-accept-root-non-existant-partition.patch;h=097cda9928b434994dbb157065b2ca38e7cec3a1;hb=8cc4c3b370d59deb16c2e92165a466c82e914020
> 
> 
> Looks like a possible candidate - thanks.
> 
> I think this patch is for mounting root on an md device when the partitions
> aren't yet initialised.
> 
> However:
> * When I run cfdisk I can read the partition table.
> * Subsequent attempts to mount the xfs when /proc/partitions is clearly present
> still fail.
> 
>> this patch is for 2.6.25.5 kernel
> ? there isn't a 2.6.25.5
Sorry, I understand; it's queued for 2.6.25.5.

> It doesn't apply to 2.6.25.4
> 
> I'll see if I can make it apply...
Yep - it was download corruption.

Applied but it didn't help.

David

