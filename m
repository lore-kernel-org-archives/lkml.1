Return-Path: <linux-kernel-owner+w=401wt.eu-S1751267AbXC0Jzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbXC0Jzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 05:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXC0Jzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 05:55:46 -0400
Received: from lucidpixels.com ([75.144.35.66]:52122 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbXC0Jzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 05:55:45 -0400
Date: Tue, 27 Mar 2007 05:55:44 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
In-Reply-To: <20070324184300.3250fab0@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0703270554320.31853@p34.internal.lan>
References: <Pine.LNX.4.64.0703241232580.11608@p34.internal.lan>
 <20070324184300.3250fab0@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 24 Mar 2007, Alan Cox wrote:

> On Sat, 24 Mar 2007 12:38:02 -0400 (EDT)
> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>> Without NCQ, performance is MUCH better on almost every operation, with
>> the exception of 2-3 items.
>
> It depends on the drive. Generally NCQ is better but some drive firmware
> isn't too bright and there are probably still cases where we get bad
> interactions in the kernel code that want tuning too
>

Checking the benchmarks on various hardware websites, anandtech, 
hothardware and others, they generally all come to the same conclusion if 
there is only 1 thread using I/O (single user system) then NCQ off is the 
best.  I see 30-50MB/s faster speeds with NCQ turned off on two different 
SW RAID5s.

Justin.
