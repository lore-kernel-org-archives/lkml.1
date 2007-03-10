Return-Path: <linux-kernel-owner+w=401wt.eu-S1767857AbXCJQeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767857AbXCJQeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 11:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767865AbXCJQeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 11:34:17 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4082 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767857AbXCJQeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 11:34:16 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] 2.6.21-rc3-mm1
Date: Sat, 10 Mar 2007 17:36:34 +0100
User-Agent: KMail/1.9.5
Cc: Jiri Kosina <jkosina@suse.cz>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
References: <Pine.LNX.4.44L0.0703101057380.23928-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0703101057380.23928-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703101736.35386.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > Right. Can't be 100% sure but without the patch it would have probably
> > failed by now so I guess the patch is ok. Not sure how to make usb mouse
> > plugging/unplugging process automatic ;-)
> 
> 	echo FOO >/sys/bus/usb/drivers/usbhid/unbind
> 
> to simulate an unplug (actually, to do an unbind), and
> 
> 	echo FOO >/sys/bus/usb/drivers/usbhid/unbind
                                              ^^^^^^ bind I guess

> to do a bind, where FOO is the name of the USB mouse device link present
> in the /sys/bus/usb/drivers/usbhid directory.

# ls -al /sys/bus/usb/drivers/usbhid
total 0
drwxr-xr-x 2 root root    0 Mar 10 17:30 .
drwxr-xr-x 8 root root    0 Mar 10 17:14 ..
lrwxrwxrwx 1 root root    0 Mar 10 17:30 2-2:1.0 -> ../../../../devices/pci0000:00/0000:00:0c.0/usb2/2-2/2-2:1.0
--w------- 1 root root 4096 Mar 10 17:17 bind
lrwxrwxrwx 1 root root    0 Mar 10 17:17 module -> ../../../../module/usbhid
--w------- 1 root root 4096 Mar 10 17:17 new_id
--w------- 1 root root    0 Mar 10 17:22 unbind

# echo "2-2:1.0" > /sys/bus/usb/drivers/usbhid/unbind
bash: echo: write error: No such device

Any thoughts?

Regards,

	Mariusz Kozlowski
