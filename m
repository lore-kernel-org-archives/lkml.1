Return-Path: <linux-kernel-owner+w=401wt.eu-S1761039AbYGRCDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761039AbYGRCDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 22:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbYGRCDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 22:03:37 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:45892 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbYGRCDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 22:03:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Qhnn2csIGf0PYlUlHNBn3dWJljallkW3hzfObkC/krVy+8PMx77KVeSXmG2qAG6vh9
         l81gUV5tYIhXcV8AkDYINc/iTlGICS9BeM46/bXt1ng8ixZS4uyxcL4Qb/cw+5bEgr0m
         ZVfBM7+0X8VHxrfMHZJKwTz15szp6ZZNRDrVE=
Message-ID: <487FF9F2.5000906@gmail.com>
Date: Thu, 17 Jul 2008 23:03:30 -0300
From: "Rafael C. de Almeida" <almeidaraf@gmail.com>
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: =?UTF-8?B?TWloYWkgRG9uyJt1?= <mihai.dontu@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, "Fred ." <eldmannen@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Please add ZFS support (from GPL sources)
References: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com> <487F9D6D.7090808@zytor.com> <200807180133.19191.mihai.dontu@gmail.com>
In-Reply-To: <200807180133.19191.mihai.dontu@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mihai Donțu wrote:
> On Thursday 17 July 2008, H. Peter Anvin wrote:
>> Fred . wrote:
>>> Previously we have not been able to have ZFS support due to it being
>>> licensed under the CDDL and the kernel under the GPL.
>>>
>>> Sun have contributed ZFS support to GRUB under the GPL license. We
>>> could now use that code to implement support for ZFS in the Linux
>>> kernel.
>>>
>>> http://blogs.sun.com/darren/entry/zfs_under_gplv2_already_exists
>>  From what I can see, it is an absolutely-minimal readonly implementation.
> 
> There are a number of fs drivers in the kernel which provide read-only 
> support. The GPL-ed code might not be much (I haven't looked at it), but if 
> someone would spend some time to write a nice, clean patch which can be 
> easily improved, I think there would be at least one user out there who would 
> find it useful.
> 
> Of course, this could open a door for all kinds of incomplete drivers, but 
> these days people seem nuts about ZFS.
> 
> In second thoughts, maybe a fuse based driver would be better. :)
> 

I think there's already work being done for zfs on fuse
(http://www.wizy.org/wiki/ZFS_on_FUSE). Not sure how it's going, though.
