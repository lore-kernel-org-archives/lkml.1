Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbXKFVZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbXKFVZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbXKFVZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:25:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54165 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbXKFVZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:25:26 -0500
Message-ID: <4730DBC1.5030009@zytor.com>
Date: Tue, 06 Nov 2007 13:25:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] init: Introduce rootdir bootparm to select which dir
 to sys_chroot
References: <200711061340.26112.a1426z@gawab.com> <200711072310.20715.a1426z@gawab.com> <4730CAD8.1050407@zytor.com> <200711080013.20702.a1426z@gawab.com>
In-Reply-To: <200711080013.20702.a1426z@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> H. Peter Anvin wrote:
>> Al Boldi wrote:
>>> Al Boldi wrote:
>>>> This patch introduces a rootdir kernel boot parameter, which specifies
>>>> the path to the kernel sys_chroot boot dir.
>>>>
>>>> This is useful for systems that have more than one distribution
>>>> installed on the same fs/partition.
>> This seems like something that should be done via an initramfs.
> 
> Agreed. But, not everybody boots their systems via initramfs, and even if 
> they did, they also have to know how to reconfigure it.
> 
> In contrast, this patch offers the rootdir functionality as a simple bootparm 
> and without any extra initramfs dependency.
> 

And yet another hack in the kernel!

Instead of heaping hack du jour into the kernel, write a small initramfs 
that provides the appropriate functionality, please.

	-hpa
