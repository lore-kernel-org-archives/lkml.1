Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYLHQgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYLHQgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 11:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYLHQgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 11:36:06 -0500
Received: from smtp.nokia.com ([192.100.122.233]:55252 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbYLHQgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 11:36:05 -0500
Message-ID: <493D4C63.5040502@yandex.ru>
Date: Mon, 08 Dec 2008 18:33:39 +0200
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: dedekind@infradead.org, Laurent Pinchart <laurentp@cse-semaphore.com>,
       linux-mtd@lists.infradead.org, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       v4l-dvb-maintainer@linuxtv.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: UBI/DVB ioctl conflict?
References: <20081207095811.13b51cca@zod.rchland.ibm.com> <200812081041.14178.laurentp@cse-semaphore.com> <1228729915.13686.95.camel@sauron> <200812081650.54346.arnd@arndb.de>
In-Reply-To: <200812081650.54346.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Dec 2008 16:35:40.0049 (UTC) FILETIME=[01955010:01C95953]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 08 December 2008, Artem Bityutskiy wrote:
>> On Mon, 2008-12-08 at 10:41 +0100, Laurent Pinchart wrote:
>>> Correct me if I'm wrong, but doesn't this only matters for devices that would 
>>> implement both the UBI and DVB API on the same inode ? That would be quite 
>>> unlikely.
>> Yeah, I guess. But this anyway makes sense to keep ioctls
>> non-overlapping.
> 
> We try hard (but sometimes fail) to keep every ioctl number unique.
> The reason for this is that the device drivers are not the only
> pieces of code that look at them. Specifically, three other things
> frequently cause problems here:

Thanks for the reply. Do you know the status of the
Documentation/ioctl/ioctl-number.txt file - it does not seem to be up-to-date.
Should I document add UBI ioctls there?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
