Return-Path: <linux-kernel-owner+w=401wt.eu-S1756333AbZAMFR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbZAMFR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 00:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZAMFRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 00:17:50 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:57643 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZAMFRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 00:17:49 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=Sr9ZYj3oQJ5vTKhy-64A:9 a=3SU-q8TEXiryLuWWN-wxivimNpcA:4 a=kNAwe-3CODUA:10 a=XK7UU1QYhjMA:10
Message-ID: <496C23FC.9020600@shaw.ca>
Date: Mon, 12 Jan 2009 23:17:48 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: USB memory card reader and 64MB SD card - 2.6.28-git14
References: <1231621530.4495.36.camel@127> <49693575.2030007@shaw.ca> <1231816304.9368.22.camel@127>
In-Reply-To: <1231816304.9368.22.camel@127>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rhubbell wrote:
> On Sat, 2009-01-10 at 17:55 -0600, Robert Hancock wrote: 
>> rhubbell wrote:
>>> (Please CC me in replie,s if it's not too much trouble.)
>>>
>>> I had this issue with previous kernels, but I don't know when the
>>> problem
>>> started. I once was able to read this card.
>>>
>>> Not sure what filesystems are on either card, not sure if it matters.
>>> The cards are not mounted automatically so I am guessing that the
>>> file system doesn't become an issue until mount time.
>>>
>>> The device is a Phison 6-in-1 and has no problems with
>>> other cards.
>>>
>>> When inserted this card causes no problems:
>>>
>>> This is a 128MB card:
>>>
>>> Jan 10 10:47:06  kernel:  uba: uba1
>> Looks like your kernel is configured to use the ub "low performance USB 
>> storage" driver, you could try the normal USB storage driver instead..
> 
> Are you suggesting that the two drivers can't coexist?
> 
> Patched to 2.6.29-rc1 and I've rebuilt the kernel without ub and now
> when I try to mount, it is unable to find a readable card. While the
> other card works fine still.

What dmesg output are you getting now?
