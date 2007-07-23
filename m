Return-Path: <linux-kernel-owner+w=401wt.eu-S933872AbXGWBZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872AbXGWBZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 21:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759916AbXGWBZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 21:25:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60512 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbXGWBZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 21:25:44 -0400
Message-ID: <46A401E3.3060802@zytor.com>
Date: Sun, 22 Jul 2007 18:18:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Andi Kleen <ak@suse.de>, Christoph Hellwig <hch@infradead.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] use __asm__ and __volatile__ in asm-x86_64/msr.h
References: <200706180209.36762.vapier@gentoo.org> <200706182053.04116.ak@suse.de> <46794BE2.5020108@zytor.com> <200707222045.15935.vapier@gentoo.org>
In-Reply-To: <200707222045.15935.vapier@gentoo.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Wednesday 20 June 2007, H. Peter Anvin wrote:
>> Andi Kleen wrote:
>>>> asm-i386/msr.h should not be exported to userspace at all, it contains
>>>> nothing but kernel-internal helpers.
>>> Actually rdtsc and rdtscll and potentially rdpmc which is in there can be
>>> very useful in user space if you know what you're doing. Unfortunately a
>>> lot of its users don't, but not having the include probably won't stop
>>> them either.
>> More likely, people will just re-implement them incorrectly.
>>
>> However, the rdtsc() definition in the kernel is weird (and removable, I
>> think there are no more users -- I have it removed in my MSR driver
>> rewrite tree which I need to get off my arse and push.)  Most users
>> would expect the rdtscll() functionality with the rdtsc() name.
> 
> does that mean you'll also take care of cleaning up msr.h ?  or do i need to 
> post another patch ?

I'll put that on my list.

	-hpa

