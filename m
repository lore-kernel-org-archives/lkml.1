Return-Path: <linux-kernel-owner+w=401wt.eu-S964840AbZLQK4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840AbZLQK4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 05:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZLQKz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 05:55:59 -0500
Received: from queueout01-winn.ispmail.ntl.com ([81.103.221.31]:40338 "EHLO
	queueout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762033AbZLQKz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 05:55:57 -0500
X-Greylist: delayed 745 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Dec 2009 05:55:56 EST
Message-ID: <4B2A0AE5.2080006@reactivated.net>
Date: Thu, 17 Dec 2009 10:41:41 +0000
From: Daniel Drake <dan@reactivated.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; es-ES; rv:1.9.1.5) Gecko/20091212 Thunderbird/3.0
MIME-Version: 1.0
To: Josua Dietze <digidietze@draisberghof.de>
CC: Stefan Seyfried <stefan.seyfried@googlemail.com>,
       usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefan Seyfried <seife@sphairon.com>
Subject: Re: [usb-storage] [PATCH] move eject code from zd1211rw to  usb-storage
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <4B278191.1010009@draisberghof.de>
In-Reply-To: <4B278191.1010009@draisberghof.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Cloudmark-Analysis: v=1.1 cv=1ggfb5FlKZQUfF3vzm9UBYZ2uTfLsbs/8dSljwg5+mE= c=1 sm=0 a=sOupWqN7R48A:10 a=iQiDWL7-QGvl7PhqtaUA:9 a=77POCl-bLNGgAw6lX5T5DHIchHwA:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 15/12/09 12:31, Josua Dietze escribió:
> Stefan Seyfried schrieb:
>
>> The USB ID claimed by zd1211rw for the fake storage device is
>> also in use by other, non-zd1211rw devices (Sphairon Homelink
>> 1202). Move the eject of these devices to where it belongs and
>> where all the needed infrastructure already exists: usb-storage.
>
>
> We can do the eject (as other mode switches) in userspace. Previous
> discussions pointed into that direction.

When I originally wrote this code this wasn't as easy as you might think 
- the virtual CD device seems to be very quirky, and utterly confused 
Linux to the point where it didn't even create a device node. Maybe 
linux is more flexible these days though.

Daniel
