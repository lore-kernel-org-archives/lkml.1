Return-Path: <linux-kernel-owner+w=401wt.eu-S933512AbXJPNjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512AbXJPNjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 09:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932597AbXJPNjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 09:39:00 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:60042 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566AbXJPNi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 09:38:59 -0400
Message-ID: <4714BEED.4020704@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2007 19:08:53 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: sysfs: duplicate filename 'bInterfaceNumber' can not be created
References: <20071016130658.GG5263@kernel.dk>
In-Reply-To: <20071016130658.GG5263@kernel.dk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Hi,
> 
> I get this on booting git as of this morning, HEAD is at
> 65a6ec0d72a07f16719e9b7a96e1c4bae044b591.
> 
> sysfs: duplicate filename 'bInterfaceNumber' can not be created
> WARNING: at fs/sysfs/dir.c:425 sysfs_add_one()
> 
> Call Trace:
>  [<ffffffff802bd786>] sysfs_add_one+0x5c/0xc9
>  [<ffffffff802bd21a>] sysfs_add_file+0x59/0x8d
>  [<ffffffff802bed57>] sysfs_create_group+0x9c/0xf5
>  [<ffffffff8803b1db>] :usbcore:usb_create_sysfs_intf_files+0x35/0xd6
>  [<ffffffff88037a39>] :usbcore:usb_set_configuration+0x49d/0x4bf
>  [<ffffffff8803bb35>] :usbcore:usb_create_ep_files+0x290/0x2df
>  [<ffffffff8803ed11>] :usbcore:generic_probe+0x5d/0xa0
>  [<ffffffff8803902d>] :usbcore:usb_probe_device+0x39/0x3b
>  [<ffffffff803ec13e>] driver_probe_device+0xde/0x165
>  [<ffffffff803ec1c5>] __device_attach+0x0/0xb
>  [<ffffffff803ec1ce>] __device_attach+0x9/0xb
>  [<ffffffff803eb33d>] bus_for_each_drv+0x4b/0x82
>  [<ffffffff803ec258>] device_attach+0x64/0x7c
>  [<ffffffff803eb2a6>] bus_attach_device+0x2d/0x79
>  [<ffffffff803ea092>] device_add+0x38c/0x60d
>  [<ffffffff88032f1e>] :usbcore:usb_new_device+0x51/0x91
>  [<ffffffff88033b5f>] :usbcore:hub_thread+0x7a0/0xbae
>  [<ffffffff80247770>] autoremove_wake_function+0x0/0x38
>  [<ffffffff880333bf>] :usbcore:hub_thread+0x0/0xbae
>  [<ffffffff80247641>] kthread+0x49/0x78
>  [<ffffffff8020c658>] child_rip+0xa/0x12
>  [<ffffffff802475f8>] kthread+0x0/0x78
>  [<ffffffff8020c64e>] child_rip+0x0/0x12
> 

Hi,

Same warning was reported at http://lkml.org/lkml/2007/10/14/81

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
