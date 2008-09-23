Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbYIWVIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbYIWVIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYIWVIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:08:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42243 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbYIWVIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:08:46 -0400
Message-ID: <48D95A8F.10705@zytor.com>
Date: Tue, 23 Sep 2008 14:07:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, w@1wt.eu
Subject: Re: [update5] [PATCH] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200809090641.m896fscX028849@hitchhiker.org.lu> <48C99F29.2030007@zytor.com> <48C9A6C0.4070802@knaff.lu> <48C9A80D.1010703@zytor.com> <48D73858.3070900@knaff.lu> <48D7C304.4020709@zytor.com> <48D7C48F.8010907@knaff.lu> <48D93E68.6040701@zytor.com> <48D9471E.9090108@knaff.lu>
In-Reply-To: <48D9471E.9090108@knaff.lu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> H. Peter Anvin wrote:
>> Just did so, and it broke my first test build.
>>
>> arch/x86/boot/compressed/head_64.o: In function `relocated':
>> (.text+0x28): undefined reference to `_end'
>> make[3]: *** [arch/x86/boot/compressed/vmlinux] Error 1
>> make[2]: *** [arch/x86/boot/compressed/vmlinux] Error 2
>> make[1]: *** [bzImage] Error 2
>> make: *** [sub-make] Error 2
>>
>>     -hpa
> 
> Just leave the changes in head_64.S away; this was only about improved
> memory management. It is not strictly needed, as the change in
> /include/asm-x86/boot.h still makes sure that the heap is big enough,
> even for bzip2

More failures...

/bin/sh: scripts/bin_size: No such file or directory

Happens with O=.

	-hpa
