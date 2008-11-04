Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYKDQKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYKDQKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYKDQKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:10:35 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57523 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753851AbYKDQKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:10:34 -0500
Date: Tue, 4 Nov 2008 11:10:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
cc: USB list <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc3: usb_hcd_poll_rh_status: array subscript is above
 array bounds
In-Reply-To: <200811041901.55808.arvidjaar@mail.ru>
Message-ID: <Pine.LNX.4.44L0.0811041108430.3614-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008, Andrey Borzenkov wrote:

> > I think this is actually a compiler bug.  It certainly has nothing to
> > do with USB.  There was a discussion about it a month or so ago on
> > LKML.
> > 
> 
> 
> 
> Yes this really looks like a compiler bug, "length" hardly can be considered
> constant expression even using very broad definition of "constant".
> 
> What is interesting though, it appears that compiler believes length has
> value of 5. So it will copy one extra byte; and possibly pass incorrect
> length to the caller. I cannot judge whether this garbage can do any harm.

Did you examine the object code?  That's the only way to be sure.

> Dp you know if it was ever reported to gcc folks?

I have no idea.  All I know is what was reported on LKML.

Alan Stern

