Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbYKPJMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbYKPJMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 04:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYKPJLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 04:11:44 -0500
Received: from lucidpixels.com ([75.144.35.66]:42500 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbYKPJLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 04:11:42 -0500
Date: Sun, 16 Nov 2008 04:11:40 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Tejun Heo <tj@kernel.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
In-Reply-To: <491FBA29.3000803@kernel.org>
Message-ID: <alpine.DEB.1.10.0811160410510.27319@p34.internal.lan>
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan> <491E4092.5030804@shaw.ca> <20081115103424.34f01370@lxorguk.ukuu.org.uk> <491FBA29.3000803@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Nov 2008, Tejun Heo wrote:

> Alan Cox wrote:
>> On Fri, 14 Nov 2008 21:22:58 -0600
>> Robert Hancock <hancockr@shaw.ca> wrote:
>>
>>> Justin Piszcz wrote:
>>>> I am trying to find out what the root cause of this error/problem is:
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=462425
>>> The problem is that people assume that timeouts with DRDY like that bug
>>> refers to must be the same problem when it is often not
>>
>> The first stopping point is to apply the DRQ drain patch I sent to the
>> list some time ago and is hopefully lined up for 2.6.29. After that point
>> you can begin to look at the remaining cases, until then its hardly worth
>> it.
>
> Is it really?  For many SATA controllers, DRQ draining isn't really
> necessary.  PATA might be a completely different story tho.

I have been running with the patch for almost 24 hours and running 
extensive disk tests, so far nothing but sometimes it takes a few days 
or more to repeat, I am continuing to test to see if the problem recurs..

Justin.
