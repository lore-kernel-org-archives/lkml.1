Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbYGOFeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbYGOFeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbYGOFd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:33:57 -0400
Received: from mail.lang.hm ([64.81.33.126]:50195 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbYGOFd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:33:57 -0400
Date: Mon, 14 Jul 2008 22:34:57 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: David Woodhouse <dwmw2@infradead.org>
cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from	in-kernel,
 use it in more drivers.
In-Reply-To: <1216090479.27455.180.camel@shinybook.infradead.org>
Message-ID: <alpine.DEB.1.10.0807142233070.6370@asgard>
References: <20080714165956.7fe2d4ee@infradead.org>  <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>  <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>  <20080714.185012.245476473.davem@davemloft.net>
 <1216090479.27455.180.camel@shinybook.infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, David Woodhouse wrote:

> On Mon, 2008-07-14 at 18:50 -0700, David Miller wrote:
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>> Date: Mon, 14 Jul 2008 17:33:58 -0700 (PDT)
>>
>>> The only reliable way to handle it is to load the firmware before the
>>> suspend happens - preferably by simply never unloading it in the first
>>> place.
>>
>> That's what we were told was the huge benefit of moving some
>> of these drivers over to this request_firmware() stuff, it would
>> save memory.
>
> There _are_ RAM benefits for a number of drivers, even when you load the
> firmware just once at initialisation time and keep it resident all the
> time the device is active (and no, I won't slap myself for saying it).
>
> The tg3 driver is a prime example -- it contains three separate firmware
> images for different revisions of the card, but you'll almost never
> actually need all three. Mostly you'll only need _one_ of them.

and when a card gets hotplugged into the system for a driver that's 
already in memory handling other cards you intend that it will have to go 
out to userspace to find the firmware?

how much memory are you expecting to save this way?

David Lang
