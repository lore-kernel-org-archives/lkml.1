Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbYHVWPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbYHVWPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 18:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbYHVWOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 18:14:53 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2610 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751526AbYHVWOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 18:14:52 -0400
Date: Fri, 22 Aug 2008 18:14:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Machek <pavel@suse.cz>
cc: Oliver Neukum <oneukum@suse.de>, <linux-pm@lists.linux-foundation.org>,
       <James.Bottomley@hansenpartnership.com>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, <teheo@novell.com>
Subject: Re: [linux-pm] Power management for SCSI
In-Reply-To: <20080822105246.GB3482@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0808221810060.9561-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008, Pavel Machek wrote:

> Hi!
> 
> > > - suspending has side effects
> > 
> > I'm not sure what you mean by that.  Suspension always has side effects 
> > of one kind or another.
> > 
> > > Suspension in USB has always side effects. That's not true for other
> > > subsystems.
> > 
> > Name one.  At the very least, suspending a device means you can't use
> > it again without first calling the driver's resume method.  That's a 
> > side effect.
> 
> IDE, actually. I don't think it is relevant, but you can do hdparm -y,
> and it will automatically spin up when you try to talk to it next
> time.

It's a matter of definitions...  "hdparm -y" doesn't call the driver's 
suspend method, so in some sense it isn't truly a suspend.

But it's true that some systems can power down more or less
transparently (with restart latency as the only visible side effect).

Alan Stern

