Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbZIUUrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbZIUUrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 16:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZIUUrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 16:47:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59951 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752422AbZIUUrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 16:47:32 -0400
Date: Mon, 21 Sep 2009 16:47:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: 2.6.31 ehci problem - mouse dead on scroll
In-Reply-To: <200909161715.51449.volkerarmin@googlemail.com>
Message-ID: <Pine.LNX.4.44L0.0909211641580.4414-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Volker Armin Hemmann wrote:

> On Mittwoch 16 September 2009, Alan Stern wrote:
> > On Wed, 16 Sep 2009, Volker Armin Hemmann wrote:
> > > emm, the mouse is attached through a powered 4port usb 2.0 hub. That is
> > > the only way to get it working. If I attach it directly (without loading
> > > ohci) it does not work (well, only tried with both Transaction Translator
> > > options off), and if I load ohci before I connect it, it is very very
> > > jerky. So jerky in fact, that I considered douzends of lockups a day a
> > > better alternative.
> > 
> > That is a separate issue and it is a serious bug.  If anything, the
> > behavior with OHCI should be better than with EHCI.  This is worth
> > pursuing farther.  A usbmon log combined with the dmesg log would help.
> > There's no need to include all the boot-up messages in the dmesg log;
> > you can clear the log buffer before plugging in the mouse.
> > 
> > In fact, we can probably forget about the EHCI issue.  If it works okay
> > with the newer TT scheduler, that should be good enough.
> > 
> > Alan Stern
> > 
> 
> ok, I was in the kitchen, I am back and the mouse is extremely jerky.
> 
> I cat usbmon/5u into a file for a short while, I hope it is the right file?

It is.  The usbmon log shows some unexpected gaps, which probably 
correspond to the jerkiness.  But there's nothing to indicate that 
these gaps are the computer's fault.

Have you tried using a different mouse, or a different brand of mouse, 
on this computer?  Or using your mouse on a different machine?

Alan Stern

