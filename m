Return-Path: <linux-kernel-owner+w=401wt.eu-S1760263AbYDCPTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263AbYDCPTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757840AbYDCPTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:19:25 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:59230 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591AbYDCPTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:19:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CVWtpXclNgx796BG/YK8PQxK551M4ytcspkjxmGxn4zfAN/M2M2+yQQ9LItnrrvkF6c9uE+JDJP/sh9CjDqWtY2nhOKcE+tvhjok9ABbmcofDozpMLMGDay24DPqAirEPKaXiDj6SbA0wBFddDkyG6VDRvACzwPMqiTd0TO58iw=
Message-ID: <3ae72650804030819n2b26cf13na9b30eed18df3d2c@mail.gmail.com>
Date: Thu, 3 Apr 2008 17:19:23 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Xavier Bestel" <xavier.bestel@free.fr>
Subject: Re: PnP: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Cc: linux-kernel@vger.kernel.org, "Adam Belay" <ambx1@neo.rr.com>
In-Reply-To: <1207230993.3438.4.camel@skunk.anacadf.mentorg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1207230896.3438.1.camel@skunk.anacadf.mentorg.com>
	 <1207230993.3438.4.camel@skunk.anacadf.mentorg.com>
X-Google-Sender-Auth: ca7c67551cc64fbf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 3:56 PM, Xavier Bestel <xavier.bestel@free.fr> wrote:
>  it's a debian 2.6.24-5

>  On Thu, 2008-04-03 at 15:54 +0200, Xavier Bestel wrote:
>  > I know some of these have been reported, but I couldn't find one in the
>  > PnP subsystem.
>  >
>  >
>  > Linux Plug and Play Support v0.97 (c) Adam Belay
>  > pnp: PnP ACPI init
>  > ACPI: bus type pnp registered
>  > pnp: PnP ACPI: found 15 devices
>  > ACPI: ACPI bus type pnp unregistered
>  > PnPBIOS: Disabled by ACPI PNP
>  > PCI: Probing PCI hardware
>  > sysfs: duplicate filename 'bridge' can not be created
>  > WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
>  > Pid: 1, comm: swapper Not tainted 2.6.24-1-686 #1
>  >  [<c01b12f8>] sysfs_add_one+0x54/0xb8
>  >  [<c01b1ee2>] sysfs_create_link+0xaf/0xfd
>  >  [<c01e7070>] pci_bus_add_devices+0xba/0xff
>  >  [<c0253589>] pcibios_scan_root+0x25/0x80
>  >  [<c01251d5>] printk+0x1b/0x1f
>  >  [<c0394d9c>] pci_legacy_init+0x53/0xe1
>  >  [<c0377497>] kernel_init+0x153/0x2c6
>  >  [<c0103d92>] ret_from_fork+0x6/0x1c
>  >  [<c0377344>] kernel_init+0x0/0x2c6
>  >  [<c0377344>] kernel_init+0x0/0x2c6
>  >  [<c0104b0f>] kernel_thread_helper+0x7/0x10
>  >  =======================
>  > pci 0000:00:01.0: Error creating sysfs bridge symlink, continuing...

I guess, this fixes it:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=cc74d96f47b0d916840f92092595e3be9731e047

Kay
