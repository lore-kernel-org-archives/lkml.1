Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab0BHOvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 09:51:35 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45457 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752890Ab0BHOvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 09:51:33 -0500
Date: Mon, 8 Feb 2010 09:51:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
cc: linux-kernel@vger.kernel.org, <dbrownell@users.sourceforge.net>,
       <linux-usb@vger.kernel.org>, <vamos@i4.informatik.uni-erlangen.de>
Subject: Re: [PATCH] obsolete config in kernel source (USB_GADGET_*)
In-Reply-To: <20100205122412.GA6540@faui49.informatik.uni-erlangen.de>
Message-ID: <Pine.LNX.4.44L0.1002080950330.1809-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010, Christoph Egger wrote:

> On Fri, Jan 15, 2010 at 09:46:00AM -0500, Alan Stern wrote:
> > On Fri, 15 Jan 2010, Christoph Egger wrote:
> > > 	The linux tree contains USB-Id assignment snippets for some
> > > USB Gadget drivers, which, as far as I can tell, never worked on
> > > mainline linux2.6 but either originate from seemingly long-dead
> > > third-party trees or were never ported from linux2.4.
> > > 
> > > 	As there has also seemingly never existed a way to select
> > > these configs in the KConfig system it might be time to get rid of
> > > them which would be done by the attached patch.
> > 
> > Have you tried building g_file_storage and the other gadget drivers 
> > after applying your patch?
> 
> 	You're right. I ony checked whether the first few were still
> needed somewhere in code and assumed equal status for all of
> them. SHould have at least build-tested all that stuff before sending
> (and doing so now).
> 
> 	Below is a updated patch that should be more correct and does
> also build (tested against mainline git).

The new patch looks okay to me.  Other people might have opinions about 
whether this code should be removed, however.

Alan Stern

