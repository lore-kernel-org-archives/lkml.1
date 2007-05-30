Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbXE3UEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbXE3UEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbXE3UDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:03:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44369 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbXE3UDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:03:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: Sending signals to a kernel thread, broken in 2.6.22
Date: Wed, 30 May 2007 22:09:20 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0705291649010.2974-100000@iolanthe.rowland.org> <1180528720.3976.42.camel@nigel.suspend2.net>
In-Reply-To: <1180528720.3976.42.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705302209.20963.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 30 May 2007 14:38, Nigel Cunningham wrote:
> Hi.
> 
> On Tue, 2007-05-29 at 16:55 -0400, Alan Stern wrote:
> > The g_file_storage driver uses a kernel thread and communicates with
> > that thread in part by means of signals.  It also relies on the thread 
> > receiving signals from userspace as an indication that the thread 
> > should terminate.
> > 
> > This was all working in 2.6.21, but as of 2.6.22-rc3 the signal 
> > delivery mechanism (entirely within the kernel!) is no longer 
> > functional.
> > 
> > What's the story?  Do I need to do something new and different to get 
> > signals working again?  Should I avoid using signals entirely?
> > 
> > Thanks for any help,
> > 
> > Alan Stern
> 
> Hmm. Given Oleg's reply, it could pay to check that freezable kernel
> threads are still being frozen.

I think they are.  Otherwise the freezer would have been failing.

> I'm about to go off to bed, and am away for half the day tomorrow, but
> will check as soon as I can if noone else gets to it first. (Rafael
> added for a heads-up, just in case he hasn't noticed this thread).

I have noticed it, but thanks anyway. :-)

Greetings,
Rafael
