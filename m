Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYKGD1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYKGD1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 22:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbYKGD07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 22:26:59 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3577 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751119AbYKGD07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 22:26:59 -0500
Date: Thu, 6 Nov 2008 22:26:55 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Norbert Preining <preining@logic.at>
cc: Pete Zaitcev <zaitcev@redhat.com>, Mattia Dongili <malattia@linux.it>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb device not showing up
In-Reply-To: <20081106225713.GD11406@gamma.logic.tuwien.ac.at>
Message-ID: <Pine.LNX.4.44L0.0811062223100.26081-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, Norbert Preining wrote:

> Hi Alan,
> 
> On Do, 06 Nov 2008, Alan Stern wrote:
> > Okay.  In the earlier (working) test, the modem showed up on bus 4, not
> > bus 2.  Not that it matters much -- the modem didn't show up at all in
> 
> Sorry, it is always bus 4, i meant interface (or how do you call it) 2,
> bus id 004:002

Yes, okay.  That's bus 4, address 2.

> > should start working, but I have no idea what that would be.  It's not 
> > a USB issue; as far as USB is concerned the device just isn't there at 
> 
> Ok, if it is not an usb issue, I guess I have to hope for some fix in
> sony-laptop module. 

I hope it works out.

> > Interestingly, this trace appears to be missing some events.  There's a
> > gap between timestamps 4284549076 and 4284645743 (the timestamps are in
> > the second column) where we should see the initialization of bus 5 and
> > bus 6.  Instead there's a 100-ms delay in which nothing happens,
> > followed later on by the second initialization phase for those two
> > buses.
> > 
> > I have to wonder...  Did you remove any part of the trace?  Did usbmon 
> 
> No. I sent you the output as it was saved on my hard disk. No editing
> involved.

It must be like Pete said: Some events just got lost because not enough
memory was allocated to usbmon.  Fortunately those missing events had
nothing to do with the hso problem.

Alan Stern

