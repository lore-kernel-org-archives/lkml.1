Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYE1LFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYE1LFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 07:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYE1LFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 07:05:04 -0400
Received: from lucidpixels.com ([75.144.35.66]:57019 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbYE1LFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 07:05:03 -0400
Date: Wed, 28 May 2008 07:05:02 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Peter Rabbitson <rabbit+list@rabbit.us>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs
 (mdadm/bonnie++)
In-Reply-To: <483D39D3.4020906@rabbit.us>
Message-ID: <alpine.DEB.1.10.0805280703400.23383@p34.internal.lan>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <483D39D3.4020906@rabbit.us>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 May 2008, Peter Rabbitson wrote:

> Justin Piszcz wrote:
>> Hardware:
>> 
>> 1. Utilized (6) 400 gigabyte sata hard drives.
>> 2. Everything is on PCI-e (965 chipset & a 2port sata card)
>> 
>> Used the following 'optimizations' for all tests.
>> 
>> # Set read-ahead.
>> echo "Setting read-ahead to 64 MiB for /dev/md3"
>> blockdev --setra 65536 /dev/md3
>
> That's actually 65k x 512byte blocks so 32MiB
Ah whoops, thanks!

> Results are meaningless without a crucial detail - what was the chunk size 
> used during array creation time? Otherwise interesting test :)
Indeed, the chunk size used was 256 KiB for all tests.

Justin.

