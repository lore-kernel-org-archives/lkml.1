Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbXKUSCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbXKUSCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 13:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXKUSCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 13:02:35 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53777 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751253AbXKUSCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 13:02:34 -0500
Date: Wed, 21 Nov 2007 13:02:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Markus Rechberger <mrechberger@gmail.com>
cc: Oliver Neukum <oliver@neukum.org>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, Mark Lord <lkml@rtr.ca>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] USB deadlock after resume
In-Reply-To: <d9def9db0711210914m47885980gffd789d30a817b88@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0711211300560.4750-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007, Markus Rechberger wrote:

> Not really, suspending doesn't work at all on my other notebook it
> just freezes..
> I'm basically trying to get that driver work on my eee PC [1], it's
> cheap and tiny so I don't expect anything special in there..
> The system is preloaded with Xandros (it's debian etch with a few
> custom applications) and linux 2.6.21.4.
> 
> The system still locks up, although only if I leave the video
> application running during suspending. I don't have to reload the
> driver anymore after resuming if the video node doesn't get accessed
> (I'm looking for races in the uvc driver at the moment).

The point is that the system shouldn't lock up.  The application might 
fail or crash, but the system should continue to run.  The fact that it 
doesn't means that something is wrong in the kernel.

Alan Stern

