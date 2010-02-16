Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab0BPPob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 10:44:31 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40453 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932244Ab0BPPoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 10:44:30 -0500
Date: Tue, 16 Feb 2010 10:44:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
cc: Oliver Neukum <oliver@neukum.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>
Subject: RE: USB mass storage and ARM cache coherency
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF8073@dbde02.ent.ti.com>
Message-ID: <Pine.LNX.4.44L0.1002161042350.1716-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, Shilimkar, Santosh wrote:

> > Your original patch however kills ehci, ohci and uhci on some architectures.
> Well the patch was making _ONLY_ control transfers use PIO and rest of
> the transfer would still use dma. So not sure how much performance impact would
> be because of that.
> Another issue with that patch is there are few controllers which can't do PIO
> at all and hence the patch would broke those controllers.

More than "a few"!  None of the EHCI, OHCI, or UHCI controllers used in
Intel-compatible desktop and laptop systems can do PIO.  That's what 
Oliver meant.

Alan Stern

