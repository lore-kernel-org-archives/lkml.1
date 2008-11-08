Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbYKHWCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbYKHWCt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 17:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYKHWCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 17:02:40 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:4755 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbYKHWCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 17:02:40 -0500
Message-ID: <49160C7D.7020507@shikadi.net>
Date: Sun, 09 Nov 2008 08:02:37 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.16) Gecko/20080727 Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: hid class and sysfs/hwmon
References: <490FFF1B.6050300@shikadi.net> <4910C32F.9060204@gmail.com> <49152F4E.5040003@shikadi.net> <49159F54.8090500@gmail.com> <4916087F.30100@shikadi.net> <491609CA.30303@gmail.com>
In-Reply-To: <491609CA.30303@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know much about hwmon, but I would guess you should use hwmon_dev
> for registering the attributes if you want it under /sys/class/hwmon/...
> 
> Such as:
> sysfs_create_group(&odin_psu->hwmon_dev->kobj, &odin_attr_group);
> 
> No?

Oh, that worked!  All the other hwmon drivers seem to have it the other 
way around, i.e. you attach sysfs to your original bus/class device kobj 
instead of the hwmon kobj.

Hopefully doing it this way won't have any side effects...

Thanks for your help Jiri!

Cheers,
Adam.
