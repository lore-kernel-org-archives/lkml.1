Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab0BCPF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:05:29 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50887 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756140Ab0BCPF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:05:28 -0500
Date: Wed, 3 Feb 2010 10:05:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Corey Wright <undefined@pobox.com>
cc: Greg KH <gregkh@suse.de>, <stable@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: regression in 2.6.27.45 with usb and suspend-to-disk
In-Reply-To: <20100203032452.4c215f9f.undefined@pobox.com>
Message-ID: <Pine.LNX.4.44L0.1002031004210.1540-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010, Corey Wright wrote:

> 2.6.27.45 will only suspend-to-disk once without rebooting.  every attempt
> to suspend-to-disk after the first attempt results in "pm_op():
> usb_dev_freeze +0x0/0xa returns -16" and "PM: Device usb1 failed to freeze:
> error -16".  reverting commit 4fbebe26d7a5eed6c1900bf2142b68af7df38462
> (http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=commit;h=4fbebe26d7a5eed6c1900bf2142b68af7df38462)
> fixes the problem.
> 
> this problem exhibits itself on both a x86-64 desktop and i386 netbook
> (though the reverted commit was only tested on the x86-64 desktop).  the
> affected computers are different architectures, different distributions
> (debian lenny vs ubuntu hardy), and different kernel configs (but unchanged
> since 2.6.27.23), so i am fairly certain this is a regression in 2.6.27.45
> and not the result of an environment change.
> 
> i normally use the pm-hibernate command to suspend to disk, but to isolate
> the problem i used the kernel interfaces directly (as demonstrated in the
> transcript below).
> 
> i can provide any other information necessary (eg .config, dmesg, lsusb)
> and i am willing to test patches.

Please build a kernel with CONFIG_USB_DEBUG enabled and post a dmesg 
log showing the problem during the second hibernation attempt.

Alan Stern

