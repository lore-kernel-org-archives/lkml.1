Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYKHVpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYKHVpr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 16:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYKHVpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 16:45:38 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:1831 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbYKHVph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 16:45:37 -0500
Message-ID: <4916087F.30100@shikadi.net>
Date: Sun, 09 Nov 2008 07:45:35 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.16) Gecko/20080727 Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: hid class and sysfs/hwmon
References: <490FFF1B.6050300@shikadi.net> <4910C32F.9060204@gmail.com> <49152F4E.5040003@shikadi.net> <49159F54.8090500@gmail.com>
In-Reply-To: <49159F54.8090500@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If anyone can see why this might result in no sysfs files, please let me
>> know!  I previously had most of this code working with a platform_device
>> instead of the hid_device, which is what makes me wonder about
>> hdev->dev.kobj.  (Not sure how to test if that variable is accurate,
>> either.)  Or perhaps it has already been used elsewhere and it can only
>> be used once?
> 
> I suppose it's under /sys/bus/hid/devices/.../, isn't it?

Aha, yes!  I didn't even think of checking there.  I suppose this means 
I have to create another device (like a platform_device) in order to 
have the sysfs files appear in the correct place?

Is a platform_device the correct type to create, or is there another way?

Thanks,
Adam.

