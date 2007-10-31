Return-Path: <linux-kernel-owner+w=401wt.eu-S1760535AbXJaXRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbXJaXRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 19:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbXJaXRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 19:17:16 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:21133 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbXJaXRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 19:17:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=UhP12brhumT2qAOCjmaQebjcmz47qi/f3ib31MBydVxjAZwJ/I5xiGhJ7gnF5iUKgYYnSzjyfzw1tYFTFX3mM5LkOSa086al6vn+G3DB4R8aOBNe1YwmAzCP7/6p7JbCc0ZeYYQJoheytbE0GZ+lnDyjxYcKMYX429JoALZ2q7Q=
Date: Wed, 31 Oct 2007 16:17:11 -0700
From: Shaw Vrana <shaw@vranix.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one() with
	4fa435018d740cb83d74c92306aa1f796da91ddd
Message-ID: <20071031231711.GB5704@gmail.com>
Mail-Followup-To: Thomas Meyer <thomas@m3y3r.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <471E1764.5040000@m3y3r.de> <471E17E6.6060304@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471E17E6.6060304@m3y3r.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, I get the same with 2.6.24-rc1.


On Tue, Oct 23, 2007 at 05:48:54PM +0200, Thomas Meyer wrote:
> Thomas Meyer schrieb:
> > Oct 23 17:13:55 [kernel] usb 1-1: new high speed USB device using
> > ehci_hcd and address 7
> > Oct 23 17:13:55 [kernel] usb 1-1: configuration #1 chosen from 1 choice
> > Oct 23 17:13:55 [kernel] hub 1-1:1.0: USB hub found
> > Oct 23 17:13:55 [kernel] hub 1-1:1.0: 4 ports detected
> > Oct 23 17:13:55 [kernel] sysfs: duplicate filename 'bInterfaceNumber'
> > can not be created
> > Oct 23 17:13:55 [kernel] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > Oct 23 17:13:55 [kernel]  [<c01a37f0>] sysfs_add_one+0x54/0xb8
> > Oct 23 17:13:55 [kernel]  [<c01a332a>] sysfs_add_file+0x42/0x6a
> > Oct 23 17:13:55 [kernel]  [<c01a4a01>] sysfs_create_group+0x84/0xe7
> > Oct 23 17:13:55 [kernel]  [<c023e5ec>] device_add+0x44a/0x454
> > Oct 23 17:13:55 [kernel]  [<f88e774c>]
> > usb_create_sysfs_intf_files+0x24/0x98 [usbcore]
> > Oct 23 17:13:55 [kernel]  [<f88e4181>] usb_set_configuration+0x48f/0x4a9
> > [usbcore]
> > Oct 23 17:13:55 [kernel]  [<f88eabf3>] generic_probe+0x50/0x91 [usbcore]
> > Oct 23 17:13:55 [kernel]  [<f88e5817>] usb_probe_device+0x32/0x37 [usbcore]
> > Oct 23 17:13:55 [kernel]  [<c023fc11>] driver_probe_device+0xc5/0x148
> > Oct 23 17:13:55 [kernel]  [<c02d94bd>] klist_next+0x4b/0x6b
> > Oct 23 17:13:55 [kernel]  [<c023f14a>] bus_for_each_drv+0x35/0x5c
> > Oct 23 17:13:55 [kernel]  [<c023fd17>] device_attach+0x63/0x77
> > Oct 23 17:13:55 [kernel]  [<c023fc94>] __device_attach+0x0/0x5
> > Oct 23 17:13:55 [kernel]  [<c023f0c6>] bus_attach_device+0x26/0x75
> > Oct 23 17:13:55 [kernel]  [<c023e43d>] device_add+0x29b/0x454
> > Oct 23 17:13:55 [kernel]  [<f88dfc2e>] usb_new_device+0x4d/0x8a [usbcore]
> > Oct 23 17:13:55 [kernel]  [<f88e1149>] hub_thread+0x6f5/0xae2 [usbcore]
> > Oct 23 17:13:55 [kernel]  [<c02d9e72>] schedule+0x4b4/0x519
> > Oct 23 17:13:55 [kernel]  [<c013a1e1>] autoremove_wake_function+0x0/0x33
> > Oct 23 17:13:55 [kernel]  [<f88e0a54>] hub_thread+0x0/0xae2 [usbcore]
> > Oct 23 17:13:55 [kernel]  [<c013a119>] kthread+0x38/0x5f
> > Oct 23 17:13:55 [kernel]  [<c013a0e1>] kthread+0x0/0x5f
> > Oct 23 17:13:55 [kernel]  [<c0107bb7>] kernel_thread_helper+0x7/0x10
> > Oct 23 17:13:55 [kernel]  =======================
> >
> >
> >
> >   
> Sorry. This happens with 0895e91d60ef9bdef426d1ce14bb94bd5875870d...
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
