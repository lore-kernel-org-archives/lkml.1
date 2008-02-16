Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbYBPPU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbYBPPU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 10:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYBPPUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 10:20:19 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48922 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754071AbYBPPUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 10:20:18 -0500
Date: Sat, 16 Feb 2008 10:20:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Pinter <oliver.pntr@gmail.com>
cc: Andrew Buehler <abuehler.kernel@gmail.com>, <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       <linux-scsi@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]*
In-Reply-To: <6101e8c40802160632y2723ccc3xb0940b9aebfa20f5@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0802161013190.3769-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008, Oliver Pinter wrote:

> On 2/15/08, Andrew Buehler <abuehler.kernel@gmail.com> wrote:
> > In my workplace, I use a customized version of Novell's ZENworks imaging
> > boot CD, which is based off of Linux. I have one particular model of
> > laptop - the IBM/Lenovo R61 - on which three different things fail
> > completely in current kernels (tested with 2.6.24.2 and 2.6.25-rc1):
> > USB, AHCI (and thus access to the SATA drive), and networking. As a
> > consequence of all three failing in parallel, I have no practical way to
> > get logs and other information off of the machine to help with tracking
> > down the bugs.

...

To make a long story short, the USB symptoms you describe indicate a
problem with interrupt routing.  This could well explain the other
difficulties too.  There are various kernel parameters you can try
putting on the boot command line to work around it:  acpi=noirq or
acpi=off or pci=noacpi or a few others.

Alan Stern

