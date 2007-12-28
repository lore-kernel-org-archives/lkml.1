Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbXL1XEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbXL1XEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 18:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbXL1XEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 18:04:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947AbXL1XEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 18:04:47 -0500
Date: Fri, 28 Dec 2007 15:03:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Bahadir Balban" <bahadir.balban@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: 2.6.24-rc5 sysfs pci bridge duplicate symlink
Message-Id: <20071228150322.71e5ca49.akpm@linux-foundation.org>
In-Reply-To: <7ac1e90c0712280511y3a0f454cmc84e8c17f173c8dc@mail.gmail.com>
References: <7ac1e90c0712280511y3a0f454cmc84e8c17f173c8dc@mail.gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2007 13:11:37 +0000 "Bahadir Balban" <bahadir.balban@gmail.com> wrote:

> Hi,
> 
> On ARM with PCI, I get this error since -rc2 (didn't try rc1):
> 
> sysfs: duplicate filename 'bridge' can not be created
> WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> [<c00287fc>] (dump_stack+0x0/0x14) from [<c00cbc64>] (sysfs_add_one+0x50/0xf4)
> [<c00cbc14>] (sysfs_add_one+0x0/0xf4) from [<c00ccd30>]
> (sysfs_create_link+0xec/0x184)
>  r6:cfca8b48 r5:cfca96c8 r4:cfc2fec0
> [<c00ccc44>] (sysfs_create_link+0x0/0x184) from [<c0160b44>]
> (pci_bus_add_devices+0xf0/0x144)
>  r7:cfc5a2d4 r6:cfc5a2d4 r5:cfc5a2c0 r4:cfcad800
> [<c0160a54>] (pci_bus_add_devices+0x0/0x144) from [<c0160b30>]
> (pci_bus_add_devices+0xdc/0x144)
>  r7:cfc5a3d4 r6:cfc5a3d4 r5:cfc5a3c0 r4:cfcadc00
> [<c0160a54>] (pci_bus_add_devices+0x0/0x144) from [<c0160b30>]
> (pci_bus_add_devices+0xdc/0x144)
>  r7:cfc5a4d4 r6:cfc5a4d4 r5:cfc5a4c0 r4:cfc5d400
> [<c0160a54>] (pci_bus_add_devices+0x0/0x144) from [<c000a934>]
> (pci_common_init+0x148/0x184)
>  r7:c035fd58 r6:cfc3e760 r5:c001e030 r4:cfc5a4c0
> 
> 
> Any idea why?
> 

(suitable cc added)
