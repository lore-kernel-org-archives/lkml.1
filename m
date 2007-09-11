Return-Path: <linux-kernel-owner+w=401wt.eu-S933300AbXIKGjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbXIKGjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761553AbXIKGjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:39:11 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55143 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761406AbXIKGjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:39:09 -0400
Date: Mon, 10 Sep 2007 23:12:26 -0700
From: Greg KH <greg@kroah.com>
To: Pete Zaitcev <zaitcev@redhat.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Oops in make_class_name in 2.6.22.1 on Fedora
Message-ID: <20070911061226.GB27404@kroah.com>
References: <20070910202647.24094d57.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910202647.24094d57.zaitcev@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 08:26:47PM -0700, Pete Zaitcev wrote:
> Hi, Greg (and others):
> 
> I do not seem to be able to find an answer, sorry.
> Do you happen to remember if this was fixed after 2.6.22.1:
> 
> localhost kernel: EIP is at make_class_name+0x27/0x7a
> localhost kernel:  [<c05586f1>] class_device_del+0x97/0x119
> localhost kernel:  [<c055877b>] class_device_unregister+0x8/0x10
> localhost kernel:  [<e08735f4>] __scsi_remove_device+0x1d/0x60 [scsi_mod]
> localhost kernel:  [<e08711ae>] scsi_forget_host+0x2d/0x4a [scsi_mod]
> localhost kernel:  [<e086c49c>] scsi_remove_host+0x65/0xd5 [scsi_mod]
> localhost kernel:  [<e0e76775>] storage_disconnect+0xe/0x16 [usb_storage]
> localhost kernel:  [<c056f8b8>] usb_unbind_interface+0x44/0x85
> localhost kernel:  [<c0557df7>] __device_release_driver+0x6e/0x8b
> 
> Obviously a known bug but all I see is users reporting it. In my case
> it's this:
>  https://bugzilla.redhat.com/show_bug.cgi?id=253424
> I saw Alan giving it a try here:
>  http://lkml.org/lkml/2007/7/12/259

I think this was a scsi problem that has been fixed, but don't really
remember the exact commit.

Alan, any ideas?

It would probably be good to get this into the next -stable if we can
figure out which patch did fix it.

thanks,

greg k-h
