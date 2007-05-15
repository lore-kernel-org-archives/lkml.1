Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbXEOVmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbXEOVmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 17:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbXEOVlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 17:41:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:44970 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbXEOVly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 17:41:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tAQF39F4w6hN2/R32Y/EclpOLV5tcRkK3gTWvC66u5XelQj318/UG8g876sYJu4o9Rw9EEon0/hpdbTAaUJ2kp5nvJjF2lHu5IuhuFvKZ9dntAOf7sB52DaY0qnHDpFWRGn+0zOW7u6mz+GJqbaOtyLoTm32hmtRcg6fjFjSU7Q=
Message-ID: <6bffcb0e0705151441m727b337ej5a7d3a1473bd997e@mail.gmail.com>
Date: Tue, 15 May 2007 23:41:53 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Thomas Meyer" <thomas.mey@web.de>
Subject: Re: BUG: at include/linux/slub_def.h:89 kmalloc_index()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <464A215D.3010701@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464A215D.3010701@web.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 15/05/07, Thomas Meyer <thomas.mey@web.de> wrote:
> head: f653c34dd3d8bde2c918316fd5ba2e2c4f95afcf
>
> May 15 23:02:07 [kernel] BUG: at include/linux/slub_def.h:89 kmalloc_index()
> May 15 23:02:07 [kernel]  [<c015fc10>] get_slab+0x43/0x1cc
> May 15 23:02:07 [kernel]  [<f934b101>] usb_get_configuration+0x93f/0xd06
> [usbcore]
> May 15 23:02:07 [kernel]  [<c0160d82>] __kmalloc_track_caller+0x10/0x62
> May 15 23:02:07 [kernel]  [<c014ea37>] __kzalloc+0x11/0x3a
> May 15 23:02:07 [kernel]  [<f934b101>] usb_get_configuration+0x93f/0xd06
> [usbcore]
> May 15 23:02:07 [kernel]  [<f934854f>] usb_control_msg+0xcf/0xd9 [usbcore]
> May 15 23:02:07 [kernel]  [<f9348dff>] usb_get_descriptor+0x85/0xaf
> [usbcore]
> May 15 23:02:07 [kernel]  [<f93495ca>]
> usb_get_device_descriptor+0x72/0x7c [usbcore]
> May 15 23:02:07 [kernel]  [<f9344375>] hub_port_init+0x542/0x54c [usbcore]
> May 15 23:02:07 [kernel]  [<f9344c44>] usb_new_device+0x17/0xed [usbcore]
> May 15 23:02:07 [kernel]  [<f934581a>] hub_thread+0x6fb/0xa67 [usbcore]
> May 15 23:02:07 [kernel]  [<c02c783c>] __sched_text_start+0x6cc/0x782
> May 15 23:02:07 [kernel]  [<c012f7b5>] autoremove_wake_function+0x0/0x35
> May 15 23:02:07 [kernel]  [<f934511f>] hub_thread+0x0/0xa67 [usbcore]
> May 15 23:02:07 [kernel]  [<c012f6ea>] kthread+0x3b/0x61
> May 15 23:02:07 [kernel]  [<c012f6af>] kthread+0x0/0x61
> May 15 23:02:07 [kernel]  [<c0104917>] kernel_thread_helper+0x7/0x10
> May 15 23:02:07 [kernel]  =======================

Known issue
http://bugzilla.kernel.org/show_bug.cgi?id=8476

Thanks for the report.

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
