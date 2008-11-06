Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbYKFPYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbYKFPYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYKFPXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:23:48 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:32834 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752762AbYKFPXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:23:46 -0500
Date: Thu, 6 Nov 2008 10:23:45 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Norbert Preining <preining@logic.at>
cc: Mattia Dongili <malattia@linux.it>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb device not showing up
In-Reply-To: <20081106150031.GI2395@gamma.logic.tuwien.ac.at>
Message-ID: <Pine.LNX.4.44L0.0811061022140.2568-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, Norbert Preining wrote:

> Hi Alan,
> 
> On Mi, 05 Nov 2008, Alan Stern wrote:
> > Well, this is a little odd.  The trace shows the modem was detected and
> > enumerated correctly.  But there's nothing corresponding to when you
> > loaded the hso driver.  In fact, there's nothing after uhci-hcd 
> > finished starting up and the unconnected root hubs were suspended.
> 
> Strange. I will redo the thing and see if something changes the second
> time. I am quite sure I loaded hsom but of course without udev running
> (init=/bin/bash) no devices were created.
> 
> > Did you look in /proc/bus/usb/devices at this point?  And what about
> > the files in /sys/bus/usb/drivers/hso/?
> 
> I don't remember, will redo it.
> 
> > This suggests the problem may lie in the hso driver itself, or in a
> > failure to bind the driver to the device.
> 
> Well, the point is that under these circumstances, as I explained,
> *there*is*no*problem*, I can use the device without any problems.

Oh.  Well, you should rerun the test under circumstances in which there 
_is_ a problem.

> Only when I turn of the computer and turn it on again the device simply
> does not show up in the usb system.

Okay, then do the test that way.

Alan Stern

