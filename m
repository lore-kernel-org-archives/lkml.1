Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315AbYCSTgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbYCSTgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbYCST2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:28:18 -0400
Received: from mail.lang.hm ([64.81.33.126]:54855 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbYCST2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:28:15 -0400
Date: Tue, 18 Mar 2008 09:36:28 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: David Newall <davidn@davidnewall.com>
cc: Daniel Phillips <phillips@phunq.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
In-Reply-To: <47DFBD99.2080501@davidnewall.com>
Message-ID: <alpine.DEB.1.00.0803180933230.21250@asgard.lang.hm>
References: <200803092346.17556.phillips@phunq.net> <alpine.DEB.1.00.0803170740440.14887@asgard.lang.hm> <alpine.DEB.1.00.0803171021300.17640@asgard.lang.hm> <200803180233.10156.phillips@phunq.net> <47DFBD99.2080501@davidnewall.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008, David Newall wrote:

> Daniel Phillips wrote:
>> You will need:
>>
>>   * Two Violin 1010 memory devices
>>
>>   * Four UPS units each rated for one hour at 600 Watts
>>
>>   * Two servers, each with at least two 8x PCI-e slots
>>
>>   * One SAN with a bunch of 15K rpm scsi disks
>>
>
>
> Honestly, this isn't at all what I understood you to be talking about.
> In your very first post you described ramback as "a new virtual device
> with the ability to back a ramdisk by a real disk."  I assumed "ramdisk"
> to mean the Linux psuedo-device.  I never understood that you meant an
> external device, in fact I thought ramback was *instead of* a Violin.
> Since you're talking about external ram, it survives operating system
> crashes and of course that is not such a big deal as I was thinking.

I agree. I didn't think ramback was just an advertising mechanism for 
violin, I thought it was being presented as something that could be used 
with enterprise hardware like the Sun x4600 (which can hold 256G of ram) 
and that talk of the violin was just the claim that lots of ram is 
available so this was a possibility now.

David Lang

P.S. 8xPCI-e slots are only able to do 2GB/s of data transfer, in an 
earlier post Daniel claimed that you needed 3GB/s of disk to mirror to the 
disk, so the scenerio listed above looses 1/3 of it's performance compared 
to what was being claimed earlier.
