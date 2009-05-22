Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbZEVOLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbZEVOLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbZEVOLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:11:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47636 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755203AbZEVOLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:11:37 -0400
Date: Fri, 22 May 2009 15:12:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pantelis Koukousoulas <pktoss@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: How to tell whether a struct file is held by a process?
Message-ID: <20090522151235.26432fbc@lxorguk.ukuu.org.uk>
In-Reply-To: <1295ed070905220652q55c65e8bx992940b626eecda3@mail.gmail.com>
References: <ac3eb2510905211407l3aec14acx2572a2ad4e675b9@mail.gmail.com>
	<Pine.LNX.4.44L0.0905211724050.3914-100000@iolanthe.rowland.org>
	<1295ed070905220630q67c62569o9753425abf529742@mail.gmail.com>
	<20090522144343.7b26b3a8@lxorguk.ukuu.org.uk>
	<1295ed070905220652q55c65e8bx992940b626eecda3@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Who is "me" in this case? Assuming that those writing the userspace programs
> are cooperative though, I agree. We can declare that whatever program does not

The software authors.

> play by the (userspace locking) rules is crap and either fix it (if open source)
> or refuse to install it / complain (if closed source).

Which for the general case I think is reasonable. If the bad program is
determined to be bad then it can equally just ptrace the process with the
file open and drive it that way.

> >
> >> So, if there is a clean / acceptable way to handle the reset issue in userspace
> >
> > Firstly can you explain *why* you think there is a problem ?
> >
> 
> I admit this could be a bias from the way I imagined the whole thing
> to work before
> this discussion. I think I can see how a userspace locking scheme based on port
> numbers could avoid also the reset problem

That was a serious request to understand what you think the problem is
and what problem is worrying you. I'm deeply sceptical of the need for
any kernel locking on this one but I'd like to understand better why you
think there are some cases it would be needed.
