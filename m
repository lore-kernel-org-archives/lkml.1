Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZHaM5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZHaM5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZHaM5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:57:10 -0400
Received: from rtr.ca ([76.10.145.34]:36356 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbZHaM5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:57:10 -0400
Message-ID: <4A9BC8A6.20503@rtr.ca>
Date: Mon, 31 Aug 2009 08:57:10 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs compat_ioctl?
References: <4A9B759B.7020401@msgid.tls.msk.ru> <20090831123010.GA2368@infradead.org>
In-Reply-To: <20090831123010.GA2368@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Aug 31, 2009 at 11:02:51AM +0400, Michael Tokarev wrote:
>> Hello!
>>
>> I tried to resize an xfs filesystem on 64bit 2.6.30 kernel
>> using 32bit userland, and that does not work, in dmesg I see:
>>
>> ioctl32(xfs_growfs:24426): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12} arg(ffa56df4) on /mnt
>> ioctl32(xfs_growfs:24427): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12} arg(ff991254) on /mnt
>>
>> so apparently there's no compat_ioctl layer for these ioctls.
>>
>> Are there any plans to add these? :)
> 
> Are you sure you're testing 2.6.30?  The copat ioctls were added in 2.6.28.
..

What command-line flags were you using, Michael ?

I just tried a simple "xfs_growfs -d" here, and it worked fine.
This is 2.6.31-rc7-64bit on top of a 32-bit userland.

Cheers
