Return-Path: <linux-kernel-owner+w=401wt.eu-S1764984AbYBUUDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764984AbYBUUDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757972AbYBUUDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:03:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39792 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754193AbYBUUC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:02:58 -0500
Date: Thu, 21 Feb 2008 15:02:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Buehler <abuehler.kernel@gmail.com>
cc: Greg KH <greg@kroah.com>, Oliver Pinter <oliver.pntr@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly
 resolved
In-Reply-To: <47BDD455.9090909@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0802211501570.5473-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008, Andrew Buehler wrote:

> > It sounds like an old version of a Novell product is making a newer
> > kernel spit out a warning message.
> 
> Originally that was all that it was, but now I am seeing the product in
> question not even see the hard drive despite the fact that it is
> mountable with standard utilities. Whether the failure is in the program
> or elsewhere I don't know, but I'm hoping it's in the program, because
> if it's elsewhere I have a *lot* of tedious digging and testing ahead of
> me and little real idea of where to start.

You could start by running the program under strace.  That should give 
you a good idea of where the problem begins.

Alan Stern

