Return-Path: <linux-kernel-owner+w=401wt.eu-S1765584AbXJZHSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765584AbXJZHSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765068AbXJZHOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 03:14:42 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:2587 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765360AbXJZHOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 03:14:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=RfmSyrST1p4oH0WLgJGYbgwvzrbYIbhFqgm71OZ1Nk9pj3s3eV1r8fuXW1eDyrPY+YFMZ/S8Of6KdqrAGoRGQvML4k5PXR7whooskl0JS+WCuIDkh7YQ+D9gdPeoIayqxqHwbgjjpIMJtjwgSTnspm1z12IfcVQJN1PNKqLtxlk=
Message-ID: <877aabc40710260014v220ab804o5de5dbc36b870bd1@mail.gmail.com>
Date: Fri, 26 Oct 2007 12:44:38 +0530
From: "Amit Shah" <amitshah@gmx.net>
To: linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>
Subject: sysfs: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 21c2711412c76f15
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.24-rc1, I get this for all my eth interfaces:

[  150.389821] sysfs: duplicate filename 'eth1_rename' can not be created
[  150.389824] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
[  150.389826]
[  150.389826] Call Trace:
[  150.389840]  [<ffffffff802ee9cf>] sysfs_add_one+0xaf/0xf0
[  150.389844]  [<ffffffff802ef9fe>] sysfs_create_link+0x9e/0x150
[  150.389849]  [<ffffffff8038a418>] device_rename+0x1d8/0x230
[  150.389854]  [<ffffffff803c2626>] dev_change_name+0xb6/0x230
[  150.389857]  [<ffffffff803c2d5b>] dev_ioctl+0x2bb/0x5a0
[  150.389862]  [<ffffffff80437436>] _spin_unlock_irqrestore+0x16/0x40
[  150.389864]  [<ffffffff8043947a>] do_page_fault+0x24a/0x930
[  150.389869]  [<ffffffff803b341d>] sock_ioctl+0x7d/0x250
[  150.389872]  [<ffffffff802aafef>] do_ioctl+0x2f/0xa0
[  150.389875]  [<ffffffff802ab0d4>] vfs_ioctl+0x74/0x2d0
[  150.389878]  [<ffffffff802ab3c1>] sys_ioctl+0x91/0xb0
[  150.389881]  [<ffffffff8020c32e>] system_call+0x7e/0x83
[  150.389884]
[  150.389886] net eth1_rename: device_rename: sysfs_create_symlink failed (-17)
[  151.169923] sysfs: duplicate filename 'eth2' can not be created
[  151.169927] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
[  151.169929]
[  151.169930] Call Trace:
[  151.169946]  [<ffffffff802ee9cf>] sysfs_add_one+0xaf/0xf0
[  151.169949]  [<ffffffff802ef9fe>] sysfs_create_link+0x9e/0x150
[  151.169955]  [<ffffffff8038a418>] device_rename+0x1d8/0x230
[  151.169960]  [<ffffffff803c2626>] dev_change_name+0xb6/0x230
[  151.169963]  [<ffffffff803c2d5b>] dev_ioctl+0x2bb/0x5a0
[  151.169967]  [<ffffffff80437436>] _spin_unlock_irqrestore+0x16/0x40
[  151.169970]  [<ffffffff8043947a>] do_page_fault+0x24a/0x930
[  151.169974]  [<ffffffff803b341d>] sock_ioctl+0x7d/0x250
[  151.169978]  [<ffffffff802aafef>] do_ioctl+0x2f/0xa0
[  151.169980]  [<ffffffff802ab0d4>] vfs_ioctl+0x74/0x2d0
[  151.169983]  [<ffffffff802ab3c1>] sys_ioctl+0x91/0xb0
[  151.169987]  [<ffffffff8020c32e>] system_call+0x7e/0x83
[  151.169990]
[  151.169992] net eth2: device_rename: sysfs_create_symlink failed (-17)
[  151.176762] e1000: eth2: e1000_watchdog: NIC Link is Up 100 Mbps
Full Duplex, Flow Control: RX/TX
[  151.209396] sysfs: duplicate filename 'eth0' can not be created


-- 
Amit Shah
http://www.amitshah.net/
