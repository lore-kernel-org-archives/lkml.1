Return-Path: <linux-kernel-owner+w=401wt.eu-S1945911AbXDCUcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945911AbXDCUcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945915AbXDCUcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:32:47 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:47473 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945911AbXDCUcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:32:46 -0400
Message-ID: <4612B9D1.4060404@cosmosbay.com>
Date: Tue, 03 Apr 2007 22:32:17 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403172736.GA23689@one.firstfloor.org> <46128F47.2010107@redhat.com> <20070403174457.GA15704@linux-os.sc.intel.com> <4612B12A.30609@redhat.com> <20070403201316.GC15704@linux-os.sc.intel.com> <4612B6C1.8080509@redhat.com>
In-Reply-To: <4612B6C1.8080509@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 03 Apr 2007 22:32:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper a écrit :
> Siddha, Suresh B wrote:
>> No. Logical cpu hotplug uses these interfaces to make a cpu go offline
>> and online.
> 
> You missed my sarcasms, email is bad for conveying it.  The point is
> nobody really cares about that hotplug nonsense to have noticed the bug.
>  And still does this nonsense prevent real problems from being addressed.
> 

Please dont focus on /sys being your holy gral.

1) AFAIK /sys/devices/system/cpu was not designed to meet glibc needs.

2) Many production machines dont mount /sys at all

$ uname -r
2.6.20
$ ls -al /sys/devices/system/cpu
ls: /sys/devices/system/cpu: No such file or directory
$ grep processor /proc/cpuinfo
processor       : 0
processor       : 1

