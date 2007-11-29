Return-Path: <linux-kernel-owner+w=401wt.eu-S1764045AbXK2WAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764045AbXK2WAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762999AbXK2V76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:59:58 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35151 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762686AbXK2V75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:59:57 -0500
Date: Thu, 29 Nov 2007 16:59:55 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
 insert/remove race (v3)
In-Reply-To: <474F1EF9.5060306@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0711291654400.5666-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Mark Lord wrote:

> (resending with condensed version of original syslog)

(Sending a 344-KB log file wasn't enough, you had to send another 46-KB 
condensed version as well?  :-)

> Alan Stern wrote:
> > On Thu, 29 Nov 2007, Mark Lord wrote:
> >
> >> But the flogging continues multiple times per second
> >> until the system is shutdown, so it is "the next bug to fix".
> >
> > That's not true.  The number of commands sent while probing a device is
> > predetermined and strictly limited.
> ...
> 
> Please tell that to my overflowing syslog (see bottom of this post).
> But I hope that 2.6.24 does behave better, thanks.

This is a new, separate bug.  I have never seen it before -- unlike the  
oops you got, which I have known about for many months.

Alan Stern

