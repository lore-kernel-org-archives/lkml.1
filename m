Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbYJETQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbYJETQk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 15:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbYJETQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 15:16:30 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2533 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755733AbYJETQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 15:16:29 -0400
Date: Sun, 5 Oct 2008 15:16:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dave Hansen <dave@sr71.net>
cc: Thomas Gleixner <tglx@linutronix.de>, gregkh <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB disconnects every 30 seconds (2.6.27-rc8)
In-Reply-To: <1223229563.7798.10.camel@nimitz>
Message-ID: <Pine.LNX.4.44L0.0810051509110.32325-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008, Dave Hansen wrote:

> On Sat, 2008-10-04 at 14:12 -0400, Alan Stern wrote:
> > > Oct  3 16:01:59 nimitz kernel: [  180.273883] usb usb7: opened by process 6485: hald-addon-usb-
> > > Oct  3 16:01:59 nimitz kernel: [  180.273894] usb usb7: usbdev_ioctl: CONNECTINFO
> > > Oct  3 16:01:59 nimitz kernel: [  180.273935] usb usb7: opened by process 6485: hald-addon-usb-
> > > Oct  3 16:01:59 nimitz kernel: [  180.273940] usb usb7: usbdev_ioctl: IOCTL
> > > Oct  3 16:01:59 nimitz kernel: [  180.392126] usb 3-4: opened by process 6485: hald-addon-usb-
> > > Oct  3 16:01:59 nimitz kernel: [  180.393185] usb 3-4.3: USB disconnect, address 16
> > > Oct  3 16:01:59 nimitz kernel: [  180.393191] usb 3-4.3.4: USB disconnect, address 17
> > > Oct  3 16:01:59 nimitz kernel: [  180.437913] usb 3-4.3: new high speed USB device using ehci_hcd and address 18
> > > Oct  3 16:01:59 nimitz kernel: [  180.494705] usb 3-4.3: configuration #1 chosen from 1 choice
> > > Oct  3 16:01:59 nimitz kernel: [  180.495101] hub 3-4.3:1.0: USB hub found
> > > Oct  3 16:01:59 nimitz kernel: [  180.495409] hub 3-4.3:1.0: 4 ports detected
> > > Oct  3 16:01:59 nimitz kernel: [  180.600101] usb 3-4: usbdev_ioctl: CONNECTINFO
> > > Oct  3 16:01:59 nimitz kernel: [  180.600144] usb usb3: opened by process 6485: hald-addon-usb-
> > > Oct  3 16:01:59 nimitz kernel: [  180.600147] usb usb3: usbdev_ioctl: CONNECTINFO
> > > Oct  3 16:01:59 nimitz kernel: [  180.600167] usb 3-4: opened by process 6485: hald-addon-usb-
> > > Oct  3 16:01:59 nimitz kernel: [  180.600170] usb 3-4: usbdev_ioctl: IOCTL
> > 
> > Without a usbmon log, I can't tell what may still be going wrong.
> 
> This log should have recorded what was going on there.  Was there
> something else that I should be capturing with usbmon that I missed?
> 
> http://sr71.net/~dave/linux/1.mon.out

That file is the usbmon log from back on Friday.  I need to see the
usbmon log you get with the timing fix installed.  Was that not clear?  
Without the log, I can't tell why the disconnects continue to occur
even though the timing fix should have eliminated them.

Alan Stern

