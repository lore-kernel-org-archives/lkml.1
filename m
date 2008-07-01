Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbYGAS7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbYGAS7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYGAS7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:59:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39133 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753140AbYGAS7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:59:40 -0400
Date: Tue, 1 Jul 2008 14:59:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@suse.de>
cc: Stefan Becker <Stefan.Becker@nokia.com>, <linux-usb@vger.kernel.org>,
       ext David Brownell <david-b@pacbell.net>,
       <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ext Leonardo Chiquitto <leonardo.lists@gmail.com>
Subject: Re: [PATCH] USB: fix interrupt disabling for HCDs with shared
 interrupt handlers
In-Reply-To: <20080701182543.GA32098@suse.de>
Message-ID: <Pine.LNX.4.44L0.0807011456370.6796-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008, Greg KH wrote:

> Hm, isn't this also an issue in 2.6.25 as well?  I've had a few very
> strange reports of USB just locking up in 2.6.25, could this also be the
> cause there?

It could go back a lot farther than that.  I don't think our interrupt 
setup has been changed significantly for a long time, with one 
exception: We added the IRQF_DISABLED flag fairly recently.  But of 
course, we now know that it doesn't do what we expected.

It's surprising that more people haven't experienced this problem and 
reported it.

> Alan and Dave, do you both ack this thing?  I know you've been involved
> in creating it, just want to get the formal approval :)

Acked-by: Alan Stern <stern@rowland.harvard.edu>

There still are a few places where spaces were used instead of tabs for 
indenting.  Aside from that it looks fine.

Alan Stern

