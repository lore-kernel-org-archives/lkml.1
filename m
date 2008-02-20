Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbYBTPue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbYBTPue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbYBTPuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:50:23 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39286 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753825AbYBTPuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:50:21 -0500
Date: Wed, 20 Feb 2008 10:50:19 -0500 (EST)
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
In-Reply-To: <47BB3DA1.8040001@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0802201048410.4828-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Andrew Buehler wrote:

> With those two problems out of the way, what is left is the hard-drive
> issue, and that is also halfway fixed by enabling ACPI. Specifically, it
> is "fixed" in that the kernel sees the hard drive and I can mount it,
> but it is not fixed in that the program we need to use in this
> environment does not see the drive.

What do you mean by "does not see the drive"?

> I have a config from a boot disc running 2.6.5 (that's not a typo) under
> which the program in question *does* see the drive, but there are
> massive differences between that config and the one I am using now, and
> narrowing the critical difference down is likely to be somewhat
> difficult - particularly since some of the "differences" are merely
> renamed config symbols (i.e. the CONFIG_SCSI_SATA_*->CONFIG_SATA_*
> switchover), and I have limited ability to tell which without intensive
> investigation. Are there any established techniques for simplifying this
> kind of comparison?

The only established technique is to run various kernels intermediate 
between the one that works and the one that fails.

Alan Stern

