Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbYH1UQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbYH1UQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYH1UQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:16:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40179 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752913AbYH1UQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:16:16 -0400
Date: Thu, 28 Aug 2008 16:16:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Scott Wood <scottwood@freescale.com>
cc: Arnd Bergmann <arnd@arndb.de>, <dbrownell@users.sourceforge.net>,
       <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       Li Yang <leoli@freescale.com>
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller
 driver
In-Reply-To: <48B6E62D.4060606@freescale.com>
Message-ID: <Pine.LNX.4.44L0.0808281613540.3844-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, Scott Wood wrote:

> Alan Stern wrote:
> > This was done deliberately.  The relevant standards state that a USB
> > device can have no more than one peripheral interface.
> 
> Does building a kernel image that can run on different hardware without 
> rebuilding also violate the "relevant standards"?

No.  That isn't what Arnd was concerned about.  He noted that even if 
you did build multiple modules, only one of them could be loaded at any 
time.

> And who's to say that there aren't multiple USB devices on a single 
> board, that just happen to share a CPU and memory? :-)

That's why I don't fully support this decision.  But I wanted to point 
out that there _was_ a conscious decision, as opposed to bad 
programming through sheer carelessness.

Alan Stern

