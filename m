Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYI3FXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYI3FXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 01:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYI3FWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 01:22:53 -0400
Received: from SMTP.andrew.cmu.edu ([128.2.10.85]:46151 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbYI3FWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 01:22:53 -0400
Message-ID: <48E1B7A9.5020207@cmu.edu>
Date: Tue, 30 Sep 2008 01:22:49 -0400
From: George Nychis <gnychis@cmu.edu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: help finding entry point of USB data in the kernel, not	drivers/usb/core/devio.c?
References: <48E1B35A.1040103@cmu.edu> <20080930051258.GA6764@kroah.com>
In-Reply-To: <20080930051258.GA6764@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg KH wrote:
> I suggest asking this on the linux-usb mailing list instead, it would
> reach the main Linux USB developers.

Thanks!  I was unaware of the list.  Punting there also.


> Wait, which way are you sending this data?  To or from the device?

I am looking for data from the device to the host.


> No, that entry point is for usbfs, not the individual drivers, and not
> the core.

I see, that explains things.


> Are you watching all of the different USB device endpoints?
> 

Yes, I am not filtering really.  But if this code is for usbfs, then 
this is definitely not what I am looking for.

I think what I am looking for might be in devices.c::usb_device_read() 
... poking around there now.  It calls usb_device_dump() which takes a 
user space buffer as a parameter for which it dumps data in to.

Thanks for the response!

- George
