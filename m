Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbYBTRPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbYBTRPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYBTRPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:15:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43168 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752155AbYBTRPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:15:13 -0500
Date: Wed, 20 Feb 2008 12:15:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Buehler <abuehler.kernel@gmail.com>
cc: Oliver Pinter <oliver.pntr@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly
 resolved
In-Reply-To: <47BC5E01.1050902@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0802201213260.5630-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008, Andrew Buehler wrote:

> > What do you mean by "does not see the drive"?
> 
> Its detect-hardware-and-report mode shows a HD size of 0 (which is what
> it has showed in cases where the kernel has not detected the drive), its
> detect-partitions-and-report mode shows no partitions and no devices
> which can have partitions, and attempting to actually use it to pull
> down a drive image (it's a disk-imaging program) causes it to hang at
> the point where it would begin to write.
> 
> Hmm. One thing which just sprang to mind, in the stab-in-the-dark
> category: in 2.6.24.2, launching the program on some machines gave
> warnings along the lines of "this program is using a deprecated ioctl,
> please convert it to SG_IO" (which I naturally cannot do since it's
> closed and I don't have the source),

You can ask the program's author to update it.

> but IIRC in the 2.5.25-rc2-based
> disc with ACPI enabled no such message appears. If the reason that there
> are no longer such messages is that the ioctl in question has now been
> removed, that might explain why the program does not see the drive.

Could be.  You can use strace to find out what system calls the program 
is making.


> I'm not sure I expressed myself clearly. I do not think the problem is
> with the different kernels. I think the problem is with the different
> configurations. I am asking if there are any established techniques for
> comparing differences between config files from widely different
> kernels.

Not as far as I know.

Alan Stern

