Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbZJSOja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbZJSOja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756331AbZJSOj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:39:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44961 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756156AbZJSOj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:39:29 -0400
Date: Mon, 19 Oct 2009 10:39:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Contreras <felipe.contreras@gmail.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: Annoying problems with lacie external hd (JMicron 0x2339?)
In-Reply-To: <94a0d4530910181517vc3a0766la727d7c97d7792b5@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0910191035260.3899-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009, Felipe Contreras wrote:

> On Thu, Oct 8, 2009 at 11:46 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
> > On Tue, Oct 6, 2009 at 11:10 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >> A usbmon trace would contain more information.  We could see the exact
> >> sequence of commands and error codes.  I'm not sure it would help solve
> >> anything, though.
> >
> > I followed the tutorial and the resulting log is 73M long. I don't
> > know what I'm looking for, so there it is:
> > http://people.freedesktop.org/~felipec/1.mon.out
> 
> Can you take a look? Is there anything else I can provide?

Unforunately the usbmon trace isn't much help.  It shows several 
unrecovered read errors, but you already know that the disk has a bunch 
of bad sectors.

Then near the end, for no apparent reason, it shows a failure right in 
the middle of a READ command.  The computer tried to read 128 sectors;
the drive sent back 48 sectors of data and then stopped responding.  
Something in the firmware crashed; my guess is that the bridge chip 
failed.

Alan Stern

