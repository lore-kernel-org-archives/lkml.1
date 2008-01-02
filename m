Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbYABBbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbYABBbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 20:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbYABBbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 20:31:42 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55038 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969AbYABBbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 20:31:42 -0500
Date: Wed, 2 Jan 2008 03:31:26 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Frysinger <vapier@gentoo.org>,
       tglx@linutronix.de, mingo@redhat.com, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: asm-x86/byteorder.h: clean up for userspace
Message-ID: <20080102013126.GN27566@does.not.exist>
References: <200712311312.46450.vapier@gentoo.org> <20080101174708.GA25089@infradead.org> <477AAE6E.8080305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <477AAE6E.8080305@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 01:19:42PM -0800, H. Peter Anvin wrote:
> Christoph Hellwig wrote:
>> On Mon, Dec 31, 2007 at 01:12:45PM -0500, Mike Frysinger wrote:
>>> Since asm-x86/byteorder.h is exported to userspace, use __asm__ rather than
>>> asm in its code.
>>
>> The correct fix is to not export it to userspace.
>
> Unfortunately, it's historically been provided, for over 15 years.  It's 
> also trivial to export, without funnies, and it's *useful* to userspace, as 
> it provides an interface sorely lacking from the stock libc interfaces.
>...

Userspace either has to #define CONFIG_X86_BSWAP or it'll get the slow 
versions of these functions...

Leaking CONFIG_ variables to userspace is not really funny - I remember 
e.g. what tricks MySQL does (did?) for (ab)using asm-i386/atomic.h in 
userspace.

> 	-hpa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

