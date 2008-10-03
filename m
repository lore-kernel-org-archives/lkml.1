Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbYJCSIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbYJCSIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 14:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYJCSI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 14:08:27 -0400
Received: from www.sr71.net ([198.145.64.142]:47050 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbYJCSI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 14:08:26 -0400
X-Greylist: delayed 1362 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2008 14:08:26 EDT
Subject: USB disconnects every 30 seconds (2.6.27-rc8)
From: Dave Hansen <dave@sr71.net>
To: gregkh <gregkh@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Content-Type: text/plain
Date: Fri, 03 Oct 2008 10:45:39 -0700
Message-Id: <1223055939.7944.32.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing some odd USB behavior with newer kernels
(2.6.27-rc8-00062-g330f647 to be exact).  Almost exactly, every 30
seconds, one of my USB hubs disconnects.  At first, I thought it was a
hardware issue, and started swapping cables.  Then, I realized that I'd
*just* rebooted into a new kernel.  So, I booted back to the distro
kernel and these went away.

Even though my mouse is hanging off that hub, I don't seem to notice the
disconnects.

$ dmesg | grep disconnect
[ 3599.496217] usb 3-4.4.4: USB disconnect, address 122
[ 3599.677346] usb 3-4.1: USB disconnect, address 121
[ 3627.804621] usb 3-4.1: USB disconnect, address 124
[ 3628.004400] usb 3-4.4.4: USB disconnect, address 123
[ 3659.496421] usb 3-4.4.4: USB disconnect, address 126
[ 3659.676186] usb 3-4.1: USB disconnect, address 125
[ 3689.493763] usb 3-4.1: USB disconnect, address 3
[ 3689.708916] usb 3-4.4.4: USB disconnect, address 127
[ 3719.497221] usb 3-4.4.4: USB disconnect, address 7
[ 3719.684965] usb 3-4.1: USB disconnect, address 6
[ 3749.496323] usb 3-4.1: USB disconnect, address 9
[ 3749.691180] usb 3-4.4.4: USB disconnect, address 8

Full dmesg and .config:

http://sr71.net/~dave/linux/config-10-03-2008.1.txt
http://sr71.net/~dave/linux/dmesg-10-03-2008.1.log

The last one I tried before this was -rc3, and it appears to be OK.  The
Ubuntu 2.6.24-19-generic kernel also appears not to have this issue.

A quick scan of LKML and linux-usb didn't turn up anything similar.

The machine is a Lenovo T61 plugged into the Lenovo dock.  At this
point, the only thing plugged into the suspect hub is my mouse.

-- Dave

