Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbXKYQGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbXKYQGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 11:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbXKYQGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 11:06:42 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4755 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752273AbXKYQGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 11:06:41 -0500
Date: Sun, 25 Nov 2007 11:06:40 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Raymano Garibaldi <raymano@faunos.com>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [BUG] USB_PERSIST
In-Reply-To: <20071124223903.6c72f527.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0711251052430.22777-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2007, Andrew Morton wrote:

> On Tue, 20 Nov 2007 17:04:32 -0700 "Raymano Garibaldi" <raymano@faunos.com> wrote:
> 
> > Is there any other information that I can provide which might help in
> > resolving this bug?
> 
> Let's cc the USB developers.
> 
> > On 11/18/07, Raymano Garibaldi <raymano@faunos.com> wrote:
> > > The last time I tried this and it worked was 2.6.21. Below is a

Sorry, that's not possible.  2.6.21 doesn't include USB Persist 
support.  Nor does 2.6.22.

There were some experimental patches with early versions of USB Persist 
for those kernels.  They are different from what eventually went into 
2.6.23.

> > > On 11/18/07, Denys Vlasenko <vda.linux@googlemail.com> wrote:
> > > > On Sunday 18 November 2007 20:14, Raymano Garibaldi wrote:
> > > > > In kernel 2.6.23.8 USB_PERSIST feature does not work if the same USB
> > > > > device is detached and reattached while computer is suspended. The
> > > > > mount points for the USB storage device mounted before suspend are
> > > > > lost and the device has to be remounted after resume.

USB Persist was never meant to allow you to detach and reattach a 
device while the computer is suspended; it was meant to deal with 
hibernation.  So what you observed is the correct behavior, not a bug.
Detaching and reattaching a device while the computer is suspended 
should result in exactly the same behavior as detaching and reattaching 
the device while the computer is awake.

If you try doing the same thing but with the computer in hibernation 
instead of suspended, you may find it more in line with what you 
expect.

Alan Stern

