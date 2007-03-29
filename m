Return-Path: <linux-kernel-owner+w=401wt.eu-S1030285AbXC2P4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030285AbXC2P4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 11:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030293AbXC2P4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 11:56:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51190 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030285AbXC2P4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 11:56:43 -0400
Date: Thu, 29 Mar 2007 11:56:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: Maxim Levitsky <maximlevitsky@gmail.com>, <linux-kernel@vger.kernel.org>,
       <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
In-Reply-To: <460BBCD8.1020802@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0703291155000.3108-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007, Mark Lord wrote:

> Maxim Levitsky wrote:
> > Hi,
> > 	I noticed that after suspend/resume cycle all my usb devices are unplugged/replugged by uhci driver.
> > While it is not that big problem to me, that can be a real problem if a device is a flash card with mounted 
> > file-system, because disappeared device will cause file-system corruption.
> 
> Mmm.. this sounds really bad -- I wonder what happens if the rootfs is on USB ?

The system crashes as soon as it resumes.  As you might expect.

> With older kernels, things just "worked" this way.  Has it now been broken ??

No; it has never worked.  Your memory of how older kernels behaved is 
wrong.

Alan Stern

P.S.: Help is on the way.  I will soon submit a patch to help improve the 
situation.

