Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbZHaM74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbZHaM74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbZHaM7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:59:55 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:40099 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbZHaM7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:59:55 -0400
Message-ID: <4A9BC94B.9050808@msgid.tls.msk.ru>
Date: Mon, 31 Aug 2009 16:59:55 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Christoph Hellwig <hch@infradead.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs compat_ioctl?
References: <4A9B759B.7020401@msgid.tls.msk.ru> <20090831123010.GA2368@infradead.org> <4A9BC8A6.20503@rtr.ca>
In-Reply-To: <4A9BC8A6.20503@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Christoph Hellwig wrote:
>> On Mon, Aug 31, 2009 at 11:02:51AM +0400, Michael Tokarev wrote:
>>> Hello!
>>>
>>> I tried to resize an xfs filesystem on 64bit 2.6.30 kernel
>>> using 32bit userland, and that does not work, in dmesg I see:
>>>
>>> ioctl32(xfs_growfs:24426): Unknown cmd fd(3) 
>>> cmd(400c586e){t:'X';sz:12} arg(ffa56df4) on /mnt
>>> ioctl32(xfs_growfs:24427): Unknown cmd fd(3) 
>>> cmd(400c586e){t:'X';sz:12} arg(ff991254) on /mnt
>>>
>>> so apparently there's no compat_ioctl layer for these ioctls.
>>>
>>> Are there any plans to add these? :)
>>
>> Are you sure you're testing 2.6.30?  The copat ioctls were added in 
>> 2.6.28.
> 
> What command-line flags were you using, Michael ?
> 
> I just tried a simple "xfs_growfs -d" here, and it worked fine.
> This is 2.6.31-rc7-64bit on top of a 32-bit userland.

Damn.  I rebooted to 2.6.27 to test something unrelated, forgot
about it, and later tried xfs_growfs -d, which failed as per above.

And yes indeed, in 2.6.30 everything works as expected.

Please excuse me for the noise.

/mjt
