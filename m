Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYGGTk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYGGTk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbYGGTkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:40:14 -0400
Received: from lucidpixels.com ([75.144.35.66]:41122 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015AbYGGTkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:40:12 -0400
Date: Mon, 7 Jul 2008 15:40:10 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
cc: Alan Piszcz <ap@solarrain.com>
Subject: Re: 12 Veliciraptors again w/x4 card (1.1gbytes/sec aggregate
 read)!
In-Reply-To: <alpine.DEB.1.10.0807071442570.4709@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0807071539520.5574@p34.internal.lan>
References: <alpine.DEB.1.10.0807071424100.4694@p34.internal.lan> <alpine.DEB.1.10.0807071436080.5166@p34.internal.lan> <alpine.DEB.1.10.0807071442570.4709@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jul 2008, Justin Piszcz wrote:

>
>
> On Mon, 7 Jul 2008, Justin Piszcz wrote:
>
>> 
>> 
>> On Mon, 7 Jul 2008, Justin Piszcz wrote:
>> 
>>> Each PCI-e x1 card has 1 veliciraptor on it now.
>>> Got an x4 card wit 4 sata ports:
>>> 
>>> Not quite the > 1 gbyte/sec I was hoping for in regards to the reads
>>> but pretty close!
>> 
>> Going to remove one of the drives from the x1 card and put it on the x4
>> card instead, then I will use all 4 SATA ports on the x4 and hopefully get
>> better bw.
>> 
>
> Four drives on the x4 card, MAX bandwidth for every disk.
>
> p34:~# dd if=/dev/sdi of=/dev/null bs=1M &
> [1] 4720
> p34:~# dd if=/dev/sdj of=/dev/null bs=1M &
> [2] 4721
> p34:~# dd if=/dev/sdk of=/dev/null bs=1M &
> [3] 4722
> p34:~# dd if=/dev/sdl of=/dev/null bs=1M &
> [4] 4723
> p34:~#
>
> 120MiB/s per each one!
>
> Re-running dd test with all 12 disks:
>
> 1.1 gigabytes per second read!
>

bonnie++ benchmarks:

http://home.comcast.net/~jpiszcz/20080707/veliciraptors_with_x4.html

