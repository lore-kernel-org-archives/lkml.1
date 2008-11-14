Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYKNJpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYKNJpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 04:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYKNJow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 04:44:52 -0500
Received: from mail.gmx.net ([213.165.64.20]:34125 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751037AbYKNJov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 04:44:51 -0500
X-Authenticated: #3035711
X-Provags-ID: V01U2FsdGVkX1/PIKFrZPLPyO5u1WmAN0ikgb9AvxrAmvQXCYtvgo
	+sM6KHbejERVHu
Message-ID: <491D488B.9030004@gmx.de>
Date: Fri, 14 Nov 2008 10:44:43 +0100
From: Ingo van Lil <inguin@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080723 Fedora/2.0.0.16-1.fc9 Thunderbird/2.0.0.16 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Pete Zaitcev <zaitcev@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usbmon binary format reader loses synchronization
References: <20081113125945.GA10450@zaphod.peppercon.de> <20081113221536.c69ce161.zaitcev@redhat.com>
In-Reply-To: <20081113221536.c69ce161.zaitcev@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pete Zaitcev wrote:

>> When dumping USB data with "cat /dev/usbmon0 > usbmon.trace" while
>> reading from a USB storage device and analyzing the dump file
>> afterwards it will get out of sync after a couple of packets.
> 
> I think you nailed the problem. I only want shorter lines.
> How about this:

Looks good to me, and works just fine.

Signed-off-by: Ingo van Lil <inguin@gmx.de>

Regards,
Ingo
