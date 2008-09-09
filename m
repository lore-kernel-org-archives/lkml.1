Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbYIIONu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbYIIONu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 10:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYIIONl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 10:13:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53505 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751442AbYIIONk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 10:13:40 -0400
Date: Tue, 9 Sep 2008 10:13:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Steven Noonan <steven.noonan@uplinklabs.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Steven Noonan <steven@uplinklabs.net>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/1] drivers/usb/host/pci-quirks.c: wait for EHCI handoff
 far too long in quirk_usb_disable_ehci()
In-Reply-To: <20080908214426.49626bf0.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0809091011250.2486-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008, Andrew Morton wrote:

> On Sat,  6 Sep 2008 17:29:53 -0700 Steven Noonan <steven.noonan@uplinklabs.net> wrote:
> 
> > This patch fixes a very noticeable bootup delay on some
> > systems (in my particular case, an HP dv5178us). The
> > problem is caused by a buggy BIOS which doesn't properly
> > announce that the handoff was completed.
> > 
> > The delay in the current version of pci-quirks.c is 5 seconds,
> > which I've cut down to 0.5 seconds.

> I guess it risks breaking someone else's system.  Or perhaps the number
> was just grabbed out of the air.

As far as I know, it was indeed just grabbed out of the air.  The spec 
specifically avoids giving an upper limit on how long to wait.

> Can we do a separate quirk just for that machine (and ones with the
> same bug)?

My BIOS has the same bug.  I wouldn't mind seeing the delay reduced.

Alan Stern

