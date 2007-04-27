Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbXD0XEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbXD0XEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbXD0XEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:04:35 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757662AbXD0XEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:04:34 -0400
Date: Fri, 27 Apr 2007 16:04:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Benedikt Spranger <b.spranger@linutronix.de>,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
Message-Id: <20070427160425.710c0230.akpm@linux-foundation.org>
In-Reply-To: <20070427224957.GA17967@kroah.com>
References: <20070427224957.GA17967@kroah.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 15:49:57 -0700
Greg KH <gregkh@suse.de> wrote:

> Here are the updated UIO (Userspace I/O driver framework) patches for
> 2.6.21.

I'm a bit uncertain about the whole UIO idea, really.  I have this vague
feeling that we'd prefer to encourage people to move device drivers into
GPL'ed kernel rather than encouraging them to do closed-source userspace
implementations which will probably end up being slower, less reliable and
unavailable on various architectures, distros, etc.

But I don't think I have the capacity to actually think about this further
- just tossing it out there ;)

> They have been revamped from the last time you have seen them, and they
> include a real driver, the Hilscher CIF DeviceNet and Profibus card
> controller, which is being used in production systems with this driver
> framework right now.  The kernel driver they replaced was a total mess,
> with over 60+ ioctls to try to control the different aspects of the
> device.  See the last patch in this series for more details on this
> driver.
> 
> These patches include full documentation, are self-contained from the
> rest of the kernel, and have been in the -mm tree for the past few
> months with no complaints.
> 
> Please pull from:
> 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/uio-2.6.git/
> 
> Patches will be sent as a follow-on to this message to lkml for people
> to see.
> 
>  drivers/uio/uio_cif.c                 |  156 ++++++++

eh?  How come a particular device requires 156 lines of kernel code to
support a userspace driver?  Doesn't that kind of defeat the point?

