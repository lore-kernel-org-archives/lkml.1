Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYJCMLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYJCMLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 08:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYJCMLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 08:11:08 -0400
Received: from twin.jikos.cz ([213.151.79.26]:45357 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbYJCMLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 08:11:07 -0400
Date: Fri, 3 Oct 2008 14:11:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Vit Kudrle <kudrle@sci.muni.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Oops in USB HID
In-Reply-To: <200810031134.m93BYDqQ025308@elanor.sci.muni.cz>
Message-ID: <Pine.LNX.4.64.0810031409240.1532@twin.jikos.cz>
References: <200810031134.m93BYDqQ025308@elanor.sci.muni.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008, Vit Kudrle wrote:

> Oct  3 01:16:58 kernel: hub 2-0:1.0: port 7 disabled by hub (EMI?), re-enabling...
> Oct  3 01:16:58 kernel: usb 2-7: USB disconnect, address 39
> Oct  3 01:16:58 kernel: drivers/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
> Oct  3 01:16:58 kernel: BUG: unable to handle kernel NULL pointer dereference at 00000000000000c8
> Oct  3 01:16:58 kernel: IP: [<ffffffff803b0755>] hiddev_ioctl+0x39/0x552

Hi,

could you please use 'addr2line' utility on address 0xffffffff803b0755 to 
identify the line on which the NULL pointer dereference happened?

Obviously there is some missing handling of error conditions from usbhid 
code after the URB submission has failed.

Thanks,

-- 
Jiri Kosina
SUSE Labs

