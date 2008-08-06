Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbYHFUJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbYHFUJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbYHFUJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:09:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45845 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750987AbYHFUJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:09:22 -0400
Date: Wed, 6 Aug 2008 16:09:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arjan van de Ven <arjan@infradead.org>
cc: Simon Arlott <simon@fire.lp0.eu>, Rene Herman <rene.herman@keyaccess.nl>,
       <linux-kernel@vger.kernel.org>, <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
In-Reply-To: <20080806125612.6bf9eb40@infradead.org>
Message-ID: <Pine.LNX.4.44L0.0808061607160.2138-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, Arjan van de Ven wrote:

> On Wed, 6 Aug 2008 15:49:27 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On Wed, 6 Aug 2008, Simon Arlott wrote:
> > 
> > > > Wouldn't it be much simpler, and less objectionable, to do what I
> > > > suggested earlier?  That is, add a 5-second delay at the start of
> > > > hub_thread() in drivers/usb/core/hub.c.  No messing with
> > > > Makefiles, no changes to the initcall scheduling.
> > > 
> > > Aside from 5 seconds being too long, and anything less being a race
> > > between hub_thread() and driver initcalls, it doesn't improve
> > > anything because it'll still have to wait for the devices to finish
> > > initialising in userspace instead.
> > 
> > Why is 5 seconds too long?  Too long for what?
> 
> because I'm done booting to full UI in that time.
> 
> it's forever.

This doesn't answer my question.  Why does the fact that you're already 
in the UI after 5 seconds mean that 5 seconds is too long to delay the 
start of khubd?

Besides, if your machine can boot to the UI in under 5 seconds then you 
have no need to worry about improving boot-up speed anyway.

Alan Stern

