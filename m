Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZBNVHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZBNVHn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZBNVHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:07:33 -0500
Received: from mail.lang.hm ([64.81.33.126]:37121 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbZBNVHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:07:33 -0500
Date: Sat, 14 Feb 2009 14:12:10 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
cc: Michael Riepe <michael.riepe@googlemail.com>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: RFC: install firmware in a kernel-dependent directory
In-Reply-To: <3f9a31f40902141115w27f20ecfk81213a21dbe1adbd@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0902141410220.14911@asgard.lang.hm>
References: <4996B838.2070205@googlemail.com> <3f9a31f40902141115w27f20ecfk81213a21dbe1adbd@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Feb 2009, Jaswinder Singh Rajput wrote:

> On Sat, Feb 14, 2009 at 5:55 PM, Michael Riepe
> <michael.riepe@googlemail.com> wrote:
>> Currently, make firmware_install puts all firmware blobs in
>> /lib/firmware. If you have several kernel versions installed, they will
>> overwrite each other's files, which may lead to problems if the blobs
>> eventually change. I think it would be better to use a separate
>> directory for every kernel version, like /lib/firmware/$(uname -r) or
>> /lib/modules/$(uname -r)/firmware (the latter is my favorite).
>>
>> In either case, only a minimal modification in /lib/udev/firmware.sh is
>> required to make it look in the new directory first.
>>
>> Comments?
>
> firmware version depends on hardware version not by kernel (software) version.

are you sure? different firmware could have different interfaces for the 
kernel to use.

I don't know if this is a problem in practice (I think I've heard of 
this), but there is no reason it couldn't be.

David Lang

> So /lib/firmware is absolutely OK.
>
> --
> JSR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
