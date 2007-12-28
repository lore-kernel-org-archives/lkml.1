Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbXL1NLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbXL1NLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 08:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbXL1NLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 08:11:41 -0500
Received: from hs-out-0708.google.com ([64.233.178.242]:21983 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752451AbXL1NLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 08:11:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LNN0v5fe8ZMfkRdVm14WVRHDGyiRMTKLu3qvRinL3U39KcCNabiRAcg/F7kbW9lqKNxjsyNFhKPUYsxWJjD1FcFqVO5CKss2EnKRlGqe7fze6/PBoDzaW48wVelX8po0rMWkhgZc2Gp/noYDTldtlVzaPT9/WnKlOvi7Rx5Spfk=
Message-ID: <7ac1e90c0712280511y3a0f454cmc84e8c17f173c8dc@mail.gmail.com>
Date: Fri, 28 Dec 2007 13:11:37 +0000
From: "Bahadir Balban" <bahadir.balban@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc5 sysfs pci bridge duplicate symlink
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On ARM with PCI, I get this error since -rc2 (didn't try rc1):

sysfs: duplicate filename 'bridge' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
[<c00287fc>] (dump_stack+0x0/0x14) from [<c00cbc64>] (sysfs_add_one+0x50/0xf4)
[<c00cbc14>] (sysfs_add_one+0x0/0xf4) from [<c00ccd30>]
(sysfs_create_link+0xec/0x184)
 r6:cfca8b48 r5:cfca96c8 r4:cfc2fec0
[<c00ccc44>] (sysfs_create_link+0x0/0x184) from [<c0160b44>]
(pci_bus_add_devices+0xf0/0x144)
 r7:cfc5a2d4 r6:cfc5a2d4 r5:cfc5a2c0 r4:cfcad800
[<c0160a54>] (pci_bus_add_devices+0x0/0x144) from [<c0160b30>]
(pci_bus_add_devices+0xdc/0x144)
 r7:cfc5a3d4 r6:cfc5a3d4 r5:cfc5a3c0 r4:cfcadc00
[<c0160a54>] (pci_bus_add_devices+0x0/0x144) from [<c0160b30>]
(pci_bus_add_devices+0xdc/0x144)
 r7:cfc5a4d4 r6:cfc5a4d4 r5:cfc5a4c0 r4:cfc5d400
[<c0160a54>] (pci_bus_add_devices+0x0/0x144) from [<c000a934>]
(pci_common_init+0x148/0x184)
 r7:c035fd58 r6:cfc3e760 r5:c001e030 r4:cfc5a4c0


Any idea why?

Thanks,
Bahadir
