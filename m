Return-Path: <linux-kernel-owner+w=401wt.eu-S1762123AbXIKDYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762123AbXIKDYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 23:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbXIKDYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 23:24:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbXIKDYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 23:24:15 -0400
Date: Mon, 10 Sep 2007 20:26:47 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: greg@kroah.com
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       zaitcev@redhat.com
Subject: Oops in make_class_name in 2.6.22.1 on Fedora
Message-Id: <20070910202647.24094d57.zaitcev@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.11.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Greg (and others):

I do not seem to be able to find an answer, sorry.
Do you happen to remember if this was fixed after 2.6.22.1:

localhost kernel: EIP is at make_class_name+0x27/0x7a
localhost kernel:  [<c05586f1>] class_device_del+0x97/0x119
localhost kernel:  [<c055877b>] class_device_unregister+0x8/0x10
localhost kernel:  [<e08735f4>] __scsi_remove_device+0x1d/0x60 [scsi_mod]
localhost kernel:  [<e08711ae>] scsi_forget_host+0x2d/0x4a [scsi_mod]
localhost kernel:  [<e086c49c>] scsi_remove_host+0x65/0xd5 [scsi_mod]
localhost kernel:  [<e0e76775>] storage_disconnect+0xe/0x16 [usb_storage]
localhost kernel:  [<c056f8b8>] usb_unbind_interface+0x44/0x85
localhost kernel:  [<c0557df7>] __device_release_driver+0x6e/0x8b

Obviously a known bug but all I see is users reporting it. In my case
it's this:
 https://bugzilla.redhat.com/show_bug.cgi?id=253424
I saw Alan giving it a try here:
 http://lkml.org/lkml/2007/7/12/259

Yours,
-- Pete
